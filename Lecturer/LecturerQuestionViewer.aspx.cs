using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace WAPP_Assignment.Lecturer
{
    public partial class LecturerQuestionViewer : System.Web.UI.Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        // cached list of all question ids ordered by QuestionId asc
        private DataTable Ids
        {
            get { return ViewState["Ids"] as DataTable; }
            set { ViewState["Ids"] = value; }
        }

        private int CurrentIndex
        {
            get { return (ViewState["Idx"] is int i) ? i : 0; }
            set { ViewState["Idx"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.Form != null) Page.Form.Enctype = "multipart/form-data";

            if (!IsPostBack)
            {
                LoadIds();

                // if ?id= is provided, jump to that record
                if (int.TryParse(Request.QueryString["id"], out int qid))
                    JumpToId(qid);

                BindCurrent();
            }
        }

        private void LoadIds()
        {
            using (var con = new SqlConnection(ConnStr))
            using (var da = new SqlDataAdapter("SELECT QuestionId FROM dbo.Questions ORDER BY QuestionId ASC;", con))
            {
                var dt = new DataTable();
                da.Fill(dt);
                Ids = dt;
                if (dt.Rows.Count == 0) { DisableAll("No questions yet."); }
            }
        }

        private void DisableAll(string msg)
        {
            litCounter.Text = msg;
            btnPrev.Enabled = btnNext.Enabled = btnUpdate.Enabled = btnDelete.Enabled = false;
        }

        private void JumpToId(int qid)
        {
            if (Ids == null || Ids.Rows.Count == 0) return;
            for (int i = 0; i < Ids.Rows.Count; i++)
            {
                if ((int)Ids.Rows[i]["QuestionId"] == qid) { CurrentIndex = i; return; }
            }
            // if not found, keep at 0
        }

        private int CurrentQuestionId()
        {
            if (Ids == null || Ids.Rows.Count == 0) return -1;
            return (int)Ids.Rows[CurrentIndex]["QuestionId"];
        }

        private void BindCurrent()
        {
            if (Ids == null || Ids.Rows.Count == 0) return;

            int id = CurrentQuestionId();
            litCounter.Text = $"{CurrentIndex + 1} / {Ids.Rows.Count}";
            btnPrev.Enabled = CurrentIndex > 0;
            btnNext.Enabled = CurrentIndex < Ids.Rows.Count - 1;

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT QuestionId, Question, Option1, Option2, Option3, Option4, CorrectAnswer, ImageUrl
FROM dbo.Questions WHERE QuestionId=@id;", con))
            {
                cmd.Parameters.AddWithValue("@id", id);
                con.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (!r.Read()) return;

                    hidQuestionId.Value = r["QuestionId"].ToString();

                    // viewer
                    litQ.Text = r["Question"].ToString();
                    litO1.Text = r["Option1"].ToString();
                    litO2.Text = r["Option2"].ToString();
                    litO3.Text = r["Option3"] == DBNull.Value ? "" : r["Option3"].ToString();
                    litO4.Text = r["Option4"] == DBNull.Value ? "" : r["Option4"].ToString();
                    litAns.Text = r["CorrectAnswer"].ToString();

                    var img = r["ImageUrl"] == DBNull.Value ? "" : r["ImageUrl"].ToString();
                    imgQ.Visible = !string.IsNullOrEmpty(img);
                    if (imgQ.Visible) imgQ.ImageUrl = ResolveUrl(img);

                    // edit fields
                    txtQ.Text = r["Question"].ToString();
                    txtO1.Text = r["Option1"].ToString();
                    txtO2.Text = r["Option2"].ToString();
                    txtO3.Text = r["Option3"] == DBNull.Value ? "" : r["Option3"].ToString();
                    txtO4.Text = r["Option4"] == DBNull.Value ? "" : r["Option4"].ToString();
                    ddlAns.SelectedValue = r["CorrectAnswer"].ToString();
                    chkRemove.Checked = false;
                }
            }
        }

        protected void BtnPrev_Click(object sender, EventArgs e)
        {
            if (CurrentIndex > 0) { CurrentIndex--; BindCurrent(); }
        }

        protected void BtnNext_Click(object sender, EventArgs e)
        {
            if (Ids != null && CurrentIndex < Ids.Rows.Count - 1) { CurrentIndex++; BindCurrent(); }
        }

        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;
            if (!int.TryParse(hidQuestionId.Value, out int id) || id <= 0) return;

            // simple validation
            if (string.IsNullOrWhiteSpace(txtQ.Text) || string.IsNullOrWhiteSpace(txtO1.Text) || string.IsNullOrWhiteSpace(txtO2.Text))
            { Show("Question, Option 1 and Option 2 are required."); return; }

            int ans = int.Parse(ddlAns.SelectedValue);
            if ((ans == 3 && string.IsNullOrWhiteSpace(txtO3.Text)) ||
                (ans == 4 && string.IsNullOrWhiteSpace(txtO4.Text)))
            { Show("Provide the option selected as the correct answer."); return; }

            string imageSql = "";
            object imageParam = DBNull.Value;

            if (chkRemove.Checked)
            {
                imageSql = ", ImageUrl = NULL";
            }
            else if (fuImg.HasFile)
            {
                var rel = SaveImage(fuImg, id);
                imageSql = ", ImageUrl = @img";
                imageParam = rel;
            }

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand($@"
UPDATE dbo.Questions
SET Question=@q, Option1=@o1, Option2=@o2, Option3=@o3, Option4=@o4, CorrectAnswer=@ans {imageSql}
WHERE QuestionId=@id;", con))
            {
                cmd.Parameters.AddWithValue("@q", txtQ.Text.Trim());
                cmd.Parameters.AddWithValue("@o1", txtO1.Text.Trim());
                cmd.Parameters.AddWithValue("@o2", txtO2.Text.Trim());
                cmd.Parameters.AddWithValue("@o3", string.IsNullOrWhiteSpace(txtO3.Text) ? (object)DBNull.Value : txtO3.Text.Trim());
                cmd.Parameters.AddWithValue("@o4", string.IsNullOrWhiteSpace(txtO4.Text) ? (object)DBNull.Value : txtO4.Text.Trim());
                cmd.Parameters.AddWithValue("@ans", ans);
                cmd.Parameters.AddWithValue("@id", id);
                if (imageSql.Contains("@img")) cmd.Parameters.AddWithValue("@img", imageParam);

                con.Open(); cmd.ExecuteNonQuery();
            }

            Show("Saved.");
            BindCurrent();
        }

        protected void BtnDelete_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;
            if (!int.TryParse(hidQuestionId.Value, out int id) || id <= 0) return;

            // refuse delete if linked
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("SELECT COUNT(*) FROM dbo.QuestionBank WHERE QuestionId=@id;", con))
            { cmd.Parameters.AddWithValue("@id", id); con.Open(); if ((int)cmd.ExecuteScalar() > 0) { Show("Cannot delete: linked to quizzes."); return; } }

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("DELETE FROM dbo.Questions WHERE QuestionId=@id;", con))
            { cmd.Parameters.AddWithValue("@id", id); con.Open(); cmd.ExecuteNonQuery(); }

            // refresh list & index
            LoadIds();
            if (Ids == null || Ids.Rows.Count == 0) { DisableAll("No questions left."); return; }
            if (CurrentIndex >= Ids.Rows.Count) CurrentIndex = Ids.Rows.Count - 1;
            BindCurrent();
            Show("Deleted.");
        }

        private void Show(string m) { lblMsg.Text = m; lblMsg.Visible = true; }

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
