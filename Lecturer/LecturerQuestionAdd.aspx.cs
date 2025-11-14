using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;

namespace WAPP_Assignment.Lecturer
{
    public partial class LecturerQuestionAdd : System.Web.UI.Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.Form != null)
                Page.Form.Enctype = "multipart/form-data";

            if (!IsPostBack)
            {
                // default correct answer is option 1
                hfCorrectAnswer.Value = "1";
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            if (!ValidateForm(out string err, out int correctAns))
            {
                lblMsg.Text = err;
                lblMsg.Visible = true;
                return;
            }

            int newId;
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
INSERT INTO dbo.Questions(Question, Option1, Option2, Option3, Option4, CorrectAnswer)
VALUES(@q, @o1, @o2, @o3, @o4, @ans);
SELECT CAST(SCOPE_IDENTITY() AS INT);", con))
            {
                cmd.Parameters.AddWithValue("@q", txtQ.Text.Trim());
                cmd.Parameters.AddWithValue("@o1", txtO1.Text.Trim());
                cmd.Parameters.AddWithValue("@o2", txtO2.Text.Trim());
                cmd.Parameters.AddWithValue("@o3",
                    string.IsNullOrWhiteSpace(txtO3.Text) ? (object)DBNull.Value : txtO3.Text.Trim());
                cmd.Parameters.AddWithValue("@o4",
                    string.IsNullOrWhiteSpace(txtO4.Text) ? (object)DBNull.Value : txtO4.Text.Trim());
                cmd.Parameters.AddWithValue("@ans", correctAns);

                con.Open();
                newId = (int)cmd.ExecuteScalar();
            }

            if (fuImg.HasFile)
            {
                var rel = SaveImage(fuImg, newId);
                using (var con = new SqlConnection(ConnStr))
                using (var cmd =
                       new SqlCommand("UPDATE dbo.Questions SET ImageUrl=@u WHERE QuestionId=@id;", con))
                {
                    cmd.Parameters.AddWithValue("@u", rel);
                    cmd.Parameters.AddWithValue("@id", newId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // Go straight to viewer on the new question
            Response.Redirect("~/Lecturer/LecturerQuestionViewer.aspx?id=" + newId);
        }

        private bool ValidateForm(out string msg, out int correctAns)
        {
            msg = "";
            correctAns = 1;

            if (string.IsNullOrWhiteSpace(txtQ.Text))
            {
                msg = "Question text is required.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtO1.Text) || string.IsNullOrWhiteSpace(txtO2.Text))
            {
                msg = "Option 1 and Option 2 are required.";
                return false;
            }

            if (!int.TryParse(hfCorrectAnswer.Value, out correctAns) || correctAns < 1 || correctAns > 4)
            {
                msg = "Please choose a correct option.";
                return false;
            }

            if (correctAns == 3 && string.IsNullOrWhiteSpace(txtO3.Text))
            {
                msg = "Option 3 must have text if it is the correct answer.";
                return false;
            }

            if (correctAns == 4 && string.IsNullOrWhiteSpace(txtO4.Text))
            {
                msg = "Option 4 must have text if it is the correct answer.";
                return false;
            }

            return true;
        }

        private string SaveImage(System.Web.UI.WebControls.FileUpload fu, int id)
        {
            string folder = Server.MapPath("~/Uploads/Questions");
            if (!Directory.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }

            string ext = Path.GetExtension(fu.FileName);
            if (string.IsNullOrEmpty(ext)) ext = ".png";

            string name = $"q-{id}-{DateTime.UtcNow.Ticks}{ext}";
            string physical = Path.Combine(folder, name);
            fu.SaveAs(physical);

            return "~/Uploads/Questions/" + name;
        }
    }
}
