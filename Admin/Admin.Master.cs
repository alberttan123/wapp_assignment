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
                // Set URLs using ResolveUrl for proper path resolution
                if (lnkDashboard != null)
                {
                    lnkDashboard.NavigateUrl = ResolveUrl("~/Admin/AdminDashboard.aspx");
                }
                if (lnkUsers != null)
                {
                    lnkUsers.NavigateUrl = ResolveUrl("~/Admin/AdminUserManage.aspx");
                }
                if (lnkCourses != null)
                {
                    lnkCourses.NavigateUrl = ResolveUrl("~/Admin/AdminCourses.aspx");
                }
                if (lnkCommunity != null)
                {
                    lnkCommunity.NavigateUrl = ResolveUrl("~/Forum/AllPosts.aspx");
                }
                
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
            else if (path.Contains("/forum/allposts.aspx") ||
                     path.Contains("/forum/viewpost.aspx"))
            {
                AddActive(lnkCommunity);
            }
        }

        private void ClearActive()
        {
            RemoveActive(lnkDashboard);
            RemoveActive(lnkUsers);
            RemoveActive(lnkCourses);
            if (lnkCommunity != null)
            {
                RemoveActive(lnkCommunity);
            }
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
