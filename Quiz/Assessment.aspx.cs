using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Web.UI;
using System.Web.UI.WebControls;
using static WAPP_Assignment.DataAccess;
// using WAPP_Assignment.Helpers; // adjust if GeminiHelper lives here

namespace WAPP_Assignment.Quiz
{
    public partial class Assessment : System.Web.UI.Page
    {
        private const string SESSION_QUESTIONS = "Assessment_Questions";
        private const string SESSION_INDEX = "Assessment_CurrentIndex";
        private const string SESSION_ANSWERS = "Assessment_Answers";
        private const string SESSION_QUIZID = "Assessment_QuizId";

        [Serializable]
        private class QuestionDto
        {
            public int QuizId { get; set; }
            public int QuestionId { get; set; }
            public string Question { get; set; }
            public string Option1 { get; set; }
            public string Option2 { get; set; }
            public string Option3 { get; set; }
            public string Option4 { get; set; }
            public int CorrectAnswer { get; set; }
            public string ImageUrl { get; set; }
        }

        [Serializable]
        private class ResultDto
        {
            public string QuestionText { get; set; }
            public string UserAnswerText { get; set; }
            public string CorrectAnswerText { get; set; }
            public bool IsCorrect { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializeAssessment();
            }
        }

        // ----------------------------------------------------
        // Initialization
        // ----------------------------------------------------
        private void InitializeAssessment()
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

