using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

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
                if (Session["UserId"] != null &&
                    int.TryParse(Session["UserId"].ToString(), out int uid))
                {
                    return uid;
                }
                // Fallback to the seeded educator (geo_teacher, UserId = 2)
                return 2;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindLecturerProfile();
                BindStatsAndEngagement();
                BindRecentCourses();
                BindRecentAssessments();
            }
        }

        /* ---------- Profile + header ---------- */

        private void BindLecturerProfile()
        {
            string displayName = "Lecturer";
            string email = string.Empty;
            string role = "Educator";

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT Username, FullName, Email, UserType
FROM dbo.Users
WHERE UserId = @uid;", con))
            {
                cmd.Parameters.AddWithValue("@uid", CurrentLecturerId);
                con.Open();

                using (var rd = cmd.ExecuteReader())
                {
                    if (rd.Read())
                    {
                        string username = rd["Username"].ToString();
                        string fullName = rd["FullName"] as string;

                        displayName = string.IsNullOrWhiteSpace(fullName)
                            ? username
                            : fullName;

                        email = rd["Email"].ToString();
                        role = rd["UserType"].ToString();
                    }
                }
            }

            litProfileName.Text = displayName;
            litProfileEmail.Text = email;
            litProfileRole.Text = role;
            litDashboardSubtitle.Text = $"Welcome back, {displayName}.";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Use the same logout flow as the rest of the site
            AuthCookieHelper.RemoveAuthCookie();
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Base/Landing.aspx", true);
        }

        /* ---------- Stats + engagement ---------- */

        private void BindStatsAndEngagement()
        {
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
                    cmd.Parameters.AddWithValue("@uid", CurrentLecturerId);
                    courses = (int)cmd.ExecuteScalar();
                }

                // Assessments
                string assessSql = "SELECT COUNT(*) FROM dbo.Quiz WHERE QuizType = 'assessment'";
                if (hasCreatedBy)
                    assessSql += " AND CreatedBy = @uid;";

                using (var cmd = new SqlCommand(assessSql, con))
                {
                    if (hasCreatedBy)
                        cmd.Parameters.AddWithValue("@uid", CurrentLecturerId);
                    assessments = (int)cmd.ExecuteScalar();
                }

                // Exercises
                string exSql = "SELECT COUNT(*) FROM dbo.Quiz WHERE QuizType = 'exercise'";
                if (hasCreatedBy)
                    exSql += " AND CreatedBy = @uid;";

                using (var cmd = new SqlCommand(exSql, con))
                {
                    if (hasCreatedBy)
                        cmd.Parameters.AddWithValue("@uid", CurrentLecturerId);
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
                        cmd.Parameters.AddWithValue("@uid", CurrentLecturerId);
                    questions = (int)cmd.ExecuteScalar();
                }

                // Unique students across this lecturer's courses
                using (var cmd = new SqlCommand(@"
SELECT COUNT(DISTINCT e.UserId)
FROM dbo.Enrollments e
JOIN dbo.Courses c ON c.CourseId = e.CourseId
WHERE c.LecturerId = @uid;", con))
                {
                    cmd.Parameters.AddWithValue("@uid", CurrentLecturerId);
                    students = (int)cmd.ExecuteScalar();
                }

                // Total enrollments for this lecturer's courses
                using (var cmd = new SqlCommand(@"
SELECT COUNT(*)
FROM dbo.Enrollments e
JOIN dbo.Courses c ON c.CourseId = e.CourseId
WHERE c.LecturerId = @uid;", con))
                {
                    cmd.Parameters.AddWithValue("@uid", CurrentLecturerId);
                    enrollments = (int)cmd.ExecuteScalar();
                }

                // Average progress across enrollments
                using (var cmd = new SqlCommand(@"
SELECT AVG(CAST(e.ProgressPercent AS DECIMAL(10,2)))
FROM dbo.Enrollments e
JOIN dbo.Courses c ON c.CourseId = e.CourseId
WHERE c.LecturerId = @uid;", con))
                {
                    cmd.Parameters.AddWithValue("@uid", CurrentLecturerId);
                    object res = cmd.ExecuteScalar();
                    if (res != DBNull.Value && res != null)
                    {
                        avgProgress = (decimal)res;
                    }
                }

                // Top course by enrollments
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
                    cmd.Parameters.AddWithValue("@uid", CurrentLecturerId);
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

            // Primary stats (legend values)
            litCoursesCount.Text = courses.ToString();
            litAssessmentsCount.Text = assessments.ToString();
            litExercisesCount.Text = exercises.ToString();
            litQuestionsCount.Text = questions.ToString();

            // Content pie (breakdown by type)
            int totalContent = courses + assessments + exercises + questions;
            if (totalContent <= 0)
            {
                litContentPercent.Text = "--";
                litContentPieCaption.Text = "No content yet";
                divContentPie.Style["background"] =
                    "conic-gradient(from -90deg, rgba(27, 37, 58, 0.6) 0 100%)";
            }
            else
            {
                double pCourses = (double)courses * 100.0 / totalContent;
                double pAssess = (double)assessments * 100.0 / totalContent;
                double pEx = (double)exercises * 100.0 / totalContent;
                double pQ = (double)questions * 100.0 / totalContent;

                // cumulative stops, clipped to [0,100]
                double cEnd = Math.Round(pCourses, 2);
                if (cEnd < 0) cEnd = 0;
                if (cEnd > 100) cEnd = 100;

                double aEnd = cEnd + Math.Round(pAssess, 2);
                if (aEnd < 0) aEnd = 0;
                if (aEnd > 100) aEnd = 100;

                double eEnd = aEnd + Math.Round(pEx, 2);
                if (eEnd < 0) eEnd = 0;
                if (eEnd > 100) eEnd = 100;

                // Last segment runs to 100%
                string pieBg =
                    $"conic-gradient(from -90deg," +
                    $" var(--ld-pie-courses) 0 {cEnd:0.##}%," +
                    $" var(--ld-pie-assessments) {cEnd:0.##}% {aEnd:0.##}%," +
                    $" var(--ld-pie-exercises) {aEnd:0.##}% {eEnd:0.##}%," +
                    $" var(--ld-pie-questions) {eEnd:0.##}% 100%)";

                divContentPie.Style["background"] = pieBg;

                litContentPercent.Text = totalContent.ToString();
                litContentPieCaption.Text = "Content items by type";
            }

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

        /* ---------- Recent Courses ---------- */

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

        /* ---------- Recent Assessments ---------- */

        private void BindRecentAssessments()
        {
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
                    cmd.Parameters.AddWithValue("@uid", CurrentLecturerId);

                var dt = new DataTable();
                da.Fill(dt);

                lblAssessmentsEmpty.Visible = dt.Rows.Count == 0;
                if (lblAssessmentsEmpty.Visible)
                    lblAssessmentsEmpty.Text = "No assessments yet.";

                rptRecentAssessments.DataSource = dt;
                rptRecentAssessments.DataBind();
            }
        }
    }
}
