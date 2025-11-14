using System;
using System.Web;
using System.Web.UI;

namespace WAPP_Assignment.Lecturer
{
    public partial class LecturerMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Run on every request; if not an educator, kick back to landing
            EnsureEducatorAuthenticated();
        }

        private void EnsureEducatorAuthenticated()
        {
            // Re-use the same auth cookie helper as the student dashboard
            var info = AuthCookieHelper.ReadAuthCookie();
            bool isAuthenticated = info.success;
            string userId = info.UserId;
            string userType = info.userType;

            if (!isAuthenticated ||
                string.IsNullOrEmpty(userId) ||
                !string.Equals(userType, "Educator", StringComparison.OrdinalIgnoreCase))
            {
                // Not logged in or not an educator → go back to landing/login
                Response.Redirect("~/Base/Landing.aspx", true);
            }
        }
    }
}
