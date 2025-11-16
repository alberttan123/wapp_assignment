using Microsoft.SqlServer.Server;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
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
        string UserId;
        string continueCourseId = "0";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is authenticated
            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();
            if (!isAuthenticated || string.IsNullOrEmpty(userId))
            {
                // Redirect to login if not authenticated
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            UserId = userId;

            // Store UserId in Session for backward compatibility
            if (Session["UserId"] == null)
            {
                Session["UserId"] = int.Parse(userId);
            }

            StudentName = fetchUsername() + "\n";
            UsernameLabel.Text = fetchUsername();
            BindEnrollmentData();

            loadPfp();
            FullNameLabel.Text = fetchName();
            XPLabel.Text = fetchXP();

            RankLabel.Text = fetchRank();
            RankIcon.Text = fetchRankIcon();
            RenderContinueCourse();
            RenderRecentActivity();
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
            Response.Redirect("~/Base/Landing.aspx", true);
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
                }
            }
        }

        //private void BindFlashcardsData()
        //{
        //    int userId = ResolveUserId();

        //    using (var conn = DataAccess.GetOpenConnection())
        //    using (var cmd = new SqlCommand(@"
        //        SELECT COUNT(*) as TotalFlashcards
        //        FROM dbo.Bookmarks
        //        WHERE UserId = @UserId;", conn))
        //    {
        //        cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = userId;

        //        object result = cmd.ExecuteScalar();
        //        int total = result != null && result != DBNull.Value ? Convert.ToInt32(result) : 0;
        //        lblQuickFlashcards.Text = total.ToString();
        //    }
        //}
        // AHHHHHHHHHHHHHHHHHHHHH - this section contains the code for bookmarking/favoriting a question and turning it into a flashcard
        // only implement when have time

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
            Response.Redirect("~/Base/Landing.aspx", true);
        }

        protected void loadPfp() 
        {
            using (var conn = DataAccess.GetOpenConnection())
            {
                var cmd = new SqlCommand("SELECT ProfilePictureFilePath FROM dbo.Users WHERE UserId=@id;", conn);
                cmd.Parameters.AddWithValue("@id", UserId);

                string url = string.Empty;

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        if (reader.IsDBNull(0))
                        {
                            //load defaultpfp
                            Label nopfp = new Label();
                            nopfp.Text = "👤";
                            nopfp.CssClass = "avatar-placeholder";
                            pfp_section.Controls.Add(nopfp);
                        }
                        else
                        {
                            string filePath = reader.GetString(0);
                            url = ResolveUrl(filePath);
                            System.Web.UI.WebControls.Image pfp = new System.Web.UI.WebControls.Image();
                            pfp.ImageUrl = url;
                            pfp.CssClass = "pfp-image";
                            pfp_section.Controls.Add(pfp);
                        }
                    }
                    else
                    {
                        //load defaultpfp
                        Label nopfp = new Label();
                        nopfp.Text = "👤";
                        nopfp.CssClass = "avatar-placeholder";
                        pfp_section.Controls.Add(nopfp);
                    }
                }
            }

        }

        protected void redirectToViewResults(object sender, EventArgs e)
        {
            Response.Redirect("~/Student/AllResults.aspx", true);
        }

        protected void show_edit_profile(object sender, EventArgs e)
        {
            loadPFPContent();
            EditProfileModal.Visible = true;
        }

        protected void hide_edit_profile(object sender, EventArgs e) 
        {
            EditProfileModal.Visible = false;
            EditProfileImagePanel.Controls.Clear();
        }

        protected void editProfile(object sender, EventArgs e) 
        {
            string newFullName = editFullName.Text.Trim();

            if (!string.IsNullOrEmpty(newFullName)) 
            {
                using (var conn = DataAccess.GetOpenConnection())
                using (var cmd =
                        new SqlCommand("UPDATE dbo.Users SET FullName=@newFullName WHERE UserId=@id;", conn))
                {
                    cmd.Parameters.AddWithValue("@newFullName", newFullName);
                    cmd.Parameters.AddWithValue("@id", UserId);
                    cmd.ExecuteNonQuery();
                }
            }

            if (pfp_upload.HasFile) 
            {
                var rel = SaveImage(pfp_upload, int.Parse(UserId));
                using (var conn = DataAccess.GetOpenConnection())
                using (var cmd =
                        new SqlCommand("UPDATE dbo.Users SET ProfilePictureFilePath=@pfppath WHERE UserId=@id;", conn))
                {
                    cmd.Parameters.AddWithValue("@pfppath", rel);
                    cmd.Parameters.AddWithValue("@id", UserId);
                    cmd.ExecuteNonQuery();
                }
                loadPFPContent();
            }

            EditProfileModal.Visible = false;
            EditProfileImagePanel.Controls.Clear();
        }

        private void loadPFPContent() {
            string username = fetchName();
            editFullName.Attributes.Add("placeholder", username);
            editFullName.Text = "";

            using (var conn = DataAccess.GetOpenConnection())
            {
                var cmd = new SqlCommand("SELECT ProfilePictureFilePath FROM dbo.Users WHERE UserId=@id;", conn);
                cmd.Parameters.AddWithValue("@id", UserId);

                string url = string.Empty;

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        if (reader.IsDBNull(0))
                        {
                            //load defaultpfp
                            Label nopfp = new Label();
                            nopfp.Text = "👤";
                            nopfp.CssClass = "avatar-placeholder";
                            EditProfileImagePanel.Controls.Add(nopfp);
                        }
                        else
                        {
                            string filePath = reader.GetString(0);
                            url = ResolveUrl(filePath);
                            System.Web.UI.WebControls.Image pfpImage = new System.Web.UI.WebControls.Image();
                            pfpImage.ImageUrl = ResolveUrl(url);
                            pfpImage.CssClass = "PFPEdit-image";
                            EditProfileImagePanel.Controls.Add(pfpImage);
                        }
                    }
                    else
                    {
                        //load defaultpfp
                        Label nopfp = new Label();
                        nopfp.Text = "👤";
                        nopfp.CssClass = "avatar-placeholder";
                        EditProfileImagePanel.Controls.Add(nopfp);
                    }
                }
            }
        }

        private string SaveImage(System.Web.UI.WebControls.FileUpload fu, int userId)
        {
            string folder = Server.MapPath("~/Uploads/ProfilePictures");
            if (!Directory.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }

            string ext = Path.GetExtension(fu.FileName);
            if (string.IsNullOrEmpty(ext)) ext = ".png";

            string name = $"pfp-{userId}{ext}";
            string physical = Path.Combine(folder, name);
            fu.SaveAs(physical);

            return "~/Uploads/ProfilePictures/" + name;
        }

        private string fetchName() 
        {
            try
            {
                using (SqlConnection conn = DataAccess.GetOpenConnection())
                {
                    string query = "SELECT FullName FROM dbo.Users WHERE UserId = @UserId";


                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", UserId);

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

        private string fetchUsername()
        {
            try
            {
                using (SqlConnection conn = DataAccess.GetOpenConnection())
                {
                    string query = "SELECT Username FROM dbo.Users WHERE UserId = @UserId";


                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", UserId);

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

        private string fetchXP()
        {
            string xp = "0";
            try
            {
                using (SqlConnection conn = DataAccess.GetOpenConnection())
                {
                    string query = "SELECT XP FROM dbo.Users WHERE UserId = @UserId";


                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", UserId);

                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                        {
                            xp = result.ToString();
                        }
                        else
                        {
                            xp= "0";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Database error: {ex.Message}");
                xp = "0";
            }
            return xp;
        }

        private string fetchRank() 
        {
            int xp = int.Parse(fetchXP());
            string rank = "";

            int count = 0; 
            while (xp > 0)
            {
                xp -= 50;
                count++;
            }

            if (count <= 1)
                rank = "Bronze";
            if (count == 2)
                rank  = "Silver";
            if (count >= 3)
                rank = "Gold";

            return rank;

        }

        private string fetchRankIcon()
        {
            int xp = int.Parse(fetchXP());
            string icon = "";

            int count = 0;
            while (xp > 0)
            {
                xp -= 50;
                count++;
            }

            if (count <= 1)
                icon = "🥉";
            if (count == 2)
                icon = "🥈";
            if (count >= 3)
                icon = "🥇";

            return icon;

        }

        public void ContinueCourse(object sender, EventArgs e)
        {
            Response.Redirect($@"~/Student/ViewCourse?CourseId={continueCourseId}", true);
        }

        public void RenderContinueCourse()
        {
            int userId = ResolveUserId();

            using (var conn = DataAccess.GetOpenConnection())
            using (var cmd = new SqlCommand(@"
        SELECT TOP 1 
            c.CourseTitle,
            e.ProgressPercent,
            e.LastAccessedAt,
            c.CourseId
        FROM dbo.Enrollments e
        JOIN dbo.Courses c ON c.CourseId = e.CourseId
        WHERE e.UserId = @UserId
        ORDER BY ISNULL(e.LastAccessedAt, e.StartedAt) DESC, e.EnrollmentId DESC;
    ", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);

                using (var rd = cmd.ExecuteReader())
                {
                    if (rd.Read())
                    {
                        string courseTitle = rd["CourseTitle"].ToString();
                        string completionPercent = Convert.ToInt32(rd["ProgressPercent"]).ToString();

                        string lastAccessedText;
                        if (rd["LastAccessedAt"] == DBNull.Value)
                        {
                            lastAccessedText = "Never";
                        }
                        else
                        {
                            DateTime dt = Convert.ToDateTime(rd["LastAccessedAt"]);
                            lastAccessedText = dt.ToString("yyyy-MM-dd HH:mm");
                        }

                        // assign to UI
                        course_name_modern.Text = courseTitle;
                        next_lesson_modern.Text = "Last Accessed: " + lastAccessedText;
                        progress_fill_modern.Attributes.Add("style", $"width: {completionPercent}%");
                        progress_percent_modern.Text = completionPercent + "%";

                        //assign to class attribute
                        continueCourseId = rd["CourseId"].ToString();
                    }
                    else
                    {
                        // No courses — show placeholder
                        course_name_modern.Text = "No Courses Yet";
                        next_lesson_modern.Text = "Last Accessed: --";
                        progress_fill_modern.Attributes.Add("style", "width: 0%");
                        progress_percent_modern.Text = "0%";
                    }
                }
            }
        }

        public void RenderRecentActivity()
        {
            int userId = ResolveUserId();

            using (var conn = DataAccess.GetOpenConnection())
            using (var cmd = new SqlCommand(@"
        SELECT TOP 4
            qt.UniqueId AS QuizTryId,
            qt.CreatedAt,
            q.QuizTitle,
            q.QuizType,
            c.CourseTitle
        FROM dbo.QuizTry qt
        JOIN dbo.Quiz q 
            ON q.QuizId = qt.QuizId
        JOIN dbo.ChapterContents cc
            ON cc.ContentType = 'Quiz' AND cc.LinkId = q.QuizId
        JOIN dbo.Chapters ch
            ON ch.ChapterId = cc.ChapterId
        JOIN dbo.Courses c
            ON c.CourseId = ch.CourseId
        WHERE qt.UserId = @UserId
        ORDER BY qt.CreatedAt DESC;", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);

                using (var rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        int quizTryId = Convert.ToInt32(rd["QuizTryId"]);
                        string quizTitle = rd["QuizTitle"].ToString();
                        string quizType = rd["QuizType"].ToString();
                        string courseTitle = rd["CourseTitle"].ToString();
                        DateTime createdAt = Convert.ToDateTime(rd["CreatedAt"]);
                        string createdText = createdAt.ToString("yyyy-MM-dd HH:mm");

                        // ---------------------------------------------------------
                        // DYNAMIC CALCULATION OF SCORE + XP
                        // ---------------------------------------------------------
                        int totalQuestions = 0;
                        int correctCount = 0;

                        using (var conn2 = DataAccess.GetOpenConnection())
                        using (var cmd2 = new SqlCommand(@"
                    SELECT ua.SelectedOption, q.CorrectAnswer
                    FROM dbo.UserAnswer ua
                    JOIN dbo.Questions q ON q.QuestionId = ua.QuestionId
                    WHERE ua.QuizTryId = @QuizTryId;
                ", conn2))
                        {
                            cmd2.Parameters.AddWithValue("@QuizTryId", quizTryId);

                            using (var rd2 = cmd2.ExecuteReader())
                            {
                                while (rd2.Read())
                                {
                                    totalQuestions++;

                                    int selected = rd2.GetInt32(0);
                                    int correct = rd2.GetInt32(1);

                                    if (selected == correct && selected != 0)
                                        correctCount++;
                                }
                            }
                        }

                        int scorePercent = 0;
                        if (totalQuestions > 0)
                        {
                            scorePercent = (int)Math.Round(correctCount * 100.0 / totalQuestions);
                        }

                        // ---------------------------------------------------------
                        // XP AWARD SYSTEM (MATCHING Exercise & Assessment Logic)
                        // ---------------------------------------------------------
                        int xpEarned =
                            quizType.Equals("exercise", StringComparison.OrdinalIgnoreCase)
                                ? 10
                                : (int)Math.Round(scorePercent / 2.0);

                        // ---------------------------------------------------------
                        //  Build UI Card
                        // ---------------------------------------------------------
                        Panel card = new Panel();
                        card.CssClass = "activity-item";

                        Label icon = new Label();
                        icon.CssClass = "activity-icon completed";
                        icon.Text = "✓";
                        card.Controls.Add(icon);

                        Panel content = new Panel();
                        content.CssClass = "activity-content";

                        Label title = new Label();
                        title.CssClass = "activity-title";
                        title.Text = $"Completed {quizType}: {quizTitle}";
                        content.Controls.Add(title);

                        content.Controls.Add(new LiteralControl("<br />"));

                        Label meta = new Label();
                        meta.CssClass = "activity-meta";
                        meta.Text = $"{courseTitle} • {xpEarned} XP • {createdText}";
                        content.Controls.Add(meta);

                        card.Controls.Add(content);

                        // Score badge
                        Panel badge = new Panel();
                        badge.CssClass = "activity-badge";

                        Label scoreBadge = new Label();
                        scoreBadge.CssClass = scorePercent >= 50 ? "score-badge success" : "score-badge fail";
                        scoreBadge.Text = scorePercent + "%";
                        badge.Controls.Add(scoreBadge);

                        card.Controls.Add(badge);

                        activityList.Controls.Add(card);
                    }
                }
            }
        }


        private int CalculateXPEarned(int score, string quizType)
        {
            if (quizType.Equals("Assessment", StringComparison.OrdinalIgnoreCase))
            {
                if (score >= 100) return 50;
                if (score >= 80) return 40;
                if (score >= 60) return 30;
                return 20;
            }

            // Exercises give flat XP
            return 10;
        }

    }


}