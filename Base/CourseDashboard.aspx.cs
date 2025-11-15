using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using static WAPP_Assignment.DataAccess;
using WAPP_Assignment; // for AuthCookieHelper

namespace WAPP_Assignment.Base
{
    public partial class CourseDashboard : System.Web.UI.Page
    {
        // Simple DTO for rendering
        private class CourseCardDto
        {
            public int CourseId { get; set; }
            public string Title { get; set; }
            public string Description { get; set; }
            public string ImageUrl { get; set; }
            public string LecturerUsername { get; set; }
            public int LessonCount { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // First, handle actions from card clicks (may redirect or show modal)
            HandleActionFromQuery();

            if (!IsPostBack)
            {
                LoadCourses();
            }
        }

        // ---------------------------------------------------------
        // 1. Load courses & render grid
        // ---------------------------------------------------------
        private void LoadCourses()
        {
            var courses = new List<CourseCardDto>();

            using (var conn = GetOpenConnection())
            using (var cmd = new SqlCommand(@"
                SELECT 
                    c.CourseId,
                    c.CourseTitle,
                    c.CourseDescription,
                    c.CourseImgUrl,
                    u.Username AS LecturerUsername,
                    COUNT(ch.ChapterId) AS LessonCount
                FROM dbo.Courses c
                JOIN dbo.Users u
                    ON c.LecturerId = u.UserId
                LEFT JOIN dbo.Chapters ch
                    ON ch.CourseId = c.CourseId
                GROUP BY 
                    c.CourseId,
                    c.CourseTitle,
                    c.CourseDescription,
                    c.CourseImgUrl,
                    u.Username,
                    c.CourseCreatedAt
                ORDER BY c.CourseCreatedAt DESC;
            ", conn))
            using (var rd = cmd.ExecuteReader())
            {
                while (rd.Read())
                {
                    var dto = new CourseCardDto
                    {
                        CourseId = rd.GetInt32(0),
                        Title = rd.GetString(1),
                        Description = rd.IsDBNull(2) ? "" : rd.GetString(2),
                        ImageUrl = rd.IsDBNull(3) ? "" : rd.GetString(3),
                        LecturerUsername = rd.GetString(4),
                        LessonCount = rd.GetInt32(5)
                    };

                    courses.Add(dto);
                }
            }

            RenderCourses(courses);
        }

        private void RenderCourses(List<CourseCardDto> courses)
        {
            CourseGrid.Controls.Clear();

            foreach (var c in courses)
            {
                // Outer wrapper
                var wrapper = new HtmlGenericControl("div");
                wrapper.Attributes["class"] = "garden-card-wrapper";

                // Click target: always goes through CourseDashboard with action=open
                var anchor = new HtmlAnchor();
                anchor.HRef = ResolveUrl(
                    $"~/Base/CourseDashboard.aspx?action=open&CourseId={c.CourseId}");
                anchor.Attributes["class"] = "garden-card";

                // --- Image section ---
                var imageDiv = new HtmlGenericControl("div");
                imageDiv.Attributes["class"] = "garden-image";

                var img = new Image();
                img.AlternateText = "Course Image";
                // If no image, you can plug a default URL
                img.ImageUrl = string.IsNullOrEmpty(c.ImageUrl)
                    ? ResolveUrl("~/assets/images/default-course.jpg")
                    : c.ImageUrl;

                imageDiv.Controls.Add(img);
                anchor.Controls.Add(imageDiv);

                // --- Content section ---
                var contentDiv = new HtmlGenericControl("div");
                contentDiv.Attributes["class"] = "garden-content";

                var topDiv = new HtmlGenericControl("div");

                // NOTE: garden-course-num REMOVED per your instructions
                // NOTE: garden-level REMOVED per your instructions

                // Title
                var title = new HtmlGenericControl("h3");
                title.Attributes["class"] = "garden-title";
                title.InnerText = c.Title;

                // Description (keep lorem or real text)
                var desc = new HtmlGenericControl("p");
                desc.Attributes["class"] = "garden-desc";
                desc.InnerText = c.Description;

                topDiv.Controls.Add(title);
                topDiv.Controls.Add(desc);

                // Stats (lecturer + lessons)
                var stats = new HtmlGenericControl("div");
                stats.Attributes["class"] = "garden-stats";

                // Lecturer name (optional extra line)
                var lecturerSpan = new HtmlGenericControl("span");
                lecturerSpan.Attributes["class"] = "garden-lecturer";
                lecturerSpan.InnerText = c.LecturerUsername;

                // Lessons count
                var lessonsSpan = new HtmlGenericControl("span");
                lessonsSpan.Attributes["class"] = "garden-progress-text";
                lessonsSpan.InnerText = $"{c.LessonCount} lessons";

                stats.Controls.Add(lecturerSpan);
                stats.Controls.Add(lessonsSpan);

                contentDiv.Controls.Add(topDiv);
                contentDiv.Controls.Add(stats);

                anchor.Controls.Add(contentDiv);
                wrapper.Controls.Add(anchor);

                CourseGrid.Controls.Add(wrapper);
            }
        }

        // ---------------------------------------------------------
        // 2. Handle clicks on cards via ?action=open&CourseId=X
        // ---------------------------------------------------------
        private void HandleActionFromQuery()
        {
            string action = Request.QueryString["action"];
            string courseIdRaw = Request.QueryString["CourseId"];

            if (!string.Equals(action, "open", StringComparison.OrdinalIgnoreCase))
                return;

            if (!int.TryParse(courseIdRaw, out int courseId))
                return;

            var (isAuthenticated, userIdStr, userType) = AuthCookieHelper.ReadAuthCookie();

            // Not logged in → TryOut
            if (!isAuthenticated || string.IsNullOrEmpty(userIdStr))
            {
                Response.Redirect(
                    $"~/Quiz/TryOut.aspx?CourseId={courseId}",
                    true);
                return;
            }

            if (!int.TryParse(userIdStr, out int userId))
                return;

            // Logged in → check enrollment
            if (IsUserEnrolled(userId, courseId))
            {
                // Already enrolled → go to course view
                Response.Redirect(
                    $"~/Student/ViewCourse.aspx?CourseId={courseId}",
                    true);
            }
            else
            {
                // Not enrolled → show enroll modal
                ShowEnrollModal(courseId);
            }
        }

        private bool IsUserEnrolled(int userId, int courseId)
        {
            using (var conn = GetOpenConnection())
            using (var cmd = new SqlCommand(@"
                SELECT 1
                FROM dbo.Enrollments
                WHERE UserId = @UserId AND CourseId = @CourseId;
            ", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@CourseId", courseId);

                object result = cmd.ExecuteScalar();
                return result != null;
            }
        }

        private void ShowEnrollModal(int courseId)
        {
            SelectedCourseId.Value = courseId.ToString();
            EnrollModal.Visible = true;
        }

        // ---------------------------------------------------------
        // 3. Modal button handlers
        // ---------------------------------------------------------
        protected void btnConfirmEnroll_Click(object sender, EventArgs e)
        {
            var (isAuthenticated, userIdStr, userType) = AuthCookieHelper.ReadAuthCookie();

            if (!isAuthenticated || string.IsNullOrEmpty(userIdStr))
            {
                // Safety fallback – user somehow lost auth
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            if (!int.TryParse(userIdStr, out int userId))
                return;

            if (!int.TryParse(SelectedCourseId.Value, out int courseId))
                return;

            using (var conn = GetOpenConnection())
            using (var cmd = new SqlCommand(@"
                INSERT INTO dbo.Enrollments (UserId, CourseId)
                VALUES (@UserId, @CourseId);
            ", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@CourseId", courseId);

                try
                {
                    cmd.ExecuteNonQuery();
                }
                catch (SqlException)
                {
                    // Might be duplicate due to UQ_Enrollments_User_Course – ignore for now
                }
            }

            // After enrolling, send to course view
            Response.Redirect($"~/Student/ViewCourse.aspx?CourseId={courseId}", true);
        }

        protected void btnCancelEnroll_Click(object sender, EventArgs e)
        {
            EnrollModal.Visible = false;
        }
    }
}
