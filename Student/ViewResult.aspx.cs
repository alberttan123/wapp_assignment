using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using System.Threading.Tasks;
using System.Web.UI;
using System.Web.UI.WebControls;
using static WAPP_Assignment.DataAccess;

namespace WAPP_Assignment.Student
{
    public partial class ViewResult : Page
    {
        private const int EXERCISE_XP = 10;

        [Serializable]
        private class QuestionDetailDto
        {
            public int Index { get; set; }
            public string QuestionText { get; set; }
            public string UserAnswerText { get; set; }
            public string CorrectAnswerText { get; set; }
            public bool IsCorrect { get; set; }
            public string ImageUrl { get; set; }
        }

        private class ResultHeaderDto
        {
            public int QuizTryId { get; set; }
            public DateTime AttemptDate { get; set; }
            public string QuizTitle { get; set; }
            public string QuizType { get; set; } // exercise / assessment
            public int TotalQuestions { get; set; }
            public int CorrectCount { get; set; }
            public int ScorePercent { get; set; }
            public int XpAwarded { get; set; }
        }

        private int QuizTryId
        {
            get => (int)(ViewState["QuizTryId"] ?? 0);
            set => ViewState["QuizTryId"] = value;
        }

        private List<QuestionDetailDto> QuestionDetails
        {
            get => (List<QuestionDetailDto>)ViewState["QuestionDetails"];
            set => ViewState["QuestionDetails"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializePage();
            }
        }

        private void InitializePage()
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

            string qtRaw = Request.QueryString["QuizTryId"];
            if (string.IsNullOrEmpty(qtRaw) || !int.TryParse(qtRaw, out int quizTryId))
            {
                Response.Redirect("~/Student/AllResults.aspx", true);
                return;
            }

            QuizTryId = quizTryId;

            // Load header + questions
            var header = LoadResultHeader(userId, quizTryId);
            if (header == null)
            {
                // attempt not found or not owned by user
                Response.Redirect("~/Student/AllResults.aspx", true);
                return;
            }

            var details = LoadQuestionDetails(quizTryId);
            QuestionDetails = details;

            BindHeader(header);
            BindQuestions(details);
        }

