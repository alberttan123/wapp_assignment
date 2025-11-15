using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPP_Assignment.Admin
{
    public partial class AdminUserManage : Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        /// <summary>
        /// Stores expanded user IDs between postbacks.
        /// </summary>
        private HashSet<int> ExpandedUsers
        {
            get
            {
                if (ViewState["ExpandedUsers"] is HashSet<int> set)
                {
                    return set;
                }

                var newSet = new HashSet<int>();
                ViewState["ExpandedUsers"] = newSet;
                return newSet;
            }
        }

        /// <summary>
        /// Stores latest regenerated passwords per user, for inline display.
        /// </summary>
        private Dictionary<int, string> GeneratedPasswords
        {
            get
            {
                if (ViewState["GeneratedPasswords"] is Dictionary<int, string> dict)
                {
                    return dict;
                }

                var newDict = new Dictionary<int, string>();
                ViewState["GeneratedPasswords"] = newDict;
                return newDict;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                litGlobalMessage.Text = string.Empty;
                ddlSortMode.SelectedValue = "newest";
                BindUsers();
            }
        }

        protected void ddlSortMode_SelectedIndexChanged(object sender, EventArgs e)
        {
            ExpandedUsers.Clear();
            litGlobalMessage.Text = string.Empty;
            GeneratedPasswords.Clear();
            BindUsers();
        }

        protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            litGlobalMessage.Text = string.Empty;

            if (!int.TryParse(e.CommandArgument.ToString(), out int userId))
            {
                return;
            }

            switch (e.CommandName)
            {
                case "toggle":
                    if (ExpandedUsers.Contains(userId))
                    {
                        ExpandedUsers.Remove(userId);
                    }
                    else
                    {
                        ExpandedUsers.Add(userId);
                    }
                    BindUsers();
                    break;

                case "delete":
                    HandleDeleteUser(userId);
                    break;

                case "regen_pw":
                    HandleRegeneratePassword(userId);
                    break;
            }
        }

        protected void rptUsers_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem)
            {
                return;
            }

            var drv = e.Item.DataItem as DataRowView;
            if (drv == null)
            {
                return;
            }

            int userId = Convert.ToInt32(drv["UserId"]);
            bool isResetRequired = Convert.ToBoolean(drv["IsPasswordReset"]);
            string username = drv["Username"] as string;

            var pnlDetails = (Panel)e.Item.FindControl("pnlDetails");
            var litChevron = (Literal)e.Item.FindControl("litChevron");
            var litPasswordReset = (Literal)e.Item.FindControl("litPasswordReset");
            var litPasswordResetHeader = (Literal)e.Item.FindControl("litPasswordResetHeader");
            var btnGeneratePassword = (LinkButton)e.Item.FindControl("btnGeneratePassword");
            var btnDeleteUser = (LinkButton)e.Item.FindControl("btnDeleteUser");
            var pnlGeneratedPassword = (Panel)e.Item.FindControl("pnlGeneratedPassword");
            var txtGeneratedPassword = (TextBox)e.Item.FindControl("txtGeneratedPassword");
            var btnCopyGeneratedPassword = (LinkButton)e.Item.FindControl("btnCopyGeneratedPassword");
            var hfUsername = (HiddenField)e.Item.FindControl("hfUsername");

            bool isExpanded = ExpandedUsers.Contains(userId);
            pnlDetails.Visible = isExpanded;
            litChevron.Text = isExpanded ? "▲" : "▼";

            // Password reset status — details block
            if (isResetRequired)
            {
                litPasswordReset.Text = "<span class=\"aum-reset-warn\">Required</span>";
            }
            else
            {
                litPasswordReset.Text = "<span class=\"aum-reset-ok\">Not required</span>";
            }

            // Password reset status — header badge
            if (isResetRequired)
            {
                litPasswordResetHeader.Text = "<span class=\"aum-reset-warn\">Reset required</span>";
            }
            else
            {
                litPasswordResetHeader.Text = "<span class=\"aum-reset-ok\">No reset</span>";
            }

            // Generate password button only when reset requested
            if (btnGeneratePassword != null)
            {
                btnGeneratePassword.Visible = isResetRequired;
            }

            // Delete button visibility: hide for admin1 and for current logged-in user
            int currentUserId = GetCurrentUserId();
            bool isCurrentUser = currentUserId > 0 && currentUserId == userId;
            bool isProtectedAdmin =
                !string.IsNullOrEmpty(username) &&
                username.Equals("admin1", StringComparison.OrdinalIgnoreCase);

            if (btnDeleteUser != null)
            {
                btnDeleteUser.Visible = !(isProtectedAdmin || isCurrentUser);
            }

            // Inline generated password (if any)
            if (pnlGeneratedPassword != null && txtGeneratedPassword != null && btnCopyGeneratedPassword != null)
            {
                if (GeneratedPasswords.TryGetValue(userId, out string pwd) && !string.IsNullOrEmpty(pwd))
                {
                    pnlGeneratedPassword.Visible = true;
                    txtGeneratedPassword.Text = pwd;

                    string userForCopy = username ?? string.Empty;
                    btnCopyGeneratedPassword.Attributes["data-username"] = userForCopy;
                    btnCopyGeneratedPassword.Attributes["data-passwordfieldid"] = txtGeneratedPassword.ClientID;
                }
                else
                {
                    pnlGeneratedPassword.Visible = false;
                    txtGeneratedPassword.Text = string.Empty;
                }
            }

            // Keep hidden field username in sync (optional, but neat)
            if (hfUsername != null)
            {
                hfUsername.Value = username ?? string.Empty;
            }
        }

        private void BindUsers()
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand())
            using (var da = new SqlDataAdapter(cmd))
            {
                cmd.Connection = con;

                string mode = ddlSortMode.SelectedValue ?? "newest";

                string whereClause = string.Empty;
                string orderBy;
                string sortLabel;

                if (string.Equals(mode, "oldest", StringComparison.OrdinalIgnoreCase))
                {
                    orderBy = "ORDER BY CreatedAt ASC, UserId ASC";
                    sortLabel = "Oldest first";
                }
                else if (mode.StartsWith("role_", StringComparison.OrdinalIgnoreCase))
                {
                    string role = mode.Substring("role_".Length); // Admin / Educator / Student
                    whereClause = "WHERE UserType = @Role";
                    orderBy = "ORDER BY CreatedAt DESC, UserId DESC";
                    cmd.Parameters.Add("@Role", SqlDbType.NVarChar, 20).Value = role;

                    if (role.Equals("Admin", StringComparison.OrdinalIgnoreCase))
                    {
                        sortLabel = "Admins only (newest first)";
                    }
                    else if (role.Equals("Educator", StringComparison.OrdinalIgnoreCase))
                    {
                        sortLabel = "Educators only (newest first)";
                    }
                    else
                    {
                        sortLabel = "Students only (newest first)";
                    }
                }
                else if (string.Equals(mode, "reset_required", StringComparison.OrdinalIgnoreCase))
                {
                    whereClause = "WHERE IsPasswordReset = 1";
                    orderBy = "ORDER BY CreatedAt DESC, UserId DESC";
                    sortLabel = "Password reset required";
                }
                else
                {
                    // Default: newest first
                    orderBy = "ORDER BY CreatedAt DESC, UserId DESC";
                    sortLabel = "Newest first";
                }

                cmd.CommandText = @"
                    SELECT
                        UserId,
                        Username,
                        Email,
                        UserType,
                        FullName,
                        IsPasswordReset,
                        CreatedAt
                    FROM dbo.Users
                    " + whereClause + @"
                    " + orderBy + ";";

                litSortMode.Text = sortLabel;

                var table = new DataTable();
                da.Fill(table);

                if (!table.Columns.Contains("AvatarInitials"))
                    table.Columns.Add("AvatarInitials", typeof(string));
                if (!table.Columns.Contains("DisplayName"))
                    table.Columns.Add("DisplayName", typeof(string));
                if (!table.Columns.Contains("FullNameDisplay"))
                    table.Columns.Add("FullNameDisplay", typeof(string));

                foreach (DataRow row in table.Rows)
                {
                    string fullName = row["FullName"] as string;
                    string username = row["Username"] as string;
                    string email = row["Email"] as string;

                    string fullNameDisplay = string.IsNullOrWhiteSpace(fullName)
                        ? "(No full name)"
                        : fullName;

                    row["FullNameDisplay"] = fullNameDisplay;

                    string displayName = !string.IsNullOrWhiteSpace(fullName)
                        ? fullName
                        : username;

                    row["DisplayName"] = displayName;

                    row["AvatarInitials"] = BuildInitials(displayName, email);
                }

                rptUsers.DataSource = table;
                rptUsers.DataBind();
            }
        }

        private int GetCurrentUserId()
        {
            var (isAuth, userIdStr, _) = AuthCookieHelper.ReadAuthCookie();
            if (!isAuth || string.IsNullOrEmpty(userIdStr))
            {
                return -1;
            }

            if (int.TryParse(userIdStr, out int id))
            {
                return id;
            }

            return -1;
        }

        private void HandleDeleteUser(int userId)
        {
            int currentUserId = GetCurrentUserId();
            if (currentUserId > 0 && currentUserId == userId)
            {
                litGlobalMessage.Text = "You cannot delete the currently logged-in account.";
                BindUsers();
                return;
            }

            using (var con = new SqlConnection(ConnStr))
            {
                con.Open();

                string username;

                // Check existence + protected admin1
                using (var cmd = new SqlCommand(@"
                        SELECT Username
                        FROM dbo.Users
                        WHERE UserId = @id;", con))
                {
                    cmd.Parameters.Add("@id", SqlDbType.Int).Value = userId;

                    using (var rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read())
                        {
                            litGlobalMessage.Text = "User not found.";
                            BindUsers();
                            return;
                        }

                        username = rd.GetString(rd.GetOrdinal("Username"));
                    }
                }

                if (!string.IsNullOrEmpty(username) &&
                    username.Equals("admin1", StringComparison.OrdinalIgnoreCase))
                {
                    litGlobalMessage.Text = "The primary admin account (admin1) cannot be deleted.";
                    BindUsers();
                    return;
                }

                // Block deletion if user has related records (courses, enrollments, scores, forum, quizzes)
                using (var cmd = new SqlCommand(@"
                    IF EXISTS (SELECT 1 FROM dbo.Courses WHERE LecturerId = @id)
                        OR EXISTS (SELECT 1 FROM dbo.Enrollments WHERE UserId = @id)
                        OR EXISTS (SELECT 1 FROM dbo.Score WHERE UserId = @id)
                        OR EXISTS (SELECT 1 FROM dbo.ForumPost WHERE UserId = @id)
                        OR EXISTS (SELECT 1 FROM dbo.ForumComment WHERE UserId = @id)
                        OR EXISTS (SELECT 1 FROM dbo.Quiz WHERE CreatedBy = @id)
                    SELECT 1
                    ELSE
                    SELECT 0;", con))
                {
                    cmd.Parameters.Add("@id", SqlDbType.Int).Value = userId;
                    var hasRefsObj = cmd.ExecuteScalar();
                    bool hasRefs = hasRefsObj != null && Convert.ToInt32(hasRefsObj) == 1;
                    if (hasRefs)
                    {
                        litGlobalMessage.Text = "Cannot delete this user because they are referenced in other records (courses, enrollments, scores, or forum).";
                        BindUsers();
                        return;
                    }
                }

                // Delete user (safe: no FK references)
                using (var cmd = new SqlCommand(@"
                        DELETE FROM dbo.Users
                        WHERE UserId = @id;", con))
                {
                    cmd.Parameters.Add("@id", SqlDbType.Int).Value = userId;
                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        litGlobalMessage.Text = "User '" + Server.HtmlEncode(username) + "' has been deleted.";
                    }
                    else
                    {
                        litGlobalMessage.Text = "User could not be deleted.";
                    }
                }
            }

            ExpandedUsers.Remove(userId);
            GeneratedPasswords.Remove(userId);
            BindUsers();
        }

        private void HandleRegeneratePassword(int userId)
        {
            using (var con = new SqlConnection(ConnStr))
            {
                con.Open();

                string username;

                using (var cmd = new SqlCommand(@"
                        SELECT Username
                        FROM dbo.Users
                        WHERE UserId = @id;", con))
                {
                    cmd.Parameters.Add("@id", SqlDbType.Int).Value = userId;

                    using (var rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read())
                        {
                            litGlobalMessage.Text = "User not found.";
                            BindUsers();
                            return;
                        }

                        username = rd.GetString(rd.GetOrdinal("Username"));
                    }
                }

                string tempPassword = GenerateTempPassword(10);
                string hash = SiteMaster.Hash(tempPassword);

                using (var cmd = new SqlCommand(@"
                        UPDATE dbo.Users
                        SET PasswordHash = @p, IsPasswordReset = 1
                        WHERE UserId = @id;", con))
                {
                    cmd.Parameters.Add("@p", SqlDbType.NVarChar, 256).Value = hash;
                    cmd.Parameters.Add("@id", SqlDbType.Int).Value = userId;

                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        // Store for inline display
                        GeneratedPasswords[userId] = tempPassword;

                        litGlobalMessage.Text =
                            "New password generated for '" + Server.HtmlEncode(username) + "'.";
                    }
                    else
                    {
                        litGlobalMessage.Text = "Password could not be updated.";
                    }
                }
            }

            BindUsers();
        }

        private static string BuildInitials(string nameOrUsername, string email)
        {
            if (!string.IsNullOrWhiteSpace(nameOrUsername))
            {
                var parts = nameOrUsername.Trim()
                    .Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

                if (parts.Length == 1)
                {
                    return parts[0].Substring(0, Math.Min(2, parts[0].Length)).ToUpperInvariant();
                }

                string first = parts[0];
                string last = parts[parts.Length - 1];
                return (first[0].ToString() + last[0].ToString()).ToUpperInvariant();
            }

            if (!string.IsNullOrWhiteSpace(email))
            {
                int atIndex = email.IndexOf("@", StringComparison.Ordinal);
                if (atIndex > 0)
                {
                    string handle = email.Substring(0, atIndex);
                    if (handle.Length >= 2)
                    {
                        return handle.Substring(0, 2).ToUpperInvariant();
                    }
                    return handle.ToUpperInvariant();
                }
            }

            return "US";
        }

        private static string GenerateTempPassword(int length)
        {
            const string chars = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789";
            var rnd = new Random();
            char[] buffer = new char[length];
            for (int i = 0; i < length; i++)
            {
                buffer[i] = chars[rnd.Next(chars.Length)];
            }
            return new string(buffer);
        }
    }
}
