using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Web.UI;
using System.Web.UI.WebControls;
using static WAPP_Assignment.DataAccess;

namespace WAPP_Assignment.Quiz
{
    public partial class Exercise : System.Web.UI.Page
    {
        private const string SESSION_QUESTIONS = "Exercise_Questions";
        private const string SESSION_INDEX = "Exercise_CurrentIndex";
        private const string SESSION_ANSWERS = "Exercise_Answers";
        private const string SESSION_QUIZID = "Exercise_QuizId";

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
                InitializeExercise();
            }
        }

        // ---------------------------------------------------------
        // Initialization
        // ---------------------------------------------------------
        private void InitializeExercise()
        {
            var (isAuthenticated, userIdStr, userType) = AuthCookieHelper.ReadAuthCookie();
            bool loggedIn = isAuthenticated && !string.IsNullOrEmpty(userIdStr);
            int userId = 0;
            if (loggedIn)
                int.TryParse(userIdStr, out userId);

            string quizIdRaw = Request.QueryString["QuizId"];
            string courseIdRaw = Request.QueryString["CourseId"];

            // CASE 1: QuizId specified
            if (!string.IsNullOrEmpty(quizIdRaw) && int.TryParse(quizIdRaw, out int quizId))
            {
                // QuizId mode requires login
                if (!loggedIn)
                {
                    Response.Redirect("~/Base/Landing.aspx", true);
                    return;
                }

                var questions = LoadQuestionsByQuizId(quizId);

                if (questions.Count == 0)
                {
                    ShowNoQuizPanel();
                    return;
                }

                Session[SESSION_QUESTIONS] = questions;
                Session[SESSION_INDEX] = 0;
                Session[SESSION_ANSWERS] = new Dictionary<int, int>();
                Session[SESSION_QUIZID] = quizId;

                pnlQuiz.Visible = true;
                pnlResult.Visible = false;
                pnlNoQuiz.Visible = false;

                BindCurrentQuestion();
                return;
            }

            // CASE 2: CourseId specified
            if (!string.IsNullOrEmpty(courseIdRaw) && int.TryParse(courseIdRaw, out int courseId))
            {
                var allQuestions = LoadAllQuestionsForCourse(courseId);

                if (allQuestions.Count == 0)
                {
                    ShowNoQuizPanel();
                    return;
                }

                bool enrolled = false;
                if (loggedIn && userId != 0)
                    enrolled = IsUserEnrolled(userId, courseId);

                List<QuestionDto> questions;

                if (enrolled)
                {
                    // Enrolled: full question set, deterministic order
                    questions = allQuestions
                        .OrderBy(q => q.QuestionId)
                        .ToList();
                }
                else
                {
                    // Try-out mode: random subset up to 10
                    var rnd = new Random();
                    questions = allQuestions
                        .OrderBy(q => rnd.Next())
                        .ToList();

                    if (questions.Count > 10)
                        questions = questions.Take(10).ToList();
                }

                Session[SESSION_QUESTIONS] = questions;
                Session[SESSION_INDEX] = 0;
                Session[SESSION_ANSWERS] = new Dictionary<int, int>();
                Session[SESSION_QUIZID] = 0; // not tied to a single quiz

                pnlQuiz.Visible = true;
                pnlResult.Visible = false;
                pnlNoQuiz.Visible = false;

                BindCurrentQuestion();
                return;
            }

            // No valid parameters
            Response.Redirect("~/Base/Landing.aspx", true);
        }

        private void ShowNoQuizPanel()
        {
            pnlNoQuiz.Visible = true;
            pnlQuiz.Visible = false;
            pnlResult.Visible = false;
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
                ORDER BY q.QuestionId ASC;
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

        private List<QuestionDto> LoadAllQuestionsForCourse(int courseId)
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
                FROM dbo.Chapters ch
                JOIN dbo.ChapterContents cc
                    ON cc.ChapterId = ch.ChapterId
                JOIN dbo.QuestionBank qb
                    ON qb.QuizId = cc.LinkId
                JOIN dbo.Questions q
                    ON q.QuestionId = qb.QuestionId
                WHERE ch.CourseId = @CourseId
                  AND cc.ContentType = 'Quiz';
            ", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId", courseId);

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

        // ---------------------------------------------------------
        // Binding current question
        // ---------------------------------------------------------
        private void BindCurrentQuestion()
        {
            var questions = Session[SESSION_QUESTIONS] as List<QuestionDto>;
            if (questions == null || questions.Count == 0)
                return;

            int index = Convert.ToInt32(Session[SESSION_INDEX] ?? 0);
            if (index < 0 || index >= questions.Count)
                return;

            var q = questions[index];

            lblProgress.Text = $"Question {index + 1} of {questions.Count}";
            lblQuestionText.Text = q.Question;

            if (!string.IsNullOrEmpty(q.ImageUrl))
            {
                imgQuestion.ImageUrl = q.ImageUrl;
                imgQuestion.Visible = true;
            }
            else
            {
                imgQuestion.Visible = false;
            }

            // Setup options
            SetupOptionButton(btnOption1, q.Option1, 1);
            SetupOptionButton(btnOption2, q.Option2, 2);
            SetupOptionButton(btnOption3, q.Option3, 3);
            SetupOptionButton(btnOption4, q.Option4, 4);

            // Reset styles and feedback for new question
            ResetOptionStyles();
            SetOptionButtonsEnabled(true);
            lblFeedback.Text = string.Empty;
            btnNext.Visible = false;
        }

        private void SetupOptionButton(Button btn, string text, int optionNumber)
        {
            btn.CommandArgument = optionNumber.ToString();

            if (string.IsNullOrEmpty(text))
            {
                btn.Visible = false;
            }
            else
            {
                btn.Visible = true;
                btn.Text = text;
            }
        }


        private void ResetOptionStyles()
        {
            btnOption1.CssClass = "flashcard-option";
            btnOption2.CssClass = "flashcard-option";
            btnOption3.CssClass = "flashcard-option";
            btnOption4.CssClass = "flashcard-option";
        }

        private void SetOptionButtonsEnabled(bool enabled)
        {
            if (btnOption1.Visible) btnOption1.Enabled = enabled;
            if (btnOption2.Visible) btnOption2.Enabled = enabled;
            if (btnOption3.Visible) btnOption3.Enabled = enabled;
            if (btnOption4.Visible) btnOption4.Enabled = enabled;
        }

        // ---------------------------------------------------------
        // Option click: show correctness immediately
        // ---------------------------------------------------------
        protected void Option_Click(object sender, EventArgs e)
        {
            var questions = Session[SESSION_QUESTIONS] as List<QuestionDto>;
            if (questions == null || questions.Count == 0)
                return;

            int index = Convert.ToInt32(Session[SESSION_INDEX] ?? 0);
            if (index < 0 || index >= questions.Count)
                return;

            if (!(sender is Button btn))
                return;

            if (!int.TryParse(btn.CommandArgument, out int selectedOption))
                return;

            var q = questions[index];

            // Store selected answer in session for summary
            var answers = Session[SESSION_ANSWERS] as Dictionary<int, int>;
            if (answers == null)
            {
                answers = new Dictionary<int, int>();
                Session[SESSION_ANSWERS] = answers;
            }
            answers[q.QuestionId] = selectedOption;

            bool isCorrect = (selectedOption == q.CorrectAnswer);

            ApplyOptionFeedback(q, selectedOption);

            lblFeedback.Text = isCorrect
                ? "Correct!"
                : $"Incorrect. The correct answer is option {q.CorrectAnswer}.";

            // Lock options and show Next
            SetOptionButtonsEnabled(false);
            btnNext.Visible = true;
        }

        private void ApplyOptionFeedback(QuestionDto q, int selectedOption)
        {
            ResetOptionStyles();

            // Map from index to button
            var map = new Dictionary<int, Button>
            {
                { 1, btnOption1 },
                { 2, btnOption2 },
                { 3, btnOption3 },
                { 4, btnOption4 }
            };

            foreach (var kv in map)
            {
                int idx = kv.Key;
                Button b = kv.Value;

                if (!b.Visible)
                    continue;

                bool isCorrectOption = (idx == q.CorrectAnswer);
                bool isSelected = (idx == selectedOption);

                string css = "flashcard-option";

                if (isCorrectOption)
                    css += " flashcard-correct";

                if (isSelected && !isCorrectOption)
                    css += " flashcard-incorrect";

                b.CssClass = css;
            }
        }

        // ---------------------------------------------------------
        // Next button
        // ---------------------------------------------------------
        protected async void btnNext_Click(object sender, EventArgs e)
        {
            var questions = Session[SESSION_QUESTIONS] as List<QuestionDto>;
            if (questions == null || questions.Count == 0)
                return;

            int index = Convert.ToInt32(Session[SESSION_INDEX] ?? 0);
            index++;

            if (index >= questions.Count)
            {
                // Switch to loading screen
                pnlQuiz.Visible = false;
                pnlLoading.Visible = true;
                pnlResult.Visible = false;

                // Delay to show animation on client
                await Task.Delay(1300);

                await FinishExerciseAsync();
                return;
            }

            else
            {
                Session[SESSION_INDEX] = index;
                BindCurrentQuestion();
            }
        }

        // ---------------------------------------------------------
        // Finish exercise: compute score + AI explanation
        // ---------------------------------------------------------
        private async Task FinishExerciseAsync()
        {
            // Show loading UI first
            pnlLoading.Visible = true;
            pnlQuiz.Visible = false;
            pnlResult.Visible = false;

            var questions = Session[SESSION_QUESTIONS] as List<QuestionDto>;
            var answers = Session[SESSION_ANSWERS] as Dictionary<int, int> ?? new Dictionary<int, int>();

            if (questions == null || questions.Count == 0)
                return;

            int total = questions.Count;
            int correctCount = 0;
            var resultList = new List<ResultDto>();

            foreach (var q in questions)
            {
                answers.TryGetValue(q.QuestionId, out int selected);

                bool isCorrect = (selected != 0 && selected == q.CorrectAnswer);
                if (isCorrect) correctCount++;

                string userAnswerText = OptionIndexToText(q, selected);
                if (string.IsNullOrEmpty(userAnswerText))
                    userAnswerText = "(No answer)";

                resultList.Add(new ResultDto
                {
                    QuestionText = q.Question,
                    UserAnswerText = userAnswerText,
                    CorrectAnswerText = OptionIndexToText(q, q.CorrectAnswer),
                    IsCorrect = isCorrect
                });
            }

            // Bind UI
            lblScore.Text = $"You scored {correctCount} out of {total}.";
            rptResults.DataSource = resultList;
            rptResults.DataBind();

            string explanation = await GenerateAiExplanationAsync(resultList);
            lblAiExplanation.Text = explanation;

            // -----------------------------
            //     SAVE ATTEMPT TO DB
            // -----------------------------
            try
            {
                var (isAuthenticated, userIdStr, _) = AuthCookieHelper.ReadAuthCookie();
                if (!isAuthenticated || string.IsNullOrEmpty(userIdStr))
                    return;

                int userId = int.Parse(userIdStr);
                int quizId = Convert.ToInt32(Session[SESSION_QUIZID] ?? 0);

                // Determine quiz type
                string quizType = quizId > 0 ? FetchQuizType(quizId) : "exercise";

                // XP rules
                int xpAwarded = (quizType == "exercise")
                    ? 10
                    : (int)Math.Round((correctCount * 100.0 / total) / 2.0);

                using (var conn = GetOpenConnection())
                using (var tx = conn.BeginTransaction())
                {
                    int attemptNumber;

                    // -------------------------
                    // 1) Determine attemptNumber
                    // -------------------------
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

                    // -------------------------
                    // 2) Insert QuizTry (1 row)
                    // -------------------------
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

                    // -------------------------
                    // 3) Insert UserAnswer rows
                    // -------------------------
                    foreach (var q in questions)
                    {
                        answers.TryGetValue(q.QuestionId, out int selectedOption);
                        if (selectedOption == 0) selectedOption = 0; // no answer

                        using (var cmd = new SqlCommand(@"
                INSERT INTO dbo.UserAnswer (QuizTryId, QuestionId, SelectedOption)
                VALUES (@QuizTryId, @QuestionId, @SelectedOption);
            ", conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@QuizTryId", quizTryId);
                            cmd.Parameters.AddWithValue("@QuestionId", q.QuestionId);
                            cmd.Parameters.AddWithValue("@SelectedOption", selectedOption);
                            cmd.ExecuteNonQuery();
                        }
                    }

                    // -------------------------
                    // 4) Insert Score
                    // -------------------------
                    using (var cmd = new SqlCommand(@"
            INSERT INTO dbo.Score (QuizTryId, UserId, ScorePercent)
            VALUES (@QuizTryId, @UserId, @ScorePercent);
        ", conn, tx))
                    {
                        cmd.Parameters.AddWithValue("@QuizTryId", quizTryId);
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        cmd.Parameters.AddWithValue("@ScorePercent",
                            (int)Math.Round(correctCount * 100.0 / total));

                        cmd.ExecuteNonQuery();
                    }

                    tx.Commit();

                    // -------------------------
                    // 5) Apply XP
                    // -------------------------
                    XPHelper.IncreaseXP(userId, xpAwarded);
                }
            }
            catch (Exception ex)
            {
                dbgLabel.Text = "SAVE ERROR: " + ex.Message;
            }

            pnlLoading.Visible = false;
            pnlResult.Visible = true;
            Log("UI Shown");
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

        private async Task<string> GenerateAiExplanationAsync(List<ResultDto> results)
        {
            try
            {
                var sb = new System.Text.StringBuilder();
                sb.AppendLine("You are a tutoring assistant. The student just finished a practice exercise. Explain their performance, common mistakes, and how to improve, in short bullet points.");
                sb.AppendLine();
                sb.AppendLine("Questions and answers:");

                int i = 1;
                foreach (var r in results)
                {
                    sb.AppendLine($"Q{i}: {r.QuestionText}");
                    sb.AppendLine($"User answer: {r.UserAnswerText}");
                    sb.AppendLine($"Correct answer: {r.CorrectAnswerText}");
                    sb.AppendLine($"Is correct: {r.IsCorrect}");
                    sb.AppendLine();
                    i++;
                }

                string prompt = sb.ToString();
                string systemConfig = "You summarize practice quiz results in concise, student-friendly bullet points. Focus on key patterns, misconceptions, and concrete improvement tips.";

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

        // ---------------------------------------------------------
        // Buttons on result / no-quiz panels
        // ---------------------------------------------------------
        protected void btnTryAgain_Click(object sender, EventArgs e)
        {
            // Reload same URL to restart
            Response.Redirect(Request.RawUrl, true);
        }

        protected void btnBackToCourses_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Base/CourseDashboard.aspx", true);
        }

        protected void btnNoQuizBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Base/CourseDashboard.aspx", true);
        }

        // ---------------------------------------------------------
        // Helper: enrollment check
        // ---------------------------------------------------------
        private bool IsUserEnrolled(int userId, int courseId)
        {
            using (var conn = GetOpenConnection())
            using (var cmd = new SqlCommand(@"
                SELECT 1
                FROM dbo.Enrollments
                WHERE UserId = @UserId AND CourseId = @CourseId;
            ", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@CourseId", courseId);

                object result = cmd.ExecuteScalar();
                return result != null;
            }
        }

        private string FetchQuizType(int quizId)
        {
            using (var conn = GetOpenConnection())
            using (var cmd = new SqlCommand(@"
                SELECT QuizType FROM dbo.Quiz WHERE QuizId = @QuizId;
            ", conn))
            {
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                object result = cmd.ExecuteScalar();
                return result?.ToString() ?? "exercise";
            }
        }

        private void Log(string msg)
        {
            dbgLabel.Text += msg + "<br/>";
        }

    }
}
