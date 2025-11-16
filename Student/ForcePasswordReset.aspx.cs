using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using static WAPP_Assignment.DataAccess;

namespace WAPP_Assignment.Student
{
    public partial class ForcePasswordReset : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                InitPage();
        }

        private void InitPage()
        {
            litErrorPassword.Text = "";
            litErrorConfirm.Text = "";
            litErrorGeneral.Text = "";

            var (isAuth, userIdStr, userType) = AuthCookieHelper.ReadAuthCookie();

            // Only students should use this page
            if (!isAuth || string.IsNullOrEmpty(userIdStr) ||
                !string.Equals(userType, "Student", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            if (!int.TryParse(userIdStr, out int userId))
            {
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            using (var conn = GetOpenConnection())
            using (var cmd = new SqlCommand(@"
                SELECT Username, IsPasswordReset
                FROM dbo.Users
                WHERE UserId = @uid AND UserType = 'Student';
            ", conn))
            {
                cmd.Parameters.Add("@uid", SqlDbType.Int).Value = userId;

                using (var rd = cmd.ExecuteReader())
                {
                    if (!rd.Read())
                    {
                        Response.Redirect("~/Base/Landing.aspx", true);
                        return;
                    }

                    string username = rd.GetString(0);
                    bool mustReset = rd.GetBoolean(1);

                    litUsername.Text = Server.HtmlEncode(username);

                    if (!mustReset)
                    {
                        Response.Redirect("~/Student/Dashboard.aspx", true);
                        return;
                    }
                }
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            litErrorPassword.Text = "";
            litErrorConfirm.Text = "";
            litErrorGeneral.Text = "";

            string newPass = txtNewPassword.Text ?? "";
            string confirm = txtConfirmPassword.Text ?? "";

            bool hasError = false;

            if (string.IsNullOrEmpty(newPass))
            {
                litErrorPassword.Text = "Password cannot be empty.";
                hasError = true;
            }
            else if (newPass.Length < 6 || !newPass.Any(ch => !char.IsLetterOrDigit(ch)))
            {
                litErrorPassword.Text = "Password must be at least 6 chars and include a symbol.";
                hasError = true;
            }

            if (string.IsNullOrEmpty(confirm))
            {
                litErrorConfirm.Text = "Please confirm your password.";
                hasError = true;
            }
            else if (newPass != confirm)
            {
                litErrorConfirm.Text = "Passwords do not match.";
                hasError = true;
            }

            if (hasError) return;

            // validate session cookie
            var (isAuth, userIdStr, userType) = AuthCookieHelper.ReadAuthCookie();
            if (!isAuth || string.IsNullOrEmpty(userIdStr) ||
                !string.Equals(userType, "Student", StringComparison.OrdinalIgnoreCase))
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
                using (var conn = GetOpenConnection())
                using (var cmd = new SqlCommand(@"
                    UPDATE dbo.Users
                    SET PasswordHash = @p, IsPasswordReset = 0
                    WHERE UserId = @id AND UserType = 'Student';
                ", conn))
                {
                    string hash = SiteMaster.Hash(newPass);

                    cmd.Parameters.Add("@p", SqlDbType.NVarChar, 256).Value = hash;
                    cmd.Parameters.Add("@id", SqlDbType.Int).Value = userId;

                    int rows = cmd.ExecuteNonQuery();
                    if (rows <= 0)
                    {
                        litErrorGeneral.Text = "Password could not be updated. Please try again.";
                        return;
                    }
                }

                // Success → redirect to student dashboard
                Response.Redirect("~/Student/StudentDashboard.aspx", true);
            }
            catch (Exception ex)
            {
                litErrorGeneral.Text = ex.Message;
            }
        }
    }
}
