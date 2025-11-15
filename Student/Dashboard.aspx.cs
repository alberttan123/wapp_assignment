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
    }


}