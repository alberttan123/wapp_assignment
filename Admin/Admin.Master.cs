using System;
using System.Web;
using System.Web.UI;

namespace WAPP_Assignment.Admin
{
    public partial class AdminMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Run on every request; if not an admin, kick back to landing
            EnsureAdminAuthenticated();
        }

        private void EnsureAdminAuthenticated()
        {
            // Read the auth cookie using the shared helper
            // Tuple is declared in AuthCookieHelper as:
            // (bool success, string UserId, string userType) ReadAuthCookie()
            var info = AuthCookieHelper.ReadAuthCookie();

            bool isAuthenticated = info.success;
            string userId = info.UserId;
            string userType = info.userType;

            if (!isAuthenticated ||
                string.IsNullOrEmpty(userId) ||
                !string.Equals(userType, "Admin", StringComparison.OrdinalIgnoreCase))
            {
                // Not logged in or not an admin → go back to landing/login
                Response.Redirect("~/Base/Landing.aspx", true);
            }
        }
    }
}