            string quizIdRaw = Request.QueryString["QuizId"];
            if (!int.TryParse(quizIdRaw, out int quizId))
            {
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            // Confirm quiz is an assessment
            string quizTitle;
            if (!IsAssessmentQuiz(quizId, out quizTitle))
            {
                // not an assessment or not found
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            lblQuizTitle.Text = quizTitle;

            var questions = LoadQuestionsByQuizId(quizId);

            if (questions.Count == 0)
            {
                // no questions, just send them back
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            Session[SESSION_QUESTIONS] = questions;
            Session[SESSION_INDEX] = 0;
            Session[SESSION_QUIZID] = quizId;
            Session[SESSION_ANSWERS] = new Dictionary<int, int>(); // QuestionId -> SelectedOption

            pnlAssessment.Visible = true;
            pnlResult.Visible = false;

            BindCurrentQuestion();
        }

        private bool IsAssessmentQuiz(int quizId, out string title)
        {
            title = "Assessment";

            using (var conn = GetOpenConnection())
            using (var cmd = new SqlCommand(@"
                SELECT QuizTitle, QuizType
                FROM dbo.Quiz
                WHERE QuizId = @QuizId;
            ", conn))
            {
                cmd.Parameters.AddWithValue("@QuizId", quizId);

                using (var rd = cmd.ExecuteReader())
                {
                    if (!rd.Read())
                        return false;

                    string quizTitle = rd.GetString(0);
                    string quizType = rd.GetString(1);

                    title = quizTitle;
                    // Only allow if QuizType = 'assessment'
                    return string.Equals(quizType, "assessment", StringComparison.OrdinalIgnoreCase);
                }
            }
        }

        private List<QuestionDto> LoadQuestionsByQuizId(int quizId)
        {
            var list = new List<QuestionDto>();

            using (var conn = GetOpenConnection())
            using (var cmd = new SqlCommand(@"
                SELECT 
                    qb.QuizId,
                    q.QuestionId,
                    q.Question,
                    q.Option1,
                    q.Option2,
                    q.Option3,
                    q.Option4,
                    q.CorrectAnswer,
                    q.ImageUrl
                FROM dbo.QuestionBank qb
                JOIN dbo.Questions q ON q.QuestionId = qb.QuestionId
                WHERE qb.QuizId = @QuizId
                ORDER BY q.QuestionId ASC; -- deterministic order
            ", conn))
            {
                cmd.Parameters.AddWithValue("@QuizId", quizId);

                using (var rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        list.Add(new QuestionDto
                        {
                            QuizId = rd.GetInt32(0),
                            QuestionId = rd.GetInt32(1),
                            Question = rd.GetString(2),
                            Option1 = rd.GetString(3),
                            Option2 = rd.GetString(4),
                            Option3 = rd.IsDBNull(5) ? null : rd.GetString(5),
                            Option4 = rd.IsDBNull(6) ? null : rd.GetString(6),
                            CorrectAnswer = rd.GetInt32(7),
                            ImageUrl = rd.IsDBNull(8) ? null : rd.GetString(8)
                        });
                    }
                }
            }

            return list;
        }

        // ----------------------------------------------------
        // Binding
        // ----------------------------------------------------
        private void BindCurrentQuestion()
        {
            var questions = Session[SESSION_QUESTIONS] as List<QuestionDto>;
            if (questions == null || questions.Count == 0)
                return;

            int index = Convert.ToInt32(Session[SESSION_INDEX] ?? 0);
            if (index < 0 || index >= questions.Count)
                return;

            var answers = Session[SESSION_ANSWERS] as Dictionary<int, int>;
            if (answers == null)
            {
                answers = new Dictionary<int, int>();
                Session[SESSION_ANSWERS] = answers;
            }

            var q = questions[index];

            // Progress text
            lblProgress.Text = $"Question {index + 1} of {questions.Count}";

            // Question
            lblQuestionText.Text = q.Question;

            // Image
            if (!string.IsNullOrEmpty(q.ImageUrl))
            {
                imgQuestion.ImageUrl = q.ImageUrl;
                imgQuestion.Visible = true;
            }
            else
            {
                imgQuestion.Visible = false;
            }

            // Options
            rblOptions.Items.Clear();

            if (!string.IsNullOrEmpty(q.Option1))
                rblOptions.Items.Add(new ListItem(q.Option1, "1"));

            if (!string.IsNullOrEmpty(q.Option2))
                rblOptions.Items.Add(new ListItem(q.Option2, "2"));

            if (!string.IsNullOrEmpty(q.Option3))
                rblOptions.Items.Add(new ListItem(q.Option3, "3"));

            if (!string.IsNullOrEmpty(q.Option4))
                rblOptions.Items.Add(new ListItem(q.Option4, "4"));

            // Restore selected answer if any
            if (answers.TryGetValue(q.QuestionId, out int storedOption))
            {
                var item = rblOptions.Items.FindByValue(storedOption.ToString());
                if (item != null)
                    item.Selected = true;
            }

            // Update button states
            btnPrevious.Enabled = index > 0;

            if (index == questions.Count - 1)
            {
                // last question
                btnNext.Text = "Submit";
            }
            else
            {
                btnNext.Text = "Next";
            }
        }

        // ----------------------------------------------------
        // Navigation buttons
        // ----------------------------------------------------
        protected void btnPrevious_Click(object sender, EventArgs e)
        {
            SaveCurrentSelection();

            int index = Convert.ToInt32(Session[SESSION_INDEX] ?? 0);
            index = Math.Max(0, index - 1);
            Session[SESSION_INDEX] = index;

            BindCurrentQuestion();
        }

        protected async void btnNext_Click(object sender, EventArgs e)
        {
            SaveCurrentSelection();

            var questions = Session[SESSION_QUESTIONS] as List<QuestionDto>;
            if (questions == null || questions.Count == 0)
                return;

            int index = Convert.ToInt32(Session[SESSION_INDEX] ?? 0);

            if (index == questions.Count - 1)
            {
                // Last question -> submit exam
                await SubmitAssessmentAsync();
            }
            else
            {
                index++;
                Session[SESSION_INDEX] = index;
                BindCurrentQuestion();
            }
        }

        private void SaveCurrentSelection()
        {
            var questions = Session[SESSION_QUESTIONS] as List<QuestionDto>;
            if (questions == null || questions.Count == 0)
                return;

            int index = Convert.ToInt32(Session[SESSION_INDEX] ?? 0);
            if (index < 0 || index >= questions.Count)
                return;

            var q = questions[index];

            var answers = Session[SESSION_ANSWERS] as Dictionary<int, int>;
            if (answers == null)
            {
                answers = new Dictionary<int, int>();
                Session[SESSION_ANSWERS] = answers;
            }

            if (!string.IsNullOrEmpty(rblOptions.SelectedValue) &&
                int.TryParse(rblOptions.SelectedValue, out int selectedOption))
            {
                answers[q.QuestionId] = selectedOption;
            }
            else
            {
                // If nothing selected, remove any stored answer
                if (answers.ContainsKey(q.QuestionId))
                    answers.Remove(q.QuestionId);
            }
        }

        // ----------------------------------------------------
        // Submission
        // ----------------------------------------------------
        private async Task SubmitAssessmentAsync()
        {
            var questions = Session[SESSION_QUESTIONS] as List<QuestionDto>;
            var answers = Session[SESSION_ANSWERS] as Dictionary<int, int>;
            int quizId = Convert.ToInt32(Session[SESSION_QUIZID] ?? 0);

            if (questions == null || questions.Count == 0 || quizId == 0)
                return;

            if (answers == null)
                answers = new Dictionary<int, int>();

            // Evaluate score
            int total = questions.Count;
            int correctCount = 0;

            var resultList = new List<ResultDto>();

            foreach (var q in questions)
            {
                answers.TryGetValue(q.QuestionId, out int userOpt);

                bool isCorrect = (userOpt != 0 && userOpt == q.CorrectAnswer);
                if (isCorrect)
                    correctCount++;

                string userAnswerText = OptionIndexToText(q, userOpt);
                string correctAnswerText = OptionIndexToText(q, q.CorrectAnswer);

                resultList.Add(new ResultDto
                {
                    QuestionText = q.Question,
                    UserAnswerText = string.IsNullOrEmpty(userAnswerText) ? "(No answer)" : userAnswerText,
                    CorrectAnswerText = correctAnswerText,
                    IsCorrect = isCorrect
                });
            }

            // Save into DB as a single attempt (one QuizTry value shared)
            await SaveAssessmentAttemptAsync(quizId, questions, answers);

            // Bind result summary
            lblScore.Text = $"You scored {correctCount} out of {total}.";
            rptResults.DataSource = resultList;
            rptResults.DataBind();

            // Get AI explanation (best-effort, non-fatal)
            string explanation = await GenerateAiExplanationAsync(resultList);
            lblAiExplanation.Text = explanation;

            // Switch panels
            pnlAssessment.Visible = false;
            pnlResult.Visible = true;
        }

        private string OptionIndexToText(QuestionDto q, int index)
        {
            switch (index)
            {
                case 1: return q.Option1;
                case 2: return q.Option2;
                case 3: return q.Option3;
                case 4: return q.Option4;
                default: return null;
            }
        }

        private async Task SaveAssessmentAttemptAsync(
    int quizId,
    List<QuestionDto> questions,
    Dictionary<int, int> answers)
        {
            var (isAuthenticated, userIdStr, _) = AuthCookieHelper.ReadAuthCookie();
            if (!isAuthenticated || string.IsNullOrEmpty(userIdStr))
                return;

            int userId = int.Parse(userIdStr);

            using (var conn = GetOpenConnection())
            using (var tx = conn.BeginTransaction())
            {
                try
                {
                    int attemptNumber;

                    // 1) Find next attempt number
                    using (var cmd = new SqlCommand(@"
                SELECT ISNULL(MAX(AttemptNumber), 0)
                FROM dbo.QuizTry
                WHERE UserId = @UserId AND QuizId = @QuizId;
            ", conn, tx))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        cmd.Parameters.AddWithValue("@QuizId", quizId);

                        int latest = Convert.ToInt32(cmd.ExecuteScalar());
                        attemptNumber = latest + 1;
                    }

                    // 2) Create QuizTry row
                    int quizTryId;
                    using (var cmd = new SqlCommand(@"
                INSERT INTO dbo.QuizTry (AttemptNumber, QuizId, UserId)
                OUTPUT INSERTED.UniqueId
                VALUES (@AttemptNumber, @QuizId, @UserId);
            ", conn, tx))
                    {
                        cmd.Parameters.AddWithValue("@AttemptNumber", attemptNumber);
                        cmd.Parameters.AddWithValue("@QuizId", quizId);
                        cmd.Parameters.AddWithValue("@UserId", userId);

                        quizTryId = (int)cmd.ExecuteScalar();
                    }

                    // 3) Insert UserAnswer rows
                    foreach (var q in questions)
                    {
                        answers.TryGetValue(q.QuestionId, out int selected);
                        if (selected == 0) selected = 0;

                        using (var cmd = new SqlCommand(@"
                    INSERT INTO dbo.UserAnswer (QuizTryId, QuestionId, SelectedOption)
                    VALUES (@QuizTryId, @QuestionId, @SelectedOption);
                ", conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@QuizTryId", quizTryId);
                            cmd.Parameters.AddWithValue("@QuestionId", q.QuestionId);
                            cmd.Parameters.AddWithValue("@SelectedOption", selected);

                            cmd.ExecuteNonQuery();
                        }
                    }

                    // 4) Insert Score row
                    int total = questions.Count;
                    int correct = questions.FindAll(q =>
                    {
                        answers.TryGetValue(q.QuestionId, out int sel);
                        return sel == q.CorrectAnswer;
                    }).Count;

                    int scorePercent =
                        total == 0 ? 0 : (int)Math.Round(correct * 100.0 / total);

                    using (var cmd = new SqlCommand(@"
                INSERT INTO dbo.Score (QuizTryId, UserId, ScorePercent)
                VALUES (@QuizTryId, @UserId, @ScorePercent);
            ", conn, tx))
                    {
                        cmd.Parameters.AddWithValue("@QuizTryId", quizTryId);
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        cmd.Parameters.AddWithValue("@ScorePercent", scorePercent);

                        cmd.ExecuteNonQuery();
                    }

                    tx.Commit();
                }
                catch
                {
                    tx.Rollback();
                }
            }

            await Task.CompletedTask;
        }


        // ----------------------------------------------------
        // AI Explanation
        // ----------------------------------------------------
        private async Task<string> GenerateAiExplanationAsync(List<ResultDto> results)
        {
            try
            {
                // Build prompt summarizing performance
                var sb = new System.Text.StringBuilder();
                sb.AppendLine("You are an exam review assistant. Given the user's answers, explain their mistakes and how to improve, in concise bullet points.");
                sb.AppendLine();
                sb.AppendLine("Questions and answers:");

                int idx = 1;
                foreach (var r in results)
                {
                    sb.AppendLine($"Q{idx}: {r.QuestionText}");
                    sb.AppendLine($"User answer: {r.UserAnswerText}");
                    sb.AppendLine($"Correct answer: {r.CorrectAnswerText}");
                    sb.AppendLine($"Is correct: {r.IsCorrect}");
                    sb.AppendLine();
                    idx++;
                }

                string prompt = sb.ToString();
                string systemConfig = "You summarize exam performance in clear, student-friendly language with short bullet points. Focus on key misconceptions and suggestions.";

                string text = await GeminiHelper.Gemini(prompt, systemConfig);
                return string.IsNullOrWhiteSpace(text)
                    ? "Explanation could not be generated."
                    : text;
            }
            catch (Exception ex)
            {
                return $"Explanation could not be generated. ({ex.Message})";
            }
        }

        // ----------------------------------------------------
        // Top buttons on result page
        // ----------------------------------------------------
        protected void btnRetake_Click(object sender, EventArgs e)
        {
            // Retake = reload same page with same QuizId
            string quizIdRaw = Request.QueryString["QuizId"];
            if (string.IsNullOrEmpty(quizIdRaw))
            {
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            Response.Redirect($"~/Quiz/Assessment.aspx?QuizId={quizIdRaw}", true);
        }

        protected void btnBackToDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Base/CourseDashboard.aspx", true);
        }
    }
}
