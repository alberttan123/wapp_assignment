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
            if (Page.Form != null) Page.Form.Enctype = "multipart/form-data";
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;
            if (!ValidateForm(out string err))
            {
                lblMsg.Text = err; lblMsg.Visible = true; return;
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
                cmd.Parameters.AddWithValue("@o3", string.IsNullOrWhiteSpace(txtO3.Text) ? (object)DBNull.Value : txtO3.Text.Trim());
                cmd.Parameters.AddWithValue("@o4", string.IsNullOrWhiteSpace(txtO4.Text) ? (object)DBNull.Value : txtO4.Text.Trim());
                cmd.Parameters.AddWithValue("@ans", int.Parse(ddlAns.SelectedValue));
                con.Open();
                newId = (int)cmd.ExecuteScalar();
            }

            if (fuImg.HasFile)
            {
                var rel = SaveImage(fuImg, newId);
                using (var con = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand("UPDATE dbo.Questions SET ImageUrl=@u WHERE QuestionId=@id;", con))
                {
                    cmd.Parameters.AddWithValue("@u", rel);
                    cmd.Parameters.AddWithValue("@id", newId);
                    con.Open(); cmd.ExecuteNonQuery();
                }
            }

            Response.Redirect("~/Lecturer/LecturerQuestionViewer.aspx?id=" + newId);
        }

        private bool ValidateForm(out string msg)
        {
            msg = "";
            if (string.IsNullOrWhiteSpace(txtQ.Text)) { msg = "Question is required."; return false; }
            if (string.IsNullOrWhiteSpace(txtO1.Text)) { msg = "Option 1 is required."; return false; }
            if (string.IsNullOrWhiteSpace(txtO2.Text)) { msg = "Option 2 is required."; return false; }
            var ans = int.Parse(ddlAns.SelectedValue);
            if ((ans == 3 && string.IsNullOrWhiteSpace(txtO3.Text)) ||
                (ans == 4 && string.IsNullOrWhiteSpace(txtO4.Text)))
            { msg = "Provide the option selected as the correct answer."; return false; }
            return true;
        }

        private string SaveImage(System.Web.UI.WebControls.FileUpload fu, int id)
        {
            var folder = Server.MapPath("~/Uploads/Questions");
            if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
            var ext = Path.GetExtension(fu.FileName); if (string.IsNullOrEmpty(ext)) ext = ".png";
            var name = $"q-{id}-{DateTime.UtcNow.Ticks}{ext}";
            fu.SaveAs(Path.Combine(folder, name));
            return "~/Uploads/Questions/" + name;
        }
    }
}
