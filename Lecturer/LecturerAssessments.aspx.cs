using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace WAPP_Assignment.Lecturer
{
    public partial class LecturerAssessments : System.Web.UI.Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindAssessments();
        }

        private int GetCurrentEducatorId()
        {
            // Use your actual auth/session value if available.
            if (Session["UserId"] is int uid) return uid;
            return 2; // fallback to geo_teacher from seed data
        }

        private bool QuizHasCreatedByColumn()
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT COUNT(*) FROM sys.columns
WHERE object_id = OBJECT_ID('dbo.Quiz') AND name = 'CreatedBy';", con))
            {
                con.Open();
                var count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        private void BindAssessments()
        {
            lblInfo.Visible = false;
            bool hasCreatedBy = QuizHasCreatedByColumn();
            int educatorId = GetCurrentEducatorId();

            // Base query: only assessments
            string sql = @"
SELECT q.QuizId, q.QuizTitle, q.QuizType,
       (SELECT COUNT(*) FROM dbo.QuestionBank qb WHERE qb.QuizId = q.QuizId) AS QuestionCount
FROM dbo.Quiz q
WHERE q.QuizType = 'assessment'";

            // Always scope to current educator if CreatedBy exists
            if (hasCreatedBy)
                sql += " AND q.CreatedBy = @uid";

            // Optional title search
            if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                sql += " AND q.QuizTitle LIKE @search";

            sql += " ORDER BY q.QuizTitle ASC";

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, con))
            using (var da = new SqlDataAdapter(cmd))
            {
                if (hasCreatedBy)
                    cmd.Parameters.AddWithValue("@uid", educatorId);

                if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                    cmd.Parameters.AddWithValue("@search", "%" + txtSearch.Text.Trim() + "%");

                var dt = new DataTable();
                da.Fill(dt);
                rptAssessments.DataSource = dt;
                rptAssessments.DataBind();

                if (dt.Rows.Count == 0)
                {
                    lblInfo.Text = hasCreatedBy
                        ? "No assessments found for your account."
                        : "No assessments found. (Tip: run the CreatedBy migration to scope by educator.)";
                    lblInfo.Visible = true;
                }
            }
        }

        protected void TxtSearch_TextChanged(object sender, EventArgs e) => BindAssessments();

        protected void RptAssessments_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "delete")
            {
                if (!int.TryParse((string)e.CommandArgument, out int quizId))
                    return;

                using (var con = new SqlConnection(ConnStr))
                {
                    con.Open();
                    using (var tx = con.BeginTransaction())
                    {
                        try
                        {
                            // Remove links first
                            using (var cmd = new SqlCommand(
                                "DELETE FROM dbo.QuestionBank WHERE QuizId = @id;", con, tx))
                            {
                                cmd.Parameters.AddWithValue("@id", quizId);
                                cmd.ExecuteNonQuery();
                            }

                            // Delete quiz
                            using (var cmd = new SqlCommand(
                                "DELETE FROM dbo.Quiz WHERE QuizId = @id;", con, tx))
                            {
                                cmd.Parameters.AddWithValue("@id", quizId);
                                cmd.ExecuteNonQuery();
                            }

                            tx.Commit();
                        }
                        catch
                        {
                            tx.Rollback();
                            // Optional: surface error to a label
                        }
                    }
                }

                BindAssessments();
            }
        }
    }
}
