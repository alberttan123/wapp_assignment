using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace WAPP_Assignment.Admin
{
    public partial class AdminCreateUser : Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlResult.Visible = false;
            }
        }

        protected void btnCreateUser_Click(object sender, EventArgs e)
        {
            ClearErrors();
            pnlResult.Visible = false;
            txtTempPassword.Text = string.Empty;

            string fullName = (txtFullName.Text ?? string.Empty).Trim();
            string username = (txtUsername.Text ?? string.Empty).Trim();
            string email = (txtEmail.Text ?? string.Empty).Trim();

            string role = null;
            if (rbAdmin.Checked)
            {
                role = "Admin";
            }
            else if (rbEducator.Checked)
            {
                role = "Educator";
            }

            // 1. Basic validation
            bool hasError = false;

            if (string.IsNullOrEmpty(fullName))
            {
                litErrorFullName.Text = "Full name cannot be empty.";
                hasError = true;
            }

            if (string.IsNullOrEmpty(username))
            {
                litErrorUsername.Text = "Username cannot be empty.";
                hasError = true;
            }

            if (string.IsNullOrEmpty(email))
            {
                litErrorEmail.Text = "Email cannot be empty.";
                hasError = true;
            }
            else if (!IsValidEmail(email))
            {
                litErrorEmail.Text = "Email is not in a valid format.";
                hasError = true;
            }

            if (string.IsNullOrEmpty(role))
            {
                litErrorRole.Text = "Please select a role (Admin or Educator).";
                hasError = true;
            }

            if (hasError)
            {
                return;
            }

            try
            {
                using (var con = new SqlConnection(ConnStr))
                {
                    con.Open();

                    // 2. Unique username check
                    using (var cmd = new SqlCommand(@"
                        SELECT TOP 1 UserId
                        FROM dbo.Users
                        WHERE Username = @u", con))
                    {
                        cmd.Parameters.AddWithValue("@u", username);

                        using (var rd = cmd.ExecuteReader())
                        {
                            if (rd.Read())
                            {
                                litErrorUsername.Text = "Username has already been taken.";
                                return;
                            }
                        }
                    }

                    // 3. Unique email check
                    using (var cmd = new SqlCommand(@"
                        SELECT TOP 1 UserId
                        FROM dbo.Users
                        WHERE Email = @e", con))
                    {
                        cmd.Parameters.AddWithValue("@e", email);

                        using (var rd = cmd.ExecuteReader())
                        {
                            if (rd.Read())
                            {
                                litErrorEmail.Text = "Email is already registered.";
                                return;
                            }
                        }
                    }

                    // 4. Generate temporary password
                    string tempPassword = GenerateTempPassword(10);
                    string passwordHash = WAPP_Assignment.SiteMaster.Hash(tempPassword);

                    // 5. Insert new user with IsPasswordReset = 1
                    using (var cmd = new SqlCommand(@"
                        INSERT INTO dbo.Users
                            (Username, Email, UserType, FullName, PasswordHash, IsPasswordReset)
                        VALUES
                            (@u, @e, @t, @f, @p, 1);", con))
                    {
                        cmd.Parameters.Add("@u", SqlDbType.NVarChar, 50).Value = username;
                        cmd.Parameters.Add("@e", SqlDbType.NVarChar, 256).Value = email;
                        cmd.Parameters.Add("@t", SqlDbType.NVarChar, 20).Value = role;
                        cmd.Parameters.Add("@f", SqlDbType.NVarChar, 256).Value =
                            string.IsNullOrWhiteSpace(fullName) ? (object)DBNull.Value : fullName;
                        cmd.Parameters.Add("@p", SqlDbType.NVarChar, 256).Value = passwordHash;

                        int rows = cmd.ExecuteNonQuery();
                        if (rows <= 0)
                        {
                            litErrorGeneral.Text = "User could not be created. Please try again.";
                            return;
                        }
                    }

                    // 6. Show result and temp password
                    txtTempPassword.Text = tempPassword;
                    pnlResult.Visible = true;

                    // Keep form fields so the admin can still see username/email,
                    // and the copy-to-clipboard JS can include username in the payload.
                    // If you ever want to clear fields after copy, that can be done
                    // with an extra button/flow later.
                }
            }
            catch (Exception ex)
            {
                litErrorGeneral.Text = ex.Message;
            }
        }

        private void ClearErrors()
        {
            litErrorFullName.Text = string.Empty;
            litErrorUsername.Text = string.Empty;
            litErrorEmail.Text = string.Empty;
            litErrorRole.Text = string.Empty;
            litErrorGeneral.Text = string.Empty;
        }

        private static bool IsValidEmail(string email)
        {
            string pattern = @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
            return Regex.IsMatch(email, pattern);
        }

        private static string GenerateTempPassword(int length)
        {
            // Simple strong-ish random password: letters + digits
            const string chars = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789";
            var rnd = new Random();
            return new string(Enumerable.Repeat(chars, length)
                .Select(s => s[rnd.Next(s.Length)]).ToArray());
        }
    }
}
