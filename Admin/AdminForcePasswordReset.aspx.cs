using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;

namespace WAPP_Assignment.Admin
{
    public partial class AdminForcePasswordReset : Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitPage();
            }
        }

        private void InitPage()
        {
            litErrorPassword.Text = string.Empty;
            litErrorConfirm.Text = string.Empty;
            litErrorGeneral.Text = string.Empty;

            var (isAuth, userIdStr, userType) = AuthCookieHelper.ReadAuthCookie();

            if (!isAuth || string.IsNullOrEmpty(userIdStr) ||
                !string.Equals(userType, "Admin", StringComparison.OrdinalIgnoreCase))
            {
                // Only admins can use this page
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            if (!int.TryParse(userIdStr, out int userId))
            {
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
                SELECT Username, IsPasswordReset
                FROM dbo.Users
                WHERE UserId = @id AND UserType = 'Admin';", con))
            {
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = userId;

                con.Open();
                using (var rd = cmd.ExecuteReader())
                {
                    if (!rd.Read())
                    {
                        // Not found / not admin
                        Response.Redirect("~/Base/Landing.aspx", true);
                        return;
                    }

                    string username = rd.GetString(rd.GetOrdinal("Username"));
                    bool isResetRequired = rd.GetBoolean(rd.GetOrdinal("IsPasswordReset"));

                    litUsername.Text = Server.HtmlEncode(username);

                    // If reset is no longer required, send them to dashboard
                    if (!isResetRequired)
                    {
                        Response.Redirect("~/Admin/AdminDashboard.aspx", true);
                        return;
                    }
                }
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            litErrorPassword.Text = string.Empty;
            litErrorConfirm.Text = string.Empty;
            litErrorGeneral.Text = string.Empty;

            string newPassword = (txtNewPassword.Text ?? string.Empty);
            string confirmPassword = (txtConfirmPassword.Text ?? string.Empty);

            bool hasError = false;

            if (string.IsNullOrEmpty(newPassword))
            {
                litErrorPassword.Text = "Password cannot be empty.";
                hasError = true;
            }
            else if (newPassword.Length < 6 || !newPassword.Any(ch => !char.IsLetterOrDigit(ch)))
            {
                litErrorPassword.Text = "Password must be >6 characters and contain at least 1 symbol.";
                hasError = true;
            }

            if (string.IsNullOrEmpty(confirmPassword))
            {
                litErrorConfirm.Text = "Please confirm your password.";
                hasError = true;
            }
            else if (!string.Equals(newPassword, confirmPassword))
            {
                litErrorConfirm.Text = "Passwords do not match.";
                hasError = true;
            }

            if (hasError)
            {
                return;
            }

            var (isAuth, userIdStr, userType) = AuthCookieHelper.ReadAuthCookie();

            if (!isAuth || string.IsNullOrEmpty(userIdStr) ||
                !string.Equals(userType, "Admin", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            if (!int.TryParse(userIdStr, out int userId))
            {
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            try
            {
                using (var con = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand(@"
                    UPDATE dbo.Users
                    SET PasswordHash = @p, IsPasswordReset = 0
                    WHERE UserId = @id AND UserType = 'Admin';", con))
                {
                    string hash = SiteMaster.Hash(newPassword);

                    cmd.Parameters.Add("@p", SqlDbType.NVarChar, 256).Value = hash;
                    cmd.Parameters.Add("@id", SqlDbType.Int).Value = userId;

                    con.Open();
                    int rows = cmd.ExecuteNonQuery();
                    if (rows <= 0)
                    {
                        litErrorGeneral.Text = "Password could not be updated. Please try again.";
                        return;
                    }
                }

                // Success → go to admin dashboard
                Response.Redirect("~/Admin/AdminDashboard.aspx", true);
            }
            catch (Exception ex)
            {
                litErrorGeneral.Text = ex.Message;
            }
        }
    }
}
