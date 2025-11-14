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

        private DataTable Ids
        {
            get => ViewState["Ids"] as DataTable;
            set => ViewState["Ids"] = value;
        }

        private int CurrentIndex
        {
            get => ViewState["Idx"] is int i ? i : 0;
            set => ViewState["Idx"] = value;
        }

        private bool EditVisible
        {
            get => ViewState["EditVisible"] is bool b && b;
            set => ViewState["EditVisible"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.Form != null)
                Page.Form.Enctype = "multipart/form-data";

            if (!IsPostBack)
            {
                LoadIds();

                bool startExpanded = false;
                if (int.TryParse(Request.QueryString["id"], out int qid))
                {
                    JumpToId(qid);
                    startExpanded = true;
                }

                chkExpanded.Checked = startExpanded;
                BindAccordingToMode();
            }
        }

        /* ========== Data helpers ========== */

        private void LoadIds()
        {
            using (var con = new SqlConnection(ConnStr))
            using (var da = new SqlDataAdapter("SELECT QuestionId FROM dbo.Questions ORDER BY QuestionId ASC;", con))
            {
                var dt = new DataTable();
                da.Fill(dt);
                Ids = dt;

                if (dt.Rows.Count == 0)
                {
                    lblMsg.Text = "No questions available yet.";
                    lblMsg.Visible = true;
                    pnlList.Visible = false;
                    pnlExpanded.Visible = false;
                }
            }
        }

        private void JumpToId(int qid)
        {
            if (Ids == null) return;
            for (int i = 0; i < Ids.Rows.Count; i++)
            {
                if ((int)Ids.Rows[i]["QuestionId"] == qid)
                {
                    CurrentIndex = i;
                    return;
                }
            }
        }

        private int CurrentQuestionId()
        {
            if (Ids == null || Ids.Rows.Count == 0) return -1;
            if (CurrentIndex < 0) CurrentIndex = 0;
            if (CurrentIndex >= Ids.Rows.Count) CurrentIndex = Ids.Rows.Count - 1;
            return (int)Ids.Rows[CurrentIndex]["QuestionId"];
        }

        /* ========== Mode switching ========== */

        private void BindAccordingToMode()
        {
            if (Ids == null || Ids.Rows.Count == 0) return;

            pnlList.Visible = !chkExpanded.Checked;
            pnlExpanded.Visible = chkExpanded.Checked;

            if (!chkExpanded.Checked)
            {
                BindList();
            }
            else
            {
                BindExpanded();
            }
        }

        protected void ChkExpanded_CheckedChanged(object sender, EventArgs e)
        {
            // Reset edit panel when switching view
            EditVisible = false;
            BindAccordingToMode();
        }

        /* ========== List mode ========== */

        private void BindList()
        {
            using (var con = new SqlConnection(ConnStr))
            using (var da = new SqlDataAdapter(@"
SELECT QuestionId, Question, CorrectAnswer
FROM dbo.Questions
ORDER BY QuestionId ASC;", con))
            {
                var dt = new DataTable();
                da.Fill(dt);
                rptList.DataSource = dt;
                rptList.DataBind();
            }
        }

        protected void RptList_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "view")
            {
                if (int.TryParse(e.CommandArgument as string, out int qid))
                {
                    JumpToId(qid);
                    chkExpanded.Checked = true;
                    EditVisible = false;
                    BindAccordingToMode();
                }
            }
        }

        /* ========== Expanded mode ========== */

        private void BindExpanded()
        {
            int id = CurrentQuestionId();
            if (id <= 0) return;

            litCounter.Text = $"{CurrentIndex + 1} / {Ids.Rows.Count}";
            btnPrev.Enabled = CurrentIndex > 0;
            btnNext.Enabled = CurrentIndex < Ids.Rows.Count - 1;

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT QuestionId, Question, Option1, Option2, Option3, Option4, CorrectAnswer, ImageUrl
FROM dbo.Questions
WHERE QuestionId=@id;", con))
            {
                cmd.Parameters.AddWithValue("@id", id);
                con.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (!r.Read()) return;

                    int correct = (int)r["CorrectAnswer"];

                    litId.Text = r["QuestionId"].ToString();
                    litQ.Text = r["Question"].ToString();
                    litO1.Text = r["Option1"].ToString();
                    litO2.Text = r["Option2"].ToString();
                    litO3.Text = r["Option3"] == DBNull.Value ? "" : r["Option3"].ToString();
                    litO4.Text = r["Option4"] == DBNull.Value ? "" : r["Option4"].ToString();

                    // mark correct in view mode
                    viewOpt1.Attributes["class"] = "qv-opt" + (correct == 1 ? " is-correct" : "");
                    viewOpt2.Attributes["class"] = "qv-opt" + (correct == 2 ? " is-correct" : "");
                    viewOpt3.Attributes["class"] = "qv-opt" + (correct == 3 ? " is-correct" : "");
                    viewOpt4.Attributes["class"] = "qv-opt" + (correct == 4 ? " is-correct" : "");

                    string imgUrl = r["ImageUrl"] == DBNull.Value ? "" : r["ImageUrl"].ToString();
                    imgQ.Visible = !string.IsNullOrEmpty(imgUrl);
                    if (imgQ.Visible) imgQ.ImageUrl = ResolveUrl(imgUrl);

                    // populate edit panel
                    hfQuestionId.Value = r["QuestionId"].ToString();
                    txtQ.Text = r["Question"].ToString();
                    txtO1.Text = r["Option1"].ToString();
                    txtO2.Text = r["Option2"].ToString();
                    txtO3.Text = r["Option3"] == DBNull.Value ? "" : r["Option3"].ToString();
                    txtO4.Text = r["Option4"] == DBNull.Value ? "" : r["Option4"].ToString();
                    hfEditCorrectAnswer.Value = correct.ToString();
                    chkRemove.Checked = false;
                }
            }

            pnlEdit.Visible = EditVisible;
        }

        protected void BtnPrev_Click(object sender, EventArgs e)
        {
            if (CurrentIndex > 0) CurrentIndex--;
            EditVisible = false;
            BindExpanded();
        }

        protected void BtnNext_Click(object sender, EventArgs e)
        {
            if (Ids != null && CurrentIndex < Ids.Rows.Count - 1) CurrentIndex++;
            EditVisible = false;
            BindExpanded();
        }

        protected void BtnToggleEdit_Click(object sender, EventArgs e)
        {
            EditVisible = !EditVisible;
            BindExpanded();
        }

        /* ========== Update / Delete ========== */

        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            if (!int.TryParse(hfQuestionId.Value, out int id) || id <= 0)
                return;

            if (!ValidateEdit(out string err, out int ans))
            {
                lblMsg.Text = err;
                lblMsg.Visible = true;
                EditVisible = true;
                BindExpanded();
                return;
            }

            string imageSql = "";
            object imageVal = DBNull.Value;

            if (chkRemove.Checked)
            {
                imageSql = ", ImageUrl = NULL";
            }
            else if (fuImg.HasFile)
            {
                string rel = SaveImage(fuImg, id);
                imageSql = ", ImageUrl = @img";
                imageVal = rel;
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
                cmd.Parameters.AddWithValue("@o3",
                    string.IsNullOrWhiteSpace(txtO3.Text) ? (object)DBNull.Value : txtO3.Text.Trim());
                cmd.Parameters.AddWithValue("@o4",
                    string.IsNullOrWhiteSpace(txtO4.Text) ? (object)DBNull.Value : txtO4.Text.Trim());
                cmd.Parameters.AddWithValue("@ans", ans);
                cmd.Parameters.AddWithValue("@id", id);
                if (imageSql.Contains("@img"))
                    cmd.Parameters.AddWithValue("@img", imageVal);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            lblMsg.Text = "Question updated.";
            lblMsg.Visible = true;
            EditVisible = false;
            LoadIds();  // in case ordering changed or question list changed
            JumpToId(id);
            BindExpanded();
        }

        protected void BtnDelete_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            if (!int.TryParse(hfQuestionId.Value, out int id) || id <= 0)
                return;

            // block delete if linked
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("SELECT COUNT(*) FROM dbo.QuestionBank WHERE QuestionId=@id;", con))
            {
                cmd.Parameters.AddWithValue("@id", id);
                con.Open();
                int count = (int)cmd.ExecuteScalar();
                if (count > 0)
                {
                    lblMsg.Text = "Cannot delete: question is linked to one or more quizzes.";
                    lblMsg.Visible = true;
                    EditVisible = true;
                    BindExpanded();
                    return;
                }
            }

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("DELETE FROM dbo.Questions WHERE QuestionId=@id;", con))
            {
                cmd.Parameters.AddWithValue("@id", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            lblMsg.Text = "Question deleted.";
            lblMsg.Visible = true;

            LoadIds();
            if (Ids == null || Ids.Rows.Count == 0)
            {
                pnlList.Visible = false;
                pnlExpanded.Visible = false;
                return;
            }

            if (CurrentIndex >= Ids.Rows.Count)
                CurrentIndex = Ids.Rows.Count - 1;

            EditVisible = false;
            BindAccordingToMode();
        }

        private bool ValidateEdit(out string msg, out int ans)
        {
            msg = "";
            ans = 1;

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

            if (!int.TryParse(hfEditCorrectAnswer.Value, out ans) || ans < 1 || ans > 4)
            {
                msg = "Please choose a correct option.";
                return false;
            }
            if (ans == 3 && string.IsNullOrWhiteSpace(txtO3.Text))
            {
                msg = "Option 3 must have text if it is the correct answer.";
                return false;
            }
            if (ans == 4 && string.IsNullOrWhiteSpace(txtO4.Text))
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
                Directory.CreateDirectory(folder);

            string ext = Path.GetExtension(fu.FileName);
            if (string.IsNullOrEmpty(ext)) ext = ".png";

            string name = $"q-{id}-{DateTime.UtcNow.Ticks}{ext}";
            string physical = Path.Combine(folder, name);
            fu.SaveAs(physical);

            return "~/Uploads/Questions/" + name;
        }
    }
}
