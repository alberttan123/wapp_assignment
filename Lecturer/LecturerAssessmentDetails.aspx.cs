using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WAPP_Assignment.Lecturer
{
    public partial class LecturerAssessmentDetails : System.Web.UI.Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        private int QuizId
        {
            get
            {
                if (ViewState["QuizId"] is int id) return id;
                if (int.TryParse(Request.QueryString["quizId"], out int qid))
                {
                    ViewState["QuizId"] = qid;
                    return qid;
                }
                return -1;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (QuizId <= 0)
                {
                    ShowInfo("Invalid assessment id.");
                    return;
                }
                if (!EnsureOwnershipAndLoadHeader())
                    return;

                BindAssessmentQuestions();
                BindExercises();
                BindExerciseQuestions(); // for initial selection (if any)
            }
        }

        private int CurrentEducatorId()
        {
            if (Session["UserId"] is int uid) return uid;
            return 2; // fallback to geo_teacher
        }

        private bool QuizHasCreatedBy()
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(
                "SELECT COUNT(*) FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Quiz') AND name = 'CreatedBy';", con))
            {
                con.Open();
                return (int)cmd.ExecuteScalar() > 0;
            }
        }

        /// <summary>
        /// Ensures the quiz is an 'assessment' and (if CreatedBy exists) belongs to current educator.
        /// Also binds header (title/meta) and sets txtTitle.
        /// </summary>
        private bool EnsureOwnershipAndLoadHeader()
        {
            bool hasCreatedBy = QuizHasCreatedBy();

            string sql = @"
SELECT QuizId, QuizTitle, QuizType
FROM dbo.Quiz
WHERE QuizId = @id AND QuizType = 'assessment'";

            if (hasCreatedBy) sql += " AND CreatedBy = @uid";

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@id", QuizId);
                if (hasCreatedBy) cmd.Parameters.AddWithValue("@uid", CurrentEducatorId());

                con.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (!r.Read())
                    {
                        ShowInfo("Assessment not found or you do not have permission to view it.");
                        return false;
                    }

                    string title = r["QuizTitle"].ToString();
                    string type = r["QuizType"].ToString();

                    litTitle.Text = title;
                    txtTitle.Text = title;

                    int qCount = GetQuestionCount(QuizId);
                    litMeta.Text = $"Type: {type} • Questions: {qCount}";
                }
            }
            return true;
        }

        private int GetQuestionCount(int quizId)
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("SELECT COUNT(*) FROM dbo.QuestionBank WHERE QuizId = @id;", con))
            {
                cmd.Parameters.AddWithValue("@id", quizId);
                con.Open();
                return (int)cmd.ExecuteScalar();
            }
        }

        private void ShowInfo(string msg)
        {
            lblInfo.Text = msg;
            lblInfo.Visible = true;
        }

        /* =================== LEFT: Assessment questions =================== */

        private void BindAssessmentQuestions()
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT q.QuestionId, q.Question, q.Option1, q.Option2, q.Option3, q.Option4, q.CorrectAnswer
FROM dbo.QuestionBank qb
JOIN dbo.Questions q ON q.QuestionId = qb.QuestionId
WHERE qb.QuizId = @id
ORDER BY q.QuestionId;", con))
            using (var da = new SqlDataAdapter(cmd))
            {
                cmd.Parameters.AddWithValue("@id", QuizId);
                var dt = new DataTable();
                da.Fill(dt);
                rptQuestions.DataSource = dt;
                rptQuestions.DataBind();
            }
        }

        protected void RptQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "remove" && int.TryParse((string)e.CommandArgument, out int qid))
            {
                using (var con = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand("DELETE FROM dbo.QuestionBank WHERE QuizId=@qid AND QuestionId=@qq;", con))
                {
                    cmd.Parameters.AddWithValue("@qid", QuizId);
                    cmd.Parameters.AddWithValue("@qq", qid);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                // refresh header meta (question count) and questions list
                EnsureOwnershipAndLoadHeader();
                BindAssessmentQuestions();
            }
        }

        /* =================== RIGHT: Add from exercises =================== */

        private void BindExercises()
        {
            // Only exercises
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT QuizId, QuizTitle
FROM dbo.Quiz
WHERE QuizType = 'exercise'
ORDER BY QuizTitle;", con))
            using (var da = new SqlDataAdapter(cmd))
            {
                var dt = new DataTable();
                da.Fill(dt);

                ddlExercise.Items.Clear();
                ddlExercise.Items.Add(new ListItem("-- Select an exercise --", ""));

                foreach (DataRow r in dt.Rows)
                {
                    ddlExercise.Items.Add(new ListItem(r["QuizTitle"].ToString(), r["QuizId"].ToString()));
                }
            }
        }

        private void BindExerciseQuestions()
        {
            rptExerciseQuestions.DataSource = null;
            rptExerciseQuestions.DataBind();

            if (!int.TryParse(ddlExercise.SelectedValue, out int exId) || exId <= 0)
                return;

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT q.QuestionId, q.Question
FROM dbo.QuestionBank qb
JOIN dbo.Questions q ON q.QuestionId = qb.QuestionId
WHERE qb.QuizId = @ex
ORDER BY q.QuestionId;", con))
            using (var da = new SqlDataAdapter(cmd))
            {
                cmd.Parameters.AddWithValue("@ex", exId);
                var dt = new DataTable();
                da.Fill(dt);
                rptExerciseQuestions.DataSource = dt;
                rptExerciseQuestions.DataBind();
            }
        }

        protected void DdlExercise_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindExerciseQuestions();
        }

        protected void RptExerciseQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "addone" && int.TryParse((string)e.CommandArgument, out int qid))
            {
                AddQuestionIfNotExists(qid);
                EnsureOwnershipAndLoadHeader();
                BindAssessmentQuestions();
            }
        }

        protected void BtnAddAllFromExercise_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(ddlExercise.SelectedValue, out int exId) || exId <= 0) return;

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT q.QuestionId
FROM dbo.QuestionBank qb
JOIN dbo.Questions q ON q.QuestionId = qb.QuestionId
WHERE qb.QuizId = @ex;", con))
            using (var da = new SqlDataAdapter(cmd))
            {
                cmd.Parameters.AddWithValue("@ex", exId);
                var dt = new DataTable();
                da.Fill(dt);

                using (var con2 = new SqlConnection(ConnStr))
                {
                    con2.Open();
                    using (var tx = con2.BeginTransaction())
                    {
                        try
                        {
                            foreach (DataRow r in dt.Rows)
                            {
                                int qid = (int)r["QuestionId"];
                                InsertQBIfNotExists(con2, tx, QuizId, qid);
                            }
                            tx.Commit();
                        }
                        catch
                        {
                            tx.Rollback();
                            // swallow here; keep UI simple
                        }
                    }
                }
            }

            EnsureOwnershipAndLoadHeader();
            BindAssessmentQuestions();
        }

        private void AddQuestionIfNotExists(int questionId)
        {
            using (var con = new SqlConnection(ConnStr))
            {
                con.Open();
                using (var tx = con.BeginTransaction())
                {
                    try
                    {
                        InsertQBIfNotExists(con, tx, QuizId, questionId);
                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                    }
                }
            }
        }

        private void InsertQBIfNotExists(SqlConnection con, SqlTransaction tx, int quizId, int questionId)
        {
            using (var check = new SqlCommand(
                "SELECT COUNT(*) FROM dbo.QuestionBank WHERE QuizId=@q AND QuestionId=@qq;", con, tx))
            {
                check.Parameters.AddWithValue("@q", quizId);
                check.Parameters.AddWithValue("@qq", questionId);
                int exists = (int)check.ExecuteScalar();
                if (exists == 0)
                {
                    using (var ins = new SqlCommand(
                        "INSERT INTO dbo.QuestionBank(QuizId, QuestionId) VALUES(@q,@qq);", con, tx))
                    {
                        ins.Parameters.AddWithValue("@q", quizId);
                        ins.Parameters.AddWithValue("@qq", questionId);
                        ins.ExecuteNonQuery();
                    }
                }
            }
        }

        /* =================== Title update =================== */

        protected void BtnSaveTitle_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;
            string newTitle = (txtTitle.Text ?? "").Trim();
            if (string.IsNullOrEmpty(newTitle))
            {
                lblMsg.Text = "Title cannot be empty.";
                lblMsg.Visible = true;
                return;
            }

            bool hasCreatedBy = QuizHasCreatedBy();
            string sql = "UPDATE dbo.Quiz SET QuizTitle=@t WHERE QuizId=@id AND QuizType='assessment'";
            if (hasCreatedBy) sql += " AND CreatedBy=@uid";

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@t", newTitle);
                cmd.Parameters.AddWithValue("@id", QuizId);
                if (hasCreatedBy) cmd.Parameters.AddWithValue("@uid", CurrentEducatorId());

                con.Open();
                int n = cmd.ExecuteNonQuery();

                if (n == 0)
                {
                    lblMsg.Text = "Unable to update title (permission or not found).";
                    lblMsg.Visible = true;
                    return;
                }
            }

            // refresh header/title
            EnsureOwnershipAndLoadHeader();
            lblMsg.Text = "Title saved.";
            lblMsg.Visible = true;
        }
    }
}
