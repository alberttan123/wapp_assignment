using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static WAPP_Assignment.DataAccess;

namespace WAPP_Assignment.Student
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected string StudentName { get; private set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["UserId"] = 1; //Testing

            if (!IsPostBack)
            {
                StudentName = LoadStudentName();
                BindEnrollmentData();
            }
        }
        private int ResolveUserId()
        {
            if (int.TryParse(Request.QueryString["userId"], out var uid))
                return uid;

            return Convert.ToInt32(Session["UserId"]);
        }
        private void BindEnrollmentData()
        {
            int userId = ResolveUserId();

            using (var conn = DataAccess.GetOpenConnection())
            using (var cmd = new SqlCommand(@"
                SELECT  e.EnrollmentId, e.UserId, e.CourseId, e.ProgressPercent,
                        e.StartedAt, e.LastAccessedAt, e.CompletedAt,
                        c.CourseTitle, c.CourseImgUrl, c.TotalLessons
                FROM dbo.Enrollments e
                JOIN dbo.Courses c ON c.CourseId = e.CourseId
                WHERE e.UserId = @UserId
                ORDER BY ISNULL(e.LastAccessedAt, e.StartedAt) DESC, e.EnrollmentId DESC;", conn))
            {
                cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = userId;

                using (var da = new SqlDataAdapter(cmd))
                using (var table = new DataTable())
                {
                    da.Fill(table);

                    // list
                    rptEnrollments.DataSource = table;
                    rptEnrollments.DataBind();

                    // empty state
                    pnlEmpty.Visible = table.Rows.Count == 0;

                    // summary counters + quick action
                    int total = table.Rows.Count, completed = 0, inProg = 0;
                    foreach (DataRow r in table.Rows)
                    {
                        var pct = r.Field<decimal>("ProgressPercent");
                        bool done = r["CompletedAt"] != DBNull.Value || pct >= 100m;
                        if (done) completed++; else inProg++;
                    }

                    lblTotalEnrolled.Text = total.ToString();
                    lblInProgress.Text = inProg.ToString();
                    lblCompleted.Text = completed.ToString();
                    lblQuickEnrolled.Text = total.ToString(); // quick-action badge
                }
            }
        }
        private string LoadStudentName()
        {
            try
            {
                // Check if user is logged in (UserId stored in Session)
                if (Session["UserId"] != null)
                {
                    int userId = Convert.ToInt32(Session["UserId"]);
                    return GetStudentNameFromDatabase(userId);
                }
                else
                {
                    // Default value if not logged in
                    return StudentName = "Guest";
                }
            }
            catch (Exception ex)
            {
                // Log error and set default
                System.Diagnostics.Debug.WriteLine($"Error loading student data: {ex.Message}");
                return StudentName = "Student";
            }
        }


        private string GetStudentNameFromDatabase(int userId)
        {
            try
            {
                using (SqlConnection conn = DataAccess.GetOpenConnection())
                {
                    // Query to get username - adjust column names based on your actual database
                    // Common column names: Username, FirstName, LastName, Name, UserName
                    string query = "SELECT Username FROM Users WHERE UserId = @UserId";
                        

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);

                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                        {
                            return StudentName = result.ToString();
                        }
                        else
                        {
                            return StudentName = "Student";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Database error: {ex.Message}");
                return StudentName = "Student";
            }
        }
    }
} 