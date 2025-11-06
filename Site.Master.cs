using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static WAPP_Assignment.DataAccess;


namespace WAPP_Assignment
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void showLoginSignupModal(object sender, EventArgs e) 
        { 
            loginSignupModal.Visible = true;
        }

        protected void hideLoginSignupModal(object sender, EventArgs e)
        {
            loginSignupModal.Visible = false;
        }

        protected void login(object sender, EventArgs e) 
        {
            
        }
    }
}