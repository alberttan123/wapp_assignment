using System;
using System.Web.UI;

namespace WAPP_Assignment.Lecturer
{
    public partial class LecturerMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Only allow Educator role in lecturer area
            var (success, userId, userType) = AuthCookieHelper.ReadAuthCookie();

            if (!success ||
                string.IsNullOrEmpty(userId) ||
                !string.Equals(userType, "Educator", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }
        }
    }
}
