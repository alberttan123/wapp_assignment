using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPP_Assignment.Admin
{
    public partial class Admin : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                HighlightNav();
            }
        }

        private void HighlightNav()
        {
            string path = (Request.AppRelativeCurrentExecutionFilePath ?? string.Empty)
                .ToLowerInvariant();

            ClearActive();

            if (path.Contains("/admindashboard.aspx"))
            {
                AddActive(lnkDashboard);
            }
            else if (path.Contains("/adminusermanage.aspx") ||
                     path.Contains("/admincreateuser.aspx"))
            {
                AddActive(lnkUsers);
            }
            else if (path.Contains("/admincourses.aspx"))
            {
                AddActive(lnkCourses);
            }
        }

        private void ClearActive()
        {
            RemoveActive(lnkDashboard);
            RemoveActive(lnkUsers);
            RemoveActive(lnkCourses);
        }

        private static void AddActive(HyperLink link)
        {
            if (link == null) return;
            var cls = link.CssClass ?? string.Empty;
            if (!cls.Contains("active"))
            {
                link.CssClass = (cls + " active").Trim();
            }
        }

        private static void RemoveActive(HyperLink link)
        {
            if (link == null) return;
            var cls = link.CssClass ?? string.Empty;
            link.CssClass = cls.Replace("active", "").Trim();
        }
    }
}