        private ResultHeaderDto LoadResultHeader(int userId, int quizTryId)
        {
            ResultHeaderDto header = null;

            using (var conn = GetOpenConnection())
            {
                // 1) fetch quiz + attempt + score
                using (var cmd = new SqlCommand(@"
                    SELECT 
                        qt.UniqueId       AS QuizTryId,
                        qt.CreatedAt,
                        q.QuizTitle,
                        q.QuizType
                    FROM dbo.QuizTry qt
                    JOIN dbo.Quiz q
                        ON q.QuizId = qt.QuizId
                    WHERE qt.UniqueId = @QuizTryId
                      AND qt.UserId   = @UserId;
                ", conn))
                {
                    cmd.Parameters.AddWithValue("@QuizTryId", quizTryId);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    using (var rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read())
                            return null;

                        header = new ResultHeaderDto
                        {
                            QuizTryId = rd.GetInt32(0),
                            AttemptDate = rd.GetDateTime(1),
                            QuizTitle = rd.GetString(2),
                            QuizType = rd.GetString(3)
                        };
                    }
                }

                // 2) compute correct / total from UserAnswer + Questions
                int total = 0;
                int correct = 0;

                using (var cmd = new SqlCommand(@"
                    SELECT 
                        ua.SelectedOption,
                        q.CorrectAnswer
                    FROM dbo.UserAnswer ua
                    JOIN dbo.Questions q
                        ON q.QuestionId = ua.QuestionId
                    WHERE ua.QuizTryId = @QuizTryId;
                ", conn))
                {
                    cmd.Parameters.AddWithValue("@QuizTryId", quizTryId);

                    using (var rd = cmd.ExecuteReader())
                    {
                        while (rd.Read())
                        {
                            total++;
                            int selected = rd.GetInt32(0);
                            int correctOption = rd.GetInt32(1);
                            if (selected == correctOption)
                                correct++;
                        }
                    }
                }

                header.TotalQuestions = total;
                header.CorrectCount = correct;

                int scorePercent = 0;
                if (total > 0)
                {
                    scorePercent = (int)Math.Round(correct * 100.0 / total);
                }

                header.ScorePercent = scorePercent;

                if (header.QuizType.Equals("exercise", StringComparison.OrdinalIgnoreCase))
                {
                    header.XpAwarded = EXERCISE_XP;
                }
                else
                {
                    header.XpAwarded = (int)Math.Round(scorePercent / 2.0);
                }
            }

            return header;
        }

        private List<QuestionDetailDto> LoadQuestionDetails(int quizTryId)
        {
            var list = new List<QuestionDetailDto>();

            using (var conn = GetOpenConnection())
            using (var cmd = new SqlCommand(@"
                SELECT 
                    ua.QuestionId,
                    ua.SelectedOption,
                    q.Question,
                    q.Option1,
                    q.Option2,
                    q.Option3,
                    q.Option4,
                    q.CorrectAnswer,
                    q.ImageUrl
                FROM dbo.UserAnswer ua
                JOIN dbo.Questions q
                    ON q.QuestionId = ua.QuestionId
                WHERE ua.QuizTryId = @QuizTryId
                ORDER BY ua.UserAnswerId ASC;
            ", conn))
            {
                cmd.Parameters.AddWithValue("@QuizTryId", quizTryId);

                using (var rd = cmd.ExecuteReader())
                {
                    int index = 1;
                    while (rd.Read())
                    {
                        int selectedOption = rd.GetInt32(1);
                        string questionText = rd.GetString(2);
                        string opt1 = rd.GetString(3);
                        string opt2 = rd.GetString(4);
                        string opt3 = rd.IsDBNull(5) ? null : rd.GetString(5);
                        string opt4 = rd.IsDBNull(6) ? null : rd.GetString(6);
                        int correctOption = rd.GetInt32(7);
                        string imageUrl = rd.IsDBNull(8) ? null : rd.GetString(8);

                        string userAnswerText = OptionIndexToText(selectedOption, opt1, opt2, opt3, opt4);
                        if (string.IsNullOrEmpty(userAnswerText))
                            userAnswerText = "(No answer)";

                        string correctAnswerText = OptionIndexToText(correctOption, opt1, opt2, opt3, opt4);

                        list.Add(new QuestionDetailDto
                        {
                            Index = index++,
                            QuestionText = questionText,
                            UserAnswerText = userAnswerText,
                            CorrectAnswerText = correctAnswerText,
                            IsCorrect = (selectedOption == correctOption && selectedOption != 0),
                            ImageUrl = imageUrl
                        });
                    }
                }
            }

            return list;
        }

        private string OptionIndexToText(int index, string opt1, string opt2, string opt3, string opt4)
        {
            switch (index)
            {
                case 1: return opt1;
                case 2: return opt2;
                case 3: return opt3;
                case 4: return opt4;
                default: return null;
            }
        }

        private void BindHeader(ResultHeaderDto header)
        {
            lblQuizTitle.Text = header.QuizTitle;

            string typeLabel = header.QuizType.Equals("assessment", StringComparison.OrdinalIgnoreCase)
                ? "Assessment"
                : "Exercise";

            lblQuizSubtitle.Text = $"{typeLabel} attempt";

            lblAttemptDate.Text = header.AttemptDate.ToString("yyyy-MM-dd HH:mm");
            lblQuizType.Text = typeLabel;
            lblQuizTypeChip.Text = typeLabel;

            // Chip styling
            string chipCss = "result-meta-chip";
            if (header.QuizType.Equals("assessment", StringComparison.OrdinalIgnoreCase))
            {
                chipCss += " assessment";
            }
            spanQuizTypeChip.Attributes["class"] = chipCss;

            lblScoreSummary.Text = header.TotalQuestions > 0
                ? $"{header.CorrectCount} / {header.TotalQuestions} ({header.ScorePercent}%)"
                : "No questions recorded";

            lblXpEarned.Text = $"{header.XpAwarded} XP";
        }

        private void BindQuestions(List<QuestionDetailDto> details)
        {
            rptQuestionDetails.DataSource = details;
            rptQuestionDetails.DataBind();
        }

        protected void rptQuestionDetails_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            var dto = (QuestionDetailDto)e.Item.DataItem;

            var pnlCard = (Panel)e.Item.FindControl("pnlQuestionCard");
            var pnlImage = (Panel)e.Item.FindControl("pnlImage");
            var img = (Image)e.Item.FindControl("imgQuestion");

            // apply correct/incorrect class
            string baseClass = "result-question-card";
            if (dto.IsCorrect)
                baseClass += " correct";
            else
                baseClass += " incorrect";

            pnlCard.CssClass = baseClass;

            // image
            if (!string.IsNullOrEmpty(dto.ImageUrl))
            {
                pnlImage.Visible = true;
                img.ImageUrl = dto.ImageUrl;
                img.AlternateText = "Question image";
            }
            else
            {
                pnlImage.Visible = false;
            }
        }

        protected async void btnGenerateAi_Click(object sender, EventArgs e)
        {
            try
            {
                var details = QuestionDetails;
                if (details == null || details.Count == 0)
                {
                    lblAiSummary.Text = "No question details available for this result.";
                    return;
                }

                var sb = new StringBuilder();
                sb.AppendLine("You are a tutoring assistant. The student completed a quiz attempt. ");
                sb.AppendLine("Summarize their performance in short bullet points: key strengths, mistakes, and tips.");
                sb.AppendLine();
                sb.AppendLine("Questions and answers:");

                int i = 1;
                foreach (var d in details)
                {
                    sb.AppendLine($"Q{i}: {d.QuestionText}");
                    sb.AppendLine($"User answer: {d.UserAnswerText}");
                    sb.AppendLine($"Correct answer: {d.CorrectAnswerText}");
                    sb.AppendLine($"Is correct: {d.IsCorrect}");
                    sb.AppendLine();
                    i++;
                }

                string prompt = sb.ToString();
                string systemConfig =
                    "You summarize quiz attempts in concise, student-friendly bullet points. " +
                    "Focus on patterns, common misconceptions, and actionable advice. " +
                    "Keep it short, 4–7 bullets.";

                string text = await GeminiHelper.Gemini(prompt, systemConfig);

                if (string.IsNullOrWhiteSpace(text))
                    lblAiSummary.Text = "Explanation could not be generated.";
                else
                    lblAiSummary.Text = text.Trim();
            }
            catch (Exception ex)
            {
                lblAiSummary.Text = $"Explanation could not be generated. ({ex.Message})";
            }
        }
    }
}
