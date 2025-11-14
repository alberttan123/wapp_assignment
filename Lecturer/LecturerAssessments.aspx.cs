using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WAPP_Assignment.Lecturer
{
    public partial class LecturerAssessments : System.Web.UI.Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        private int CurrentLecturerId
        {
            get
            {
                if (Session["UserId"] != null &&
                    int.TryParse(Session["UserId"].ToString(), out int uid))
                {
                    return uid;
                }
                // fallback to seeded educator if not logged in
                return 2;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindAssessments();
            }
        }

        protected void TxtSearch_TextChanged(object sender, EventArgs e)
        {
            BindAssessments();
        }

        private void BindAssessments()
        {
            lblInfo.Visible = false;

            string search = txtSearch.Text.Trim();
            bool hasCreatedBy = QuizHasCreatedBy();

            string sql = @"
SELECT q.QuizId,
       q.QuizTitle,
       (SELECT COUNT(*) FROM dbo.QuestionBank qb WHERE qb.QuizId = q.QuizId) AS QuestionCount
FROM dbo.Quiz q
WHERE q.QuizType = 'assessment'";

            if (hasCreatedBy)
            {
                sql += " AND q.CreatedBy = @uid";
            }

            if (!string.IsNullOrWhiteSpace(search))
            {
                sql += " AND q.QuizTitle LIKE @search";
            }

            sql += " ORDER BY q.QuizTitle;";

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, con))
            using (var da = new SqlDataAdapter(cmd))
            {
                if (hasCreatedBy)
                    cmd.Parameters.AddWithValue("@uid", CurrentLecturerId);
                if (!string.IsNullOrWhiteSpace(search))
                    cmd.Parameters.AddWithValue("@search", "%" + search + "%");

                var dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count == 0)
                {
                    lblInfo.Text = "No assessments found.";
                    lblInfo.Visible = true;
                }

                rptAssessments.DataSource = dt;
                rptAssessments.DataBind();
            }
        }

        private bool QuizHasCreatedBy()
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT CASE WHEN COL_LENGTH('dbo.Quiz','CreatedBy') IS NULL THEN 0 ELSE 1 END;", con))
            {
                con.Open();
                int v = (int)cmd.ExecuteScalar();
                return v == 1;
            }
        }

        protected void RptAssessments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "delete")
                return;

            if (!int.TryParse(e.CommandArgument as string, out int quizId) || quizId <= 0)
                return;

            using (var con = new SqlConnection(ConnStr))
            {
                con.Open();
                using (var tx = con.BeginTransaction())
                using (var cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.Transaction = tx;

                    try
                    {
                        // remove links from QuestionBank first
                        cmd.CommandText = "DELETE FROM dbo.QuestionBank WHERE QuizId = @qid;";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@qid", quizId);
                        cmd.ExecuteNonQuery();

                        // then delete the Quiz row
                        cmd.CommandText = "DELETE FROM dbo.Quiz WHERE QuizId = @qid;";
                        cmd.ExecuteNonQuery();

                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        lblInfo.Text = "Failed to delete assessment.";
                        lblInfo.Visible = true;
                    }
                }
            }

            BindAssessments();
        }
    }
}