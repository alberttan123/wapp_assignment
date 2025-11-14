using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static WAPP_Assignment.DataAccess;

namespace WAPP_Assignment
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CheckAuthenticationStatus();
            }
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

        protected void showLoginSignupModal(object sender, EventArgs e) 
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
                SELECT TOP 1 UserId, Username, PasswordHash, UserType
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

                        // Decide where to send them based on role
                        string userType = rd.GetString(rd.GetOrdinal("UserType"));

                        if (string.Equals(userType, "Educator", StringComparison.OrdinalIgnoreCase))
                        {
                            // Lecturer area home
                            Response.Redirect("~/Lecturer/LecturerDashboard.aspx", true);
                        }
                        else if (string.Equals(userType, "Student", StringComparison.OrdinalIgnoreCase))
                        {
                            // Existing student dashboard
                            Response.Redirect("~/Student/Dashboard.aspx", true);
                        }
                        else
                        {
                            // Fallback for Admin/unknown roles
                            Response.Redirect("~/Base/Landing.aspx", true);
                        }

                        return;
                    }
                }
            }
            catch(Exception ex)
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
                    // Try Students
                    using (var cmd = new SqlCommand(@"
                        INSERT INTO dbo.Users (Username, Email, UserType, PasswordHash) VALUES
                        (@u, @e, @t, @p)", conn))
                    {
                        cmd.Parameters.AddWithValue("@u", username);
                        cmd.Parameters.AddWithValue("@e", email);
                        cmd.Parameters.AddWithValue("@t", usertype);
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
            var hash = rd.GetString(rd.GetOrdinal("PasswordHash"));
            if (password == hash) //simple comparison TODO: CHANGE TO HASH COMPARISON
            {
                return true;
            }
            return false;
        }

        private void SignIn(SqlDataReader rd) 
        {
            var UserId = rd.GetInt32(rd.GetOrdinal("UserId")).ToString();
            var userType = rd.GetString(rd.GetOrdinal("UserType"));
            HttpCookie cookie = AuthCookieHelper.BuildAuthCookie(UserId, userType);
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
    }
}