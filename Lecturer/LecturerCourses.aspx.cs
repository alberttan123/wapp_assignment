using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace WAPP_Assignment.Lecturer
{
    public partial class LecturerCourses : System.Web.UI.Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindCourses();
        }

        private int GetCurrentEducatorId()
        {
            // Use your real session value if auth is wired
            if (Session["UserId"] is int uid) return uid;
            return 2; // fallback to geo_teacher from seed data
        }

        private void BindCourses()
        {
            lblInfo.Visible = false;

            string sql = @"
SELECT
    c.CourseId,
    c.CourseTitle,
    c.TotalLessons,
    c.CourseCreatedAt,
    c.CourseImgUrl,
    (SELECT COUNT(*) FROM dbo.Chapters ch WHERE ch.CourseId = c.CourseId) AS ChapterCount,
    (SELECT COUNT(*) FROM dbo.ChapterContents cc
        JOIN dbo.Chapters ch2 ON ch2.ChapterId = cc.ChapterId
     WHERE ch2.CourseId = c.CourseId AND cc.ContentType = 'Quiz') AS QuizCount
FROM dbo.Courses c
WHERE c.LecturerId = @uid";

            // Optional title search
            if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                sql += " AND c.CourseTitle LIKE @search";

            sql += " ORDER BY c.CourseTitle ASC;";

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, con))
            using (var da = new SqlDataAdapter(cmd))
            {
                cmd.Parameters.AddWithValue("@uid", GetCurrentEducatorId());
                if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                    cmd.Parameters.AddWithValue("@search", "%" + txtSearch.Text.Trim() + "%");

                var dt = new DataTable();
                da.Fill(dt);

                rptCourses.DataSource = dt;
                rptCourses.DataBind();

                if (dt.Rows.Count == 0)
                {
                    lblInfo.Text = "No courses found for your account.";
                    lblInfo.Visible = true;
                }
            }
        }

        // This is called from the <%# ... %> binding in the .aspx
        protected string GetBannerUrl(object courseImgUrl)
        {
            string img = null;

            if (courseImgUrl != null && courseImgUrl != DBNull.Value)
            {
                img = courseImgUrl as string ?? courseImgUrl.ToString();
            }

            if (string.IsNullOrWhiteSpace(img))
            {
                // Use default banner when no course-specific image is set
                return ResolveUrl("~/Media/pages-default-banner.jpg");
            }

            // Course has its own banner path saved in DB
            return ResolveUrl(img);
        }

        protected void TxtSearch_TextChanged(object sender, EventArgs e)
        {
            BindCourses();
        }

        protected void RptCourses_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "delete")
            {
                if (!int.TryParse((string)e.CommandArgument, out int courseId))
                    return;

                using (var con = new SqlConnection(ConnStr))
                {
                    con.Open();
                    using (var tx = con.BeginTransaction())
                    {
                        try
                        {
                            // 1) Remove dependent rows safely (no FK cascades defined)

                            // Remove ChapterContents for chapters under this course
                            using (var cmd = new SqlCommand(@"
DELETE cc
FROM dbo.ChapterContents cc
JOIN dbo.Chapters ch ON ch.ChapterId = cc.ChapterId
WHERE ch.CourseId = @cid;", con, tx))
                            {
                                cmd.Parameters.AddWithValue("@cid", courseId);
                                cmd.ExecuteNonQuery();
                            }

                            // Remove Chapters
                            using (var cmd = new SqlCommand(@"
DELETE FROM dbo.Chapters WHERE CourseId = @cid;", con, tx))
                            {
                                cmd.Parameters.AddWithValue("@cid", courseId);
                                cmd.ExecuteNonQuery();
                            }

                            // Remove Bookmarks
                            using (var cmd = new SqlCommand(@"
DELETE FROM dbo.Bookmarks WHERE CourseId = @cid;", con, tx))
                            {
                                cmd.Parameters.AddWithValue("@cid", courseId);
                                cmd.ExecuteNonQuery();
                            }

                            // Remove Enrollments
                            using (var cmd = new SqlCommand(@"
DELETE FROM dbo.Enrollments WHERE CourseId = @cid;", con, tx))
                            {
                                cmd.Parameters.AddWithValue("@cid", courseId);
                                cmd.ExecuteNonQuery();
                            }

                            // 2) Finally, delete Course
                            using (var cmd = new SqlCommand(@"
DELETE FROM dbo.Courses WHERE CourseId = @cid;", con, tx))
                            {
                                cmd.Parameters.AddWithValue("@cid", courseId);
                                cmd.ExecuteNonQuery();
                            }

                            tx.Commit();
                        }
                        catch
                        {
                            tx.Rollback();
                            // Optional: surface an error label if needed
                        }
                    }
                }

                BindCourses();
            }
        }
    }
}
