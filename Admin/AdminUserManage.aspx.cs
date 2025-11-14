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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Default: newest first across all roles
                ddlSortMode.SelectedValue = "newest";
                BindUsers();
            }
        }

        protected void ddlSortMode_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Whenever view changes, reset expanded state so cards don't jump around strangely
            ExpandedUsers.Clear();
            BindUsers();
        }

        protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "toggle" && int.TryParse(e.CommandArgument.ToString(), out int userId))
            {
                if (ExpandedUsers.Contains(userId))
                {
                    ExpandedUsers.Remove(userId);
                }
                else
                {
                    ExpandedUsers.Add(userId);
                }

                BindUsers();
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

            var pnlDetails = (Panel)e.Item.FindControl("pnlDetails");
            var litChevron = (Literal)e.Item.FindControl("litChevron");
            var litPasswordReset = (Literal)e.Item.FindControl("litPasswordReset");
            var litPasswordResetHeader = (Literal)e.Item.FindControl("litPasswordResetHeader");

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
                        IsPasswordReset
                    FROM dbo.Users
                    " + whereClause + @"
                    " + orderBy + ";";

                litSortMode.Text = sortLabel;

                var table = new DataTable();
                da.Fill(table);

                // Enrich with display columns without changing schema
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

                    // Full name display fallback
                    string fullNameDisplay = string.IsNullOrWhiteSpace(fullName)
                        ? "(No full name)"
                        : fullName;

                    row["FullNameDisplay"] = fullNameDisplay;

                    // Display name: prefer full name, fallback to username
                    string displayName = !string.IsNullOrWhiteSpace(fullName)
                        ? fullName
                        : username;

                    row["DisplayName"] = displayName;

                    // Avatar initials: derived, no schema change
                    row["AvatarInitials"] = BuildInitials(displayName, email);
                }

                rptUsers.DataSource = table;
                rptUsers.DataBind();
            }
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
    }
}
