using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using static WAPP_Assignment.DataAccess;

namespace WAPP_Assignment
{
    public partial class SiteMaster : MasterPage, MasterPageInterface
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CheckAuthenticationStatus();
            CheckNavbarVisibility();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            CheckNavbarVisibility();
        }

        private void CheckNavbarVisibility()
        {
            try
            {
                // Read cookie directly from Request - this works immediately even after redirects
                string userType = null;
                bool isAuthenticated = false;
                
                HttpCookie authCookie = Request.Cookies["AuthCookie"];
                if (authCookie != null && !string.IsNullOrEmpty(authCookie.Value))
                {
                    try
                    {
                        var ticket = FormsAuthentication.Decrypt(authCookie.Value);
                        if (ticket != null)
                        {
                            userType = ticket.UserData;
                            isAuthenticated = !string.IsNullOrEmpty(ticket.Name);
                        }
                    }
                    catch { }
                }
                
                // Fallback to helper if direct read didn't work
                if (string.IsNullOrEmpty(userType))
                {
                    var (auth, userId, ut) = AuthCookieHelper.ReadAuthCookie();
                    if (auth && !string.IsNullOrEmpty(ut))
                    {
                        userType = ut;
                        isAuthenticated = auth;
                    }
                }
                
                // Check if user is an educator
                bool isEducator = isAuthenticated && 
                                !string.IsNullOrEmpty(userType) && 
                                string.Equals(userType, "Educator", StringComparison.OrdinalIgnoreCase);
                
                // Check if we're on a forum page
                string currentPath = Request.Url.AbsolutePath.ToLower();
                bool isForumPage = currentPath.Contains("/forum/");
                
                if (isEducator && isForumPage)
                {
                    // Hide navbar for educators on forum pages
                    if (pnlNavbar != null)
                    {
                        pnlNavbar.Visible = false;
                    }
                    
                    // Add CSS style block using Literal control - this is more reliable
                    if (litEducatorNavbarHide != null)
                    {
                        litEducatorNavbarHide.Text = @"<style type=""text/css"">
                            .navbar, nav.navbar, #mainNavbar, #pnlNavbar, nav { 
                                display: none !important; 
                                visibility: hidden !important; 
                                height: 0 !important; 
                                overflow: hidden !important; 
                                margin: 0 !important;
                                padding: 0 !important;
                            }
                            .main-content { margin-top: 0 !important; }
                        </style>";
                    }
                }
                else
                {
                    // Not educator on forum page - clear the style and show navbar
                    if (litEducatorNavbarHide != null)
                    {
                        litEducatorNavbarHide.Text = "";
                    }
                    if (pnlNavbar != null)
                    {
                        pnlNavbar.Visible = true;
                    }
                }
            }
            catch { }
        }

        private void CheckAuthenticationStatus()
        {
            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();

            if (isAuthenticated && !string.IsNullOrEmpty(userId))
            {
                // User is authenticated - show profile dropdown
                pnlNotAuthenticated.Visible = false;
                pnlAuthenticated.Visible = true;
            }
            else
            {
                // User is not authenticated - show login/register
                pnlNotAuthenticated.Visible = true;
                pnlAuthenticated.Visible = false;
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

        public void showLoginSignupModal(object sender, EventArgs e) 
        { 
            loginModal.Visible = true;
        }

        protected void hideModals(object sender, EventArgs e)
        {
            loginModal.Visible = false;
            registerModal.Visible = false;
        }

        protected void swapToRegister(object sender, EventArgs e)
        {
            registerModal.Visible = true;
            register_field_1.Visible = true;
            loginModal.Visible = false;
            register_field_2.Visible = false;
        }

        protected void swapToLogin(object sender, EventArgs e)
        {
            loginModal.Visible = true;
            registerModal.Visible = false;
        }

        protected void showPrevRegisterPanel(object sender, EventArgs e)
        {
            register_field_1.Visible = true;
            register_field_2.Visible = false;
        }

        protected void showNextRegisterPanel(object sender, EventArgs e)
        {
            register_field_2.Visible = true;
            register_field_1.Visible = false;
        }

        protected void login(object sender, EventArgs e)
        {
            login_error_message.Text = "";
            login_error_message.Visible = false;

            var username = LOGINusername.Text.Trim();
            var password = LOGINpassword.Text;

            try
            {
                using (var conn = DataAccess.GetOpenConnection())
                using (var cmd = new SqlCommand(@"
                SELECT TOP 1 UserId, Username, PasswordHash, UserType, IsPasswordReset
                FROM dbo.Users 
                WHERE Username = @u", conn))
                {
                    cmd.Parameters.AddWithValue("@u", username);

                    using (var rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read())
                        {
                            ShowLoginError("Username does not exist.");
                            return;
                        }

                        if (!Verify(rd, password))
                        {
                            ShowLoginError("Username password combination does not match.");
                            return;
                        }

                        // Success → issue auth cookie
                        SignIn(rd);

                        int userId = rd.GetInt32(rd.GetOrdinal("UserId"));
                        updateLastLogin(userId);
                        //updates last login to current date time

                        // Decide where to send them based on role
                        string userType = rd.GetString(rd.GetOrdinal("UserType"));

                        bool isResetRequired = false;
                        int idxReset = rd.GetOrdinal("IsPasswordReset");
                        if (!rd.IsDBNull(idxReset))
                        {
                            isResetRequired = rd.GetBoolean(idxReset);
                        }

                        // Reader no longer needed
                        rd.Close();

                        // Update LastLogin (stored in UTC)
                        using (var updateCmd = new SqlCommand(@"
                            UPDATE dbo.Users
                            SET LastLogin = SYSUTCDATETIME()
                            WHERE UserId = @id;", conn))
                        {
                            updateCmd.Parameters.Add("@id", SqlDbType.Int).Value = userId;
                            updateCmd.ExecuteNonQuery();
                        }

                        // Issue auth cookie
                        SignIn(userId, userType);

                        // Decide where to send them based on role + reset flag
                        if (string.Equals(userType, "Educator", StringComparison.OrdinalIgnoreCase))
                        {
                            // Lecturer: force password change if reset required
                            if (isResetRequired)
                            {
                                Response.Redirect("~/Lecturer/LecturerForcePasswordReset.aspx", true);
                            }
                            else
                            {
                                Response.Redirect("~/Lecturer/LecturerDashboard.aspx", true);
                            }
                        }
                        else if (string.Equals(userType, "Student", StringComparison.OrdinalIgnoreCase))
                        {
                            // Student dashboard
                            Response.Redirect("~/Student/Dashboard.aspx", true);
                        }
                        else if (string.Equals(userType, "Admin", StringComparison.OrdinalIgnoreCase))
                        {
                            // Admin: force password change if reset required
                            if (isResetRequired)
                            {
                                Response.Redirect("~/Admin/AdminForcePasswordReset.aspx", true);
                            }
                            else
                            {
                                Response.Redirect("~/Admin/AdminDashboard.aspx", true);
                            }
                        }
                        else
                        {
                            // Fallback
                            Response.Redirect("~/Base/Landing.aspx", true);
                        }

                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowLoginError(ex.ToString()); // show error
            }
        }

        protected void Register(object sender, EventArgs e)
        {
            string username = REGISTERusername.Text.Trim();
            string email = REGISTERemail.Text.Trim();
            string password = REGISTERpassword.Text;
            string passwordRetry = REGISTERpasswordretry.Text;
            string fullname = REGISTERfullname.Text.Trim();
            string usertype = student_radio.Checked ? "Student" : "Educator";

            //set all error messages to empty
            register__error_username.Text = "";
            register__error_email.Text = "";
            register__error_password.Text = "";
            register__error_passwordretry.Text = "";
            register__error_passwordmatch.Text = "";

            // null checks
            if (string.IsNullOrEmpty(username))
            {
                register__error_username.Text = "Username cannot be empty";
                register_field_1.Visible = true;
                register_field_2.Visible = false;
                return;
            }
            if (string.IsNullOrEmpty(email))
            {
                register__error_email.Text = "Email cannot be empty";
                register_field_1.Visible = true;
                register_field_2.Visible = false;
                return;
            }

            // email format check
            if (!IsValidEmail(email))
            {
                register_field_1.Visible = true;
                register_field_2.Visible = false;
                register__error_email.Text = "Email is not in a valid format.";
                return;
            }

            // unique checks
            using (var conn = DataAccess.GetOpenConnection())
            {
                // username unique check
                using (var cmd = new SqlCommand(@"
            SELECT TOP 1 UserId 
            FROM dbo.Users 
            WHERE Username = @u", conn))
                {
                    cmd.Parameters.AddWithValue("@u", username);

                    using (var rd = cmd.ExecuteReader())
                    {
                        if (rd.Read())
                        {
                            register_field_1.Visible = true;
                            register_field_2.Visible = false;
                            register__error_username.Text = "Username has already been taken.";
                            return;
                        }
                    }
                }

                // email unique check
                using (var cmd = new SqlCommand(@"
            SELECT TOP 1 UserId 
            FROM dbo.Users 
            WHERE Email = @e", conn))
                {
                    cmd.Parameters.AddWithValue("@e", email);

                    using (var rd = cmd.ExecuteReader())
                    {
                        if (rd.Read())
                        {
                            register_field_1.Visible = true;
                            register_field_2.Visible = false;
                            register__error_email.Text = "Email is already registered.";
                            return;
                        }
                    }
                }
            }

            // password null checks
            if (string.IsNullOrEmpty(password))
            {
                register__error_password.Text = "Password cannot be empty";
                return;
            }
            if (string.IsNullOrEmpty(passwordRetry))
            {
                register__error_passwordretry.Text = "Password cannot be empty";
                return;
            }

            //password format checks
            if (password.Length < 6 || !password.Any(ch => !char.IsLetterOrDigit(ch)))
            {
                register__error_password.Text = "Password must be >6 characters and contain at least 1 symbol.";
                return;
            }

            //password not matching
            if (password != passwordRetry)
            {
                register__error_passwordmatch.Text = "Passwords do not match.";
                return;
            }

            try
            {
                using (var conn = DataAccess.GetOpenConnection())
                {
                    using (var cmd = new SqlCommand(@"
                        INSERT INTO dbo.Users (Username, Email, UserType, PasswordHash) VALUES
                        (@u, @e, @t, @p)", conn))
                    {
                        cmd.Parameters.AddWithValue("@u", username);
                        cmd.Parameters.AddWithValue("@e", email);
                        cmd.Parameters.AddWithValue("@t", usertype);
                        password = Hash(password);
                        cmd.Parameters.AddWithValue("@p", password);
                        int rows = cmd.ExecuteNonQuery();

                        if (rows > 0)
                        {
                            loginModal.Visible = true;
                            registerModal.Visible = false;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                register__error_passwordmatch.Text = ex.ToString();
            }

        }

        private bool Verify(SqlDataReader rd, string password)
        {
            var storedHash = rd.GetString(rd.GetOrdinal("PasswordHash"));

            if (storedHash == null)
                return false;

            if (Hash(password) == storedHash)
            {
                return true;
            }
            return false;
        }

        // Legacy helper (still here if anything calls it with a reader)
        private void SignIn(SqlDataReader rd)
        {
            int userId = rd.GetInt32(rd.GetOrdinal("UserId"));
            string userType = rd.GetString(rd.GetOrdinal("UserType"));
            SignIn(userId, userType);
        }

        // New helper: sign in from values (used by login after closing reader)
        private void SignIn(int userId, string userType)
        {
            string userIdStr = userId.ToString();
            HttpCookie cookie = AuthCookieHelper.BuildAuthCookie(userIdStr, userType);
            Response.Cookies.Add(cookie);
        }

        private void ShowLoginError(string errorMessage)
        {
            login_error_message.Text = errorMessage;
            login_error_message.Visible = true;
        }

        public static bool IsValidEmail(string email)
        {
            string pattern = @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
            return Regex.IsMatch(email, pattern);
        }

        // done this way so that there is no need to Install-Package BCrypt
        public static string Hash(string input)
        {
            if (input == null)
                return null;

            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(input);
                byte[] hash = sha.ComputeHash(bytes);
                return Convert.ToBase64String(hash);
            }
        }

        public void updateLastLogin(int userId)
        {
            DateTime currentDateTime = DateTime.Now;
            string formattedDateTime = currentDateTime.ToString("yyyy-MM-dd HH:mm:ss.fffffff");
            using (var conn = DataAccess.GetOpenConnection())
            {
                string sql = "UPDATE dbo.Users SET LastLogin = @dateTimeValue WHERE UserId = @UserId";
                using (SqlCommand command = new SqlCommand(sql, conn))
                {
                    command.Parameters.AddWithValue("@dateTimeValue", currentDateTime);
                    command.Parameters.AddWithValue("@UserId", userId);
                    command.ExecuteNonQuery();
                }
            }
        }
    }
}
