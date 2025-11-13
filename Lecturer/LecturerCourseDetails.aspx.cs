using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WAPP_Assignment.Lecturer
{
    public partial class LecturerCourseDetails : System.Web.UI.Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!int.TryParse(Request.QueryString["courseId"], out int courseId))
                {
                    ShowInfo("Invalid course id.");
                    return;
                }
                BindCourse(courseId);
            }
        }

        private int GetCurrentEducatorId()
        {
            if (Session["UserId"] is int uid) return uid;
            return 2; // fallback to geo_teacher from seed data
        }

        private void ShowInfo(string msg)
        {
            lblInfo.Text = msg;
            lblInfo.Visible = true;
        }

        private void BindCourse(int courseId)
        {
            // 1) Load and verify ownership
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT CourseId, CourseTitle, CourseDescription, TotalLessons, CourseCreatedAt
FROM dbo.Courses
WHERE CourseId = @id AND LecturerId = @uid;", con))
            {
                cmd.Parameters.AddWithValue("@id", courseId);
                cmd.Parameters.AddWithValue("@uid", GetCurrentEducatorId());
                con.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (!r.Read())
                    {
                        ShowInfo("Course not found or you do not have permission to view it.");
                        return;
                    }

                    litCourseTitle.Text = r["CourseTitle"].ToString();
                    litCourseDesc.Text = (r["CourseDescription"] == DBNull.Value) ? "(No description provided.)" : r["CourseDescription"].ToString();

                    var createdAt = (DateTime)r["CourseCreatedAt"];
                    var totalLessons = Convert.ToInt32(r["TotalLessons"]);
                    litCourseMeta.Text = $"Created on {createdAt:yyyy-MM-dd} • Total Lessons: {totalLessons}";
                }
            }

            // 2) Load chapters
            DataTable chapters;
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT ChapterId, ChapterOrder, ChapterTitle
FROM dbo.Chapters
WHERE CourseId = @id
ORDER BY ChapterOrder ASC, ChapterId ASC;", con))
            using (var da = new SqlDataAdapter(cmd))
            {
                cmd.Parameters.AddWithValue("@id", courseId);
                chapters = new DataTable();
                da.Fill(chapters);
            }

            if (chapters.Rows.Count == 0)
            {
                ShowInfo("This course has no chapters yet.");
            }

            rptChapters.DataSource = chapters;
            rptChapters.DataBind();
        }

        protected void RptChapters_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;

            var drv = (DataRowView)e.Item.DataItem;
            int chapterId = (int)drv["ChapterId"];

            // Load chapter contents for this chapter
            DataTable contents;
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT ContentId, ContentType, ContentTitle, LinkId
FROM dbo.ChapterContents
WHERE ChapterId = @ch
ORDER BY ContentId ASC;", con))
            using (var da = new SqlDataAdapter(cmd))
            {
                cmd.Parameters.AddWithValue("@ch", chapterId);
                contents = new DataTable();
                da.Fill(contents);
            }

            var rpt = (Repeater)e.Item.FindControl("rptContents");
            rpt.DataSource = contents;
            rpt.DataBind();

            // For each content row, if it is a Quiz, show question count on the right
            rpt.ItemDataBound += (s, args) =>
            {
                if (args.Item.ItemType != ListItemType.Item && args.Item.ItemType != ListItemType.AlternatingItem) return;

                var row = (DataRowView)args.Item.DataItem;
                var litRight = (Literal)args.Item.FindControl("litRightMeta");
                string ctype = row["ContentType"].ToString();

                if (string.Equals(ctype, "Quiz", StringComparison.OrdinalIgnoreCase))
                {
                    int quizId = Convert.ToInt32(row["LinkId"]);
                    int qCount = GetQuizQuestionCount(quizId);
                    litRight.Text = $"<span class='muted'>{qCount} question(s)</span>";
                }
                else if (string.Equals(ctype, "File", StringComparison.OrdinalIgnoreCase))
                {
                    litRight.Text = "<span class='muted'>File</span>";
                }
                else
                {
                    litRight.Text = "<span class='muted'>Page</span>";
                }
            };
        }

        private int GetQuizQuestionCount(int quizId)
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT COUNT(*) FROM dbo.QuestionBank WHERE QuizId = @qz;", con))
            {
                cmd.Parameters.AddWithValue("@qz", quizId);
                con.Open();
                return (int)cmd.ExecuteScalar();
            }
        }
    }
}
