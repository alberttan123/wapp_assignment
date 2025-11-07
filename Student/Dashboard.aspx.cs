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
        protected string StudentName { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is authenticated
            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();
            
            if (!isAuthenticated || string.IsNullOrEmpty(userId))
            {
                // Redirect to login if not authenticated
                Response.Redirect("~/Default.aspx", true);
                return;
            }

            // Store UserId in Session for backward compatibility
            if (Session["UserId"] == null)
            {
                Session["UserId"] = int.Parse(userId);
            }

            if (!IsPostBack)
            {
                StudentName = LoadStudentName();
                BindEnrollmentData();
                BindFlashcardsData(); // Still needed for Quick Actions badge
            }
        }
        
        private int ResolveUserId()
        {
            // First try to get from query string (for admin viewing)
            if (int.TryParse(Request.QueryString["userId"], out var uid))
                return uid;

            // Try to get from authentication cookie
            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();
            if (isAuthenticated && !string.IsNullOrEmpty(userId))
            {
                return int.Parse(userId);
            }

            // Fallback to Session (for backward compatibility)
            if (Session["UserId"] != null)
            {
                return Convert.ToInt32(Session["UserId"]);
            }

            // If no user found, redirect to login
            Response.Redirect("~/Default.aspx", true);
            return 0; // This won't be reached due to redirect
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

                    rptCoursesDropdown.DataSource = table;
                    rptCoursesDropdown.DataBind();

                    pnlCoursesDropdownEmpty.Visible = table.Rows.Count == 0;

                    int total = table.Rows.Count;
                    lblQuickEnrolled.Text = total.ToString();
                }
            }
        }

        private void BindFlashcardsData()
        {
            int userId = ResolveUserId();

            using (var conn = DataAccess.GetOpenConnection())
            using (var cmd = new SqlCommand(@"
                SELECT COUNT(*) as TotalFlashcards
                FROM dbo.Bookmarks
                WHERE UserId = @UserId;", conn))
            {
                cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = userId;

                object result = cmd.ExecuteScalar();
                int total = result != null && result != DBNull.Value ? Convert.ToInt32(result) : 0;
                lblQuickFlashcards.Text = total.ToString();
            }
        }

        private string LoadStudentName()
        {
            try
            {
                int userId = ResolveUserId();
                if (userId > 0)
                {
                    return GetStudentNameFromDatabase(userId);
                }
                else
                {
                    return StudentName = "Guest";
                }
            }
            catch (Exception ex)
            {
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

        protected void Logout(object sender, EventArgs e)
        {
            // Remove authentication cookie
            AuthCookieHelper.RemoveAuthCookie();
            
            // Clear session
            Session.Clear();
            Session.Abandon();
            
            // Redirect to home page
            Response.Redirect("~/Default.aspx", true);
        }
    }
} 