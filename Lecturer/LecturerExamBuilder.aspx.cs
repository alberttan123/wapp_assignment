using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace WAPP_Assignment.Lecturer
{
    public partial class LecturerExamBuilder : System.Web.UI.Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        // Track which quizzes are expanded (to show/hide inline questions)
        private HashSet<int> Expanded
        {
            get
            {
                if (ViewState["Expanded"] is string s && !string.IsNullOrEmpty(s))
                    return new HashSet<int>(s.Split(',').Select(int.Parse));
                return new HashSet<int>();
            }
            set
            {
                ViewState["Expanded"] = string.Join(",", value);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindQuizzes();
                BindTopics();
                EnsureCart();
                BindCart();
            }
        }

        /* ---------- Binding ---------- */
        private void BindQuizzes()
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT z.QuizId, z.QuizTitle
FROM dbo.Quiz z
ORDER BY z.QuizTitle ASC", con))
            using (var da = new SqlDataAdapter(cmd))
            {
                var dt = new DataTable();
                da.Fill(dt);
                ddlQuiz.Items.Clear();
                ddlQuiz.Items.Add(new System.Web.UI.WebControls.ListItem("All Quizzes", "all"));
                foreach (DataRow r in dt.Rows)
                {
                    ddlQuiz.Items.Add(new System.Web.UI.WebControls.ListItem(
                        r["QuizTitle"].ToString(), r["QuizId"].ToString()));
                }
            }
        }

        private void BindTopics()
        {
            var search = txtSearch.Text?.Trim();
            var quizFilter = ddlQuiz.SelectedValue;

            var sql = @"
SELECT
    z.QuizId,
    z.QuizTitle,
    (SELECT COUNT(*) FROM dbo.QuestionBank qb WHERE qb.QuizId = z.QuizId) AS QuestionCount
FROM dbo.Quiz z
WHERE 1=1
" + (string.IsNullOrWhiteSpace(search) ? "" : " AND z.QuizTitle LIKE @search ") +
    ((string.IsNullOrEmpty(quizFilter) || quizFilter == "all") ? "" : " AND z.QuizId = @quizId ") +
    " ORDER BY z.QuizTitle ";

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, con))
            using (var da = new SqlDataAdapter(cmd))
            {
                if (!string.IsNullOrWhiteSpace(search))
                    cmd.Parameters.AddWithValue("@search", "%" + search + "%");
                if (!string.IsNullOrEmpty(quizFilter) && quizFilter != "all")
                    cmd.Parameters.AddWithValue("@quizId", int.Parse(quizFilter));

                var dt = new DataTable();
                da.Fill(dt);
                rptTopics.DataSource = dt;
                rptTopics.DataBind();
            }
        }

        private void EnsureCart()
        {
            if (Session["ExamDraft"] == null)
            {
                var dt = new DataTable();
                dt.Columns.Add("QuestionId", typeof(int));
                dt.Columns.Add("Question", typeof(string));
                Session["ExamDraft"] = dt;
            }
        }

        private void BindCart()
        {
            var dt = Session["ExamDraft"] as DataTable;
            rptCart.DataSource = dt;
            rptCart.DataBind();
            txtTotal.Text = (dt?.Rows.Count ?? 0).ToString();
        }

        /* ---------- Events ---------- */
        protected void TxtSearch_TextChanged(object sender, EventArgs e) => BindTopics();
        protected void DdlQuiz_SelectedIndexChanged(object sender, EventArgs e) => BindTopics();

        protected void RptTopics_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "addall")
            {
                int quizId = int.Parse((string)e.CommandArgument);
                AddQuizQuestionsToCart(quizId);
            }
            else if (e.CommandName == "toggle")
            {
                int quizId = int.Parse((string)e.CommandArgument);
                var exp = Expanded;
                if (exp.Contains(quizId)) exp.Remove(quizId); else exp.Add(quizId);
                Expanded = exp;
                // Rebind to reflect visibility + (re)loaded questions
                BindTopics();
            }
        }

        protected void RptTopics_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != System.Web.UI.WebControls.ListItemType.Item &&
                e.Item.ItemType != System.Web.UI.WebControls.ListItemType.AlternatingItem) return;

            var data = (DataRowView)e.Item.DataItem;
            int quizId = (int)data["QuizId"];

            var pnl = (System.Web.UI.WebControls.Panel)e.Item.FindControl("pnlQuestions");
            var rpt = (System.Web.UI.WebControls.Repeater)e.Item.FindControl("rptQuestions");
            var btnToggle = (System.Web.UI.WebControls.LinkButton)e.Item.FindControl("btnToggle");

            bool isExpanded = Expanded.Contains(quizId);
            pnl.Visible = isExpanded;
            btnToggle.Text = isExpanded ? "Hide Questions" : "Show Questions";

            if (isExpanded)
            {
                using (var con = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand(@"
SELECT q.QuestionId, q.Question
FROM dbo.QuestionBank qb
JOIN dbo.Questions q ON q.QuestionId = qb.QuestionId
WHERE qb.QuizId = @quizId
ORDER BY q.QuestionId", con))
                using (var da = new SqlDataAdapter(cmd))
                {
                    cmd.Parameters.AddWithValue("@quizId", quizId);
                    var dt = new DataTable();
                    da.Fill(dt);
                    rpt.DataSource = dt;
                    rpt.DataBind();
                }
            }
        }

        // Handle per-question add from the nested questions repeater
        protected void RptQuestions_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "addone")
            {
                int qid = int.Parse((string)e.CommandArgument);
                AddSingleQuestionToCart(qid);
                BindCart();
            }
        }

        protected void RptCart_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "remove")
            {
                int qid = int.Parse((string)e.CommandArgument);
                var dt = Session["ExamDraft"] as DataTable;
                if (dt != null)
                {
                    for (int i = dt.Rows.Count - 1; i >= 0; i--)
                        if ((int)dt.Rows[i]["QuestionId"] == qid) dt.Rows.RemoveAt(i);
                    dt.AcceptChanges();
                }
                BindCart();
            }
        }

        private void AddSingleQuestionToCart(int questionId)
        {
            // Fetch the question text once and add if not exists
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT q.QuestionId, q.Question
FROM dbo.Questions q
WHERE q.QuestionId = @qid", con))
            using (var da = new SqlDataAdapter(cmd))
            {
                cmd.Parameters.AddWithValue("@qid", questionId);
                var temp = new DataTable();
                da.Fill(temp);

                if (temp.Rows.Count == 0) return;

                EnsureCart();
                var cart = Session["ExamDraft"] as DataTable;

                var found = cart.Select($"QuestionId = {questionId}");
                if (found.Length == 0)
                {
                    var r = temp.Rows[0];
                    var nr = cart.NewRow();
                    nr["QuestionId"] = (int)r["QuestionId"];
                    nr["Question"] = r["Question"].ToString();
                    cart.Rows.Add(nr);
                    cart.AcceptChanges();
                }
            }
        }

        private void AddQuizQuestionsToCart(int quizId)
        {
            var sql = @"
SELECT q.QuestionId, q.Question
FROM dbo.QuestionBank qb
JOIN dbo.Questions q ON q.QuestionId = qb.QuestionId
WHERE qb.QuizId = @quizId";

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, con))
            using (var da = new SqlDataAdapter(cmd))
            {
                cmd.Parameters.AddWithValue("@quizId", quizId);
                var temp = new DataTable();
                da.Fill(temp);

                EnsureCart();
                var cart = Session["ExamDraft"] as DataTable;

                foreach (DataRow r in temp.Rows)
                {
                    int qid = (int)r["QuestionId"];
                    var found = cart.Select($"QuestionId = {qid}");
                    if (found.Length == 0)
                    {
                        var nr = cart.NewRow();
                        nr["QuestionId"] = qid;
                        nr["Question"] = r["Question"].ToString();
                        cart.Rows.Add(nr);
                    }
                }
                cart.AcceptChanges();
            }
            BindCart();
        }

        protected void BtnSaveExam_Click(object sender, EventArgs e)
        {
            lblError.Visible = false;
            var title = txtExamTitle.Text?.Trim();

            if (string.IsNullOrWhiteSpace(title))
            {
                ShowErr("Please enter an exam title.");
                return;
            }

            var cart = Session["ExamDraft"] as DataTable;
            if (cart == null || cart.Rows.Count == 0)
            {
                ShowErr("Add questions to the cart before saving.");
                return;
            }

            using (var con = new SqlConnection(ConnStr))
            {
                con.Open();
                using (var tx = con.BeginTransaction())
                {
                    try
                    {
                        // Insert new quiz as an "assessment" (set QuizType to be assessment since it's an assessment builder...)
                        int quizId;
                        using (var cmd = new SqlCommand(@"
INSERT INTO dbo.Quiz(QuizTitle, QuizType)
VALUES(@t, @type);
SELECT CAST(SCOPE_IDENTITY() AS INT);", con, tx))
                        {
                            cmd.Parameters.AddWithValue("@t", title);
                            cmd.Parameters.AddWithValue("@type", "assessment");
                            quizId = (int)cmd.ExecuteScalar();
                        }


                        // Link questions into QuestionBank
                        using (var cmd = new SqlCommand(
                            @"INSERT INTO dbo.QuestionBank(QuizId, QuestionId) VALUES(@qz, @qid);", con, tx))
                        {
                            cmd.Parameters.Add("@qz", SqlDbType.Int).Value = quizId;
                            var pQ = cmd.Parameters.Add("@qid", SqlDbType.Int);

                            foreach (DataRow r in cart.Rows)
                            {
                                pQ.Value = (int)r["QuestionId"];
                                cmd.ExecuteNonQuery();
                            }
                        }

                        tx.Commit();

                        // Reset UI
                        cart.Rows.Clear(); cart.AcceptChanges();
                        BindCart();
                        txtExamTitle.Text = string.Empty; txtDuration.Text = string.Empty;
                        Expanded = new HashSet<int>(); // collapse any expanded lists
                        BindTopics();
                    }
                    catch (Exception ex)
                    {
                        tx.Rollback();
                        ShowErr("Failed to save exam: " + ex.Message);
                    }
                }
            }
        }

        private void ShowErr(string m)
        {
            lblError.Text = m;
            lblError.Visible = true;
        }
    }
}
