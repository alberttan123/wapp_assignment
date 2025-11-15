using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace WAPP_Assignment.Lecturer
{
    public partial class LecturerDashboard : System.Web.UI.Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        private int CurrentLecturerId
        {
            get
            {
                // Prefer session if you already set it on login
                if (Session["UserId"] != null &&
                    int.TryParse(Session["UserId"].ToString(), out int uidFromSession))
                {
                    return uidFromSession;
                }

                // Fallback to auth cookie
                var (success, userIdStr, userType) = AuthCookieHelper.ReadAuthCookie();
                if (success &&
                    !string.IsNullOrEmpty(userIdStr) &&
                    string.Equals(userType, "Educator", StringComparison.OrdinalIgnoreCase) &&
                    int.TryParse(userIdStr, out int uidFromCookie))
                {
                    return uidFromCookie;
                }

                // As a safety fallback (your seeded educator account)
                return 2;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                litDashboardSubtitle.Text =
                    "Overview of your courses, assessments, and student engagement.";

                BindProfileHeader();
                BindStatsAndEngagement();
                BindRecentCourses();
                BindRecentAssessments();
            }
        }

        private void BindProfileHeader()
        {
            string displayName = "Lecturer";
            string email = string.Empty;
            string role = "Educator";

            var (success, userIdStr, userType) = AuthCookieHelper.ReadAuthCookie();
            if (success && !string.IsNullOrEmpty(userIdStr) && int.TryParse(userIdStr, out int userId))
            {
                using (var con = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand(@"
                    SELECT 
                        COALESCE(NULLIF(FullName, ''), Username) AS DisplayName,
                        Email,
                        UserType
                    FROM dbo.Users
                    WHERE UserId = @uid;", con))
                {
                    cmd.Parameters.AddWithValue("@uid", userId);
                    con.Open();
                    using (var rd = cmd.ExecuteReader())
                    {
                        if (rd.Read())
                        {
                            displayName = rd["DisplayName"].ToString();
                            email = rd["Email"].ToString();
                            role = rd["UserType"].ToString();
                        }
                    }
                }
            }

            litProfileName.Text = displayName;
            litProfileEmail.Text = email;
            litProfileRole.Text = role;
        }

        // --------------------------------------------------------------------
        // Stats + engagement
        // --------------------------------------------------------------------

        private void BindStatsAndEngagement()
        {
            int lecturerId = CurrentLecturerId;

            int courses = 0;
            int assessments = 0;
            int exercises = 0;
            int questions = 0;

            int students = 0;
            int enrollments = 0;
            decimal avgProgress = 0m;

            string topCourseTitle = "No courses yet";
            int topCourseEnrollments = 0;

            bool hasCreatedBy = QuizHasCreatedBy();

            using (var con = new SqlConnection(ConnStr))
            {
                con.Open();

                // Courses owned by this lecturer
                using (var cmd = new SqlCommand(
                    "SELECT COUNT(*) FROM dbo.Courses WHERE LecturerId = @uid;", con))
                {
                    cmd.Parameters.AddWithValue("@uid", lecturerId);
                    courses = (int)cmd.ExecuteScalar();
                }

                // Assessments
                string assessSql = "SELECT COUNT(*) FROM dbo.Quiz WHERE QuizType = 'assessment'";
                if (hasCreatedBy)
                    assessSql += " AND CreatedBy = @uid;";

                using (var cmd = new SqlCommand(assessSql, con))
                {
                    if (hasCreatedBy)
                        cmd.Parameters.AddWithValue("@uid", lecturerId);
                    assessments = (int)cmd.ExecuteScalar();
                }

                // Exercises
                string exSql = "SELECT COUNT(*) FROM dbo.Quiz WHERE QuizType = 'exercise'";
                if (hasCreatedBy)
                    exSql += " AND CreatedBy = @uid;";

                using (var cmd = new SqlCommand(exSql, con))
                {
                    if (hasCreatedBy)
                        cmd.Parameters.AddWithValue("@uid", lecturerId);
                    exercises = (int)cmd.ExecuteScalar();
                }

                // Questions linked to this lecturer's quizzes (distinct QuestionId)
                string qSql = @"
SELECT COUNT(DISTINCT qb.QuestionId)
FROM dbo.QuestionBank qb
JOIN dbo.Quiz q ON q.QuizId = qb.QuizId
WHERE q.QuizType IN ('exercise','assessment')";
                if (hasCreatedBy)
                    qSql += " AND q.CreatedBy = @uid;";

                using (var cmd = new SqlCommand(qSql, con))
                {
                    if (hasCreatedBy)
                        cmd.Parameters.AddWithValue("@uid", lecturerId);
                    questions = (int)cmd.ExecuteScalar();
                }

                // Unique students across this lecturer's courses
                using (var cmd = new SqlCommand(@"
SELECT COUNT(DISTINCT e.UserId)
FROM dbo.Enrollments e
JOIN dbo.Courses c ON c.CourseId = e.CourseId
WHERE c.LecturerId = @uid;", con))
                {
                    cmd.Parameters.AddWithValue("@uid", lecturerId);
                    students = (int)cmd.ExecuteScalar();
                }

                // Total enrollments across this lecturer's courses
                using (var cmd = new SqlCommand(@"
SELECT COUNT(*)
FROM dbo.Enrollments e
JOIN dbo.Courses c ON c.CourseId = e.CourseId
WHERE c.LecturerId = @uid;", con))
                {
                    cmd.Parameters.AddWithValue("@uid", lecturerId);
                    enrollments = (int)cmd.ExecuteScalar();
                }

                // Average progress across enrollments on this lecturer's courses
                using (var cmd = new SqlCommand(@"
SELECT AVG(e.ProgressPercent)
FROM dbo.Enrollments e
JOIN dbo.Courses c ON c.CourseId = e.CourseId
WHERE c.LecturerId = @uid;", con))
                {
                    cmd.Parameters.AddWithValue("@uid", lecturerId);
                    object o = cmd.ExecuteScalar();
                    if (o != null && o != DBNull.Value)
                    {
                        avgProgress = Convert.ToDecimal(o);
                    }
                }

                // Top course by enrollments for this lecturer
                using (var cmd = new SqlCommand(@"
SELECT TOP 1
    c.CourseTitle,
    COUNT(e.EnrollmentId) AS Enrollments
FROM dbo.Courses c
LEFT JOIN dbo.Enrollments e ON e.CourseId = c.CourseId
WHERE c.LecturerId = @uid
GROUP BY c.CourseTitle
ORDER BY Enrollments DESC, c.CourseTitle;", con))
                {
                    cmd.Parameters.AddWithValue("@uid", lecturerId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            topCourseTitle = reader.GetString(0);
                            topCourseEnrollments = reader.IsDBNull(1) ? 0 : reader.GetInt32(1);
                        }
                    }
                }
            }

            // Primary stats
            litCoursesCount.Text = courses.ToString();
            litAssessmentsCount.Text = assessments.ToString();
            litExercisesCount.Text = exercises.ToString();
            litQuestionsCount.Text = questions.ToString();

            // Engagement row
            litStudentsCount.Text = students.ToString();
            litEnrollmentsCount.Text = enrollments.ToString();
            litAvgProgress.Text = avgProgress > 0
                ? avgProgress.ToString("0.#") + "%"
                : "0%";

            litTopCourseTitle.Text = topCourseTitle;
            litTopCourseEnrollments.Text = topCourseEnrollments.ToString();
        }

        private bool QuizHasCreatedBy()
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(
                "SELECT CASE WHEN COL_LENGTH('dbo.Quiz','CreatedBy') IS NULL THEN 0 ELSE 1 END;", con))
            {
                con.Open();
                int v = (int)cmd.ExecuteScalar();
                return v == 1;
            }
        }

        // --------------------------------------------------------------------
        // Recent Courses
        // --------------------------------------------------------------------

        private void BindRecentCourses()
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT TOP 5
    c.CourseId,
    c.CourseTitle,
    c.TotalLessons,
    c.CourseCreatedAt
FROM dbo.Courses c
WHERE c.LecturerId = @uid
ORDER BY c.CourseCreatedAt DESC;", con))
            using (var da = new SqlDataAdapter(cmd))
            {
                cmd.Parameters.AddWithValue("@uid", CurrentLecturerId);
                var dt = new DataTable();
                da.Fill(dt);

                lblCoursesEmpty.Visible = dt.Rows.Count == 0;
                if (lblCoursesEmpty.Visible)
                    lblCoursesEmpty.Text = "No courses yet.";

                rptRecentCourses.DataSource = dt;
                rptRecentCourses.DataBind();
            }
        }

        // --------------------------------------------------------------------
        // Recent Assessments
        // --------------------------------------------------------------------

        private void BindRecentAssessments()
        {
            int lecturerId = CurrentLecturerId;
            bool hasCreatedBy = QuizHasCreatedBy();

            string sql = @"
SELECT TOP 5
    q.QuizId,
    q.QuizTitle,
    (SELECT COUNT(*) FROM dbo.QuestionBank qb WHERE qb.QuizId = q.QuizId) AS QuestionCount
FROM dbo.Quiz q
WHERE q.QuizType = 'assessment'";
            if (hasCreatedBy)
                sql += " AND q.CreatedBy = @uid";
            sql += @"
ORDER BY q.QuizId DESC;";

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, con))
            using (var da = new SqlDataAdapter(cmd))
            {
                if (hasCreatedBy)
                    cmd.Parameters.AddWithValue("@uid", lecturerId);

                var dt = new DataTable();
                da.Fill(dt);

                lblAssessmentsEmpty.Visible = dt.Rows.Count == 0;
                if (lblAssessmentsEmpty.Visible)
                    lblAssessmentsEmpty.Text = "No assessments yet.";

                rptRecentAssessments.DataSource = dt;
                rptRecentAssessments.DataBind();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            AuthCookieHelper.RemoveAuthCookie();
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Base/Landing.aspx", true);
        }
    }
}
