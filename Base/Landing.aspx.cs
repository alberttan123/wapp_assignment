using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPP_Assignment
{
    public partial class Landing : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void showLoginSignupModal(object sender, EventArgs e) 
        {
            MasterPageInterface masterPageInterface = this.Master as MasterPageInterface;
            if (masterPageInterface != null)
            {
                masterPageInterface.showLoginSignupModal(this, null);
            }
        }

        protected void redirToCourses(object sender, EventArgs e) 
        {
            Response.Redirect("~/Base/CourseDashboard.aspx", true);
        }
    }
}