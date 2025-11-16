using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPP_Assignment.Admin
{
    public partial class AdminCourses : Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Admin-only guard
            var (isAuth, userIdStr, userType) = AuthCookieHelper.ReadAuthCookie();
            if (!isAuth || string.IsNullOrEmpty(userIdStr) ||
                !string.Equals(userType, "Admin", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            if (!IsPostBack)
            {
                litGlobalMessage.Text = string.Empty;
                litEmptyState.Text = string.Empty;
                BindLecturerFilter();
                BindCourses();
            }
        }

        private void BindLecturerFilter()
        {
            ddlLecturerFilter.Items.Clear();

            ddlLecturerFilter.Items.Add(new ListItem("All lecturers", string.Empty));

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
                SELECT UserId,
                       COALESCE(NULLIF(FullName, ''), Username) AS DisplayName
                FROM dbo.Users
                WHERE UserType = 'Educator'
                ORDER BY DisplayName;", con))
            {
                con.Open();
                using (var rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        int id = rd.GetInt32(rd.GetOrdinal("UserId"));
                        string name = rd.GetString(rd.GetOrdinal("DisplayName"));
                        ddlLecturerFilter.Items.Add(new ListItem(name, id.ToString()));
                    }
                }
            }
        }

        private void BindCourses()
        {
            litGlobalMessage.Text = string.Empty;
            litEmptyState.Text = string.Empty;

            string search = (txtSearch.Text ?? string.Empty).Trim();
            int lecturerId;
            bool hasLecturerFilter = int.TryParse(ddlLecturerFilter.SelectedValue, out lecturerId);

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand())
            using (var da = new SqlDataAdapter(cmd))
            {
                cmd.Connection = con;

                string sql = @"
                    SELECT
                        c.CourseId,
                        c.CourseTitle,
                        c.CourseDescription,
                        c.TotalLessons,
                        c.CourseCreatedAt,
                        u.FullName,
                        u.Username
                    FROM dbo.Courses c
                    INNER JOIN dbo.Users u ON c.LecturerId = u.UserId
                    WHERE 1 = 1";

                if (!string.IsNullOrEmpty(search))
                {
                    sql += @"
                      AND (c.CourseTitle LIKE @Search OR c.CourseDescription LIKE @Search)";
                    cmd.Parameters.Add("@Search", SqlDbType.NVarChar, 200)
                        .Value = "%" + search + "%";
                }

                if (hasLecturerFilter)
                {
                    sql += @"
                      AND c.LecturerId = @LecturerId";
                    cmd.Parameters.Add("@LecturerId", SqlDbType.Int).Value = lecturerId;
                }

                sql += @"
                    ORDER BY u.FullName, c.CourseTitle;";

                cmd.CommandText = sql;

                var table = new DataTable();
                da.Fill(table);

                if (!table.Columns.Contains("LecturerNameDisplay"))
                    table.Columns.Add("LecturerNameDisplay", typeof(string));
                if (!table.Columns.Contains("CourseDescriptionDisplay"))
                    table.Columns.Add("CourseDescriptionDisplay", typeof(string));

                foreach (DataRow row in table.Rows)
                {
                    string fullName = row["FullName"] as string;
                    string username = row["Username"] as string;
                    string desc = row["CourseDescription"] as string;

                    string lecturerDisplay = !string.IsNullOrWhiteSpace(fullName)
                        ? fullName
                        : username;

                    row["LecturerNameDisplay"] = lecturerDisplay;

                    if (string.IsNullOrWhiteSpace(desc))
                    {
                        row["CourseDescriptionDisplay"] = "(No description provided)";
                    }
                    else
                    {
                        if (desc.Length > 260)
                        {
                            row["CourseDescriptionDisplay"] = desc.Substring(0, 260) + "...";
                        }
                        else
                        {
                            row["CourseDescriptionDisplay"] = desc;
                        }
                    }
                }

                rptCourses.DataSource = table;
                rptCourses.DataBind();

                int count = table.Rows.Count;
                litCourseCount.Text = count == 1
                    ? "Showing 1 course"
                    : $"Showing {count} courses";

                if (count == 0)
                {
                    litEmptyState.Text = "<div class=\"ac-empty\">No courses found for the current filters.</div>";
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindCourses();
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            // Hitting Enter in the search box will trigger this
            BindCourses();
        }

        protected void btnClearSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            BindCourses();
        }

        protected void ddlLecturerFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindCourses();
        }

        protected void rptCourses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "delete")
            {
                int courseId;
                if (int.TryParse(e.CommandArgument.ToString(), out courseId))
                {
                    HandleDeleteCourse(courseId);
                }
            }
        }

        private void HandleDeleteCourse(int courseId)
        {
            litGlobalMessage.Text = string.Empty;

            using (var con = new SqlConnection(ConnStr))
            {
                con.Open();

                string courseTitle;

                using (var cmd = new SqlCommand(@"
                    SELECT CourseTitle
                    FROM dbo.Courses
                    WHERE CourseId = @id;", con))
                {
                    cmd.Parameters.Add("@id", SqlDbType.Int).Value = courseId;

                    var obj = cmd.ExecuteScalar();
                    if (obj == null)
                    {
                        litGlobalMessage.Text = "Course not found.";
                        BindCourses();
                        return;
                    }

                    courseTitle = obj.ToString();
                }

                using (var cmd = new SqlCommand(@"
                    IF EXISTS (SELECT 1 FROM dbo.Chapters   WHERE CourseId = @id)
                       OR EXISTS (SELECT 1 FROM dbo.Enrollments WHERE CourseId = @id)
                       OR EXISTS (SELECT 1 FROM dbo.Bookmarks  WHERE CourseId = @id)
                    SELECT 1
                    ELSE
                    SELECT 0;", con))
                {
                    cmd.Parameters.Add("@id", SqlDbType.Int).Value = courseId;

                    var flagObj = cmd.ExecuteScalar();
                    bool hasRefs = flagObj != null && Convert.ToInt32(flagObj) == 1;

                    if (hasRefs)
                    {
                        litGlobalMessage.Text =
                            "Cannot delete course '" + Server.HtmlEncode(courseTitle) +
                            "' because it has related chapters, enrollments, or bookmarks.";
                        BindCourses();
                        return;
                    }
                }

                using (var cmd = new SqlCommand(@"
                    DELETE FROM dbo.Courses
                    WHERE CourseId = @id;", con))
                {
                    cmd.Parameters.Add("@id", SqlDbType.Int).Value = courseId;

                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        litGlobalMessage.Text =
                            "Course '" + Server.HtmlEncode(courseTitle) + "' has been deleted.";
                    }
                    else
                    {
                        litGlobalMessage.Text = "Course could not be deleted.";
                    }
                }
            }

            BindCourses();
        }
    }
}
