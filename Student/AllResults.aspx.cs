using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.UI;
using static WAPP_Assignment.DataAccess;

namespace WAPP_Assignment.Student
{
    public partial class AllResults : Page
    {
        private const int EXERCISE_XP = 10; // fixed XP per exercise attempt

        private class ResultRowDto
        {
            public int QuizTryId { get; set; }
            public DateTime AttemptDate { get; set; }
            public string QuizTitle { get; set; }
            public string QuizType { get; set; } // "exercise" / "assessment"
            public int TotalQuestions { get; set; }
            public int CorrectCount { get; set; }
            public int? ScorePercentDb { get; set; }

            // convenience for binding
            public string QuizTypeLabel =>
                QuizType.Equals("assessment", StringComparison.OrdinalIgnoreCase)
                    ? "Assessment"
                    : "Exercise";

            public string QuizTypeCss =>
                QuizType.Equals("assessment", StringComparison.OrdinalIgnoreCase)
                    ? "assessment"
                    : "exercise";

            public int ScorePercent
            {
                get
                {
                    if (TotalQuestions > 0)
                    {
                        var pct = (int)Math.Round(CorrectCount * 100.0 / TotalQuestions);
                        return pct;
                    }

                    return ScorePercentDb ?? 0;
                }
            }

            public string ScoreLabel =>
                TotalQuestions > 0
                    ? $"{CorrectCount} / {TotalQuestions}"
                    : "N/A";

            public string ScorePercentLabel => $"{ScorePercent}%";

            public int XpAwarded
            {
                get
                {
                    if (QuizType.Equals("exercise", StringComparison.OrdinalIgnoreCase))
                        return EXERCISE_XP;

                    return (int)Math.Round(ScorePercent / 2.0); // assessment formula
                }
            }

            public string XpLabel => $"{XpAwarded} XP";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadResults();
            }
        }

        private void LoadResults()
        {
            var (isAuthenticated, userIdStr, userType) = AuthCookieHelper.ReadAuthCookie();
            if (!isAuthenticated || string.IsNullOrEmpty(userIdStr))
            {
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            if (!int.TryParse(userIdStr, out int userId))
            {
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            var list = new List<ResultRowDto>();

            using (var conn = GetOpenConnection())
            using (var cmd = new SqlCommand(@"
                -- aggregate correct/total per attempt
                WITH QA AS (
                    SELECT 
                        ua.QuizTryId,
                        COUNT(*) AS TotalQuestions,
                        SUM(CASE WHEN ua.SelectedOption = q.CorrectAnswer THEN 1 ELSE 0 END) AS CorrectCount
                    FROM dbo.UserAnswer ua
                    JOIN dbo.Questions q ON q.QuestionId = ua.QuestionId
                    GROUP BY ua.QuizTryId
                )
                SELECT 
                    qt.UniqueId       AS QuizTryId,
                    qt.CreatedAt,
                    q.QuizTitle,
                    q.QuizType,
                    ISNULL(qa.TotalQuestions, 0) AS TotalQuestions,
                    ISNULL(qa.CorrectCount, 0)   AS CorrectCount,
                    s.ScorePercent
                FROM dbo.QuizTry qt
                JOIN dbo.Quiz q 
                    ON q.QuizId = qt.QuizId
                LEFT JOIN QA
                    ON QA.QuizTryId = qt.UniqueId
                LEFT JOIN dbo.Score s
                    ON s.QuizTryId = qt.UniqueId AND s.UserId = qt.UserId
                WHERE qt.UserId = @UserId
                ORDER BY qt.CreatedAt DESC;
            ", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);

                using (var rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        var row = new ResultRowDto
                        {
                            QuizTryId = rd.GetInt32(0),
                            AttemptDate = rd.GetDateTime(1),
                            QuizTitle = rd.GetString(2),
                            QuizType = rd.GetString(3),
                            TotalQuestions = rd.GetInt32(4),
                            CorrectCount = rd.GetInt32(5),
                            ScorePercentDb = rd.IsDBNull(6) ? (int?)null : rd.GetInt32(6)
                        };

                        list.Add(row);
                    }
                }
            }

            if (list.Count == 0)
            {
                pnlNoResults.Visible = true;
                pnlResults.Visible = false;
                return;
            }

            pnlNoResults.Visible = false;
            pnlResults.Visible = true;

            rptResults.DataSource = list;
            rptResults.DataBind();
        }
    }
}
