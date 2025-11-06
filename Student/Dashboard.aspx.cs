using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static WAPP_Assignment.DataAccess;

namespace WAPP_Assignment.Student
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected string StudentName { get; private set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["UserId"] = 1; //Testing

            if (!IsPostBack)
            {
                StudentName = LoadStudentName();
            }
        }


        private string LoadStudentName()
        {
            try
            {
                // Check if user is logged in (UserId stored in Session)
                if (Session["UserId"] != null)
                {
                    int userId = Convert.ToInt32(Session["UserId"]);
                    return GetStudentNameFromDatabase(userId);
                }
                else
                {
                    // Default value if not logged in
                    return StudentName = "Guest";
                }
            }
            catch (Exception ex)
            {
                // Log error and set default
                System.Diagnostics.Debug.WriteLine($"Error loading student data: {ex.Message}");
                return StudentName = "Student";
            }
        }


        private string GetStudentNameFromDatabase(int userId)
        {
            try
            {
                using (SqlConnection conn = DataAccess.GetOpenConnection())
                {
                    // Query to get username - adjust column names based on your actual database
                    // Common column names: Username, FirstName, LastName, Name, UserName
                    string query = "SELECT Username FROM Users WHERE UserId = @UserId";
                        

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);

                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                        {
                            return StudentName = result.ToString();
                        }
                        else
                        {
                            return StudentName = "Student";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Database error: {ex.Message}");
                return StudentName = "Student";
            }
        }
    }
}