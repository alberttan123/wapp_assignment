using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WAPP_Assignment.Lecturer
{
    public partial class LecturerCourseDetails : System.Web.UI.Page
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
                return 2; // geo_teacher from seed data
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (int.TryParse(Request.QueryString["courseId"], out int courseId) &&
                    courseId > 0)
                {
                    LoadCourse(courseId);
                }
                else
                {
                    ShowInfo("No course selected.");
                }
            }
        }

        private void LoadCourse(int courseId)
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT CourseId,
       CourseTitle,
       CourseDescription,
       TotalLessons,
       CourseCreatedAt
FROM dbo.Courses
WHERE CourseId = @id AND LecturerId = @lect;", con))
            {
                cmd.Parameters.AddWithValue("@id", courseId);
                cmd.Parameters.AddWithValue("@lect", CurrentLecturerId);

                con.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (!r.Read())
                    {
                        ShowInfo("Course not found or does not belong to you.");
                        return;
                    }

                    string title = r["CourseTitle"].ToString();
                    litCourseTitle.Text = title;

                    DateTime created = (DateTime)r["CourseCreatedAt"];
                    int totalLessons = r["TotalLessons"] == DBNull.Value
                        ? 0
                        : Convert.ToInt32(r["TotalLessons"]);

                    litCourseMeta.Text = string.Format(
                        "Created on {0:dd MMM yyyy} • Total chapters: {1}",
                        created,
                        totalLessons);

                    litCourseDesc.Text = r["CourseDescription"] == DBNull.Value
                        ? "No description set yet."
                        : Server.HtmlEncode(r["CourseDescription"].ToString()).Replace("\n", "<br />");

                    // link for Edit this Course
                    lnkEditCourse.NavigateUrl =
                        "~/Lecturer/LecturerCourseEditor.aspx?courseId=" + courseId;
                }
            }

            BindChapters(courseId);
        }

        private void BindChapters(int courseId)
        {
            using (var con = new SqlConnection(ConnStr))
            using (var da = new SqlDataAdapter(@"
SELECT ChapterId,
       ChapterOrder,
       ChapterTitle
FROM dbo.Chapters
WHERE CourseId = @cid
ORDER BY ChapterOrder ASC;", con))
            {
                da.SelectCommand.Parameters.AddWithValue("@cid", courseId);
                var dt = new DataTable();
                da.Fill(dt);

                rptChapters.DataSource = dt;
                rptChapters.DataBind();

                if (dt.Rows.Count == 0)
                {
                    ShowInfo("This course has no chapters yet.");
                }
            }
        }

        private void ShowInfo(string message)
        {
            lblInfo.Text = message;
            lblInfo.Visible = true;
        }

        protected void RptChapters_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            var drv = e.Item.DataItem as DataRowView;
            if (drv == null) return;

            int chapterId = Convert.ToInt32(drv["ChapterId"]);

            var rptContents = e.Item.FindControl("rptContents") as Repeater;
            if (rptContents == null) return;

            using (var con = new SqlConnection(ConnStr))
            using (var da = new SqlDataAdapter(@"
SELECT ContentId,
       ContentType,
       ContentTitle,
       LinkId
FROM dbo.ChapterContents
WHERE ChapterId = @cid
ORDER BY ContentId ASC;", con))
            {
                da.SelectCommand.Parameters.AddWithValue("@cid", chapterId);
                var dt = new DataTable();
                da.Fill(dt);

                rptContents.DataSource = dt;
                rptContents.DataBind();
            }
        }

        protected void RptContents_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            var drv = e.Item.DataItem as DataRowView;
            if (drv == null) return;

            string type = (drv["ContentType"] ?? "").ToString();
            int linkId = Convert.ToInt32(drv["LinkId"]);

            var litRightMeta = e.Item.FindControl("litRightMeta") as Literal;
            if (litRightMeta == null) return;

            // Right-hand summary based on content type
            switch (type)
            {
                case "Quiz":
                    litRightMeta.Text = GetQuizMeta(linkId);
                    break;
                case "File":
                    litRightMeta.Text = "File ID #" + linkId;
                    break;
                case "Page":
                    litRightMeta.Text = "Static page";
                    break;
                default:
                    litRightMeta.Text = "";
                    break;
            }
        }

        private string GetQuizMeta(int quizId)
        {
            int count = 0;
            string title = "";

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT q.QuizTitle,
       (SELECT COUNT(*) FROM dbo.QuestionBank qb WHERE qb.QuizId = q.QuizId) AS QCount
FROM dbo.Quiz q
WHERE q.QuizId = @id;", con))
            {
                cmd.Parameters.AddWithValue("@id", quizId);
                con.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        title = r["QuizTitle"].ToString();
                        count = r["QCount"] == DBNull.Value
                            ? 0
                            : Convert.ToInt32(r["QCount"]);
                    }
                }
            }

            if (string.IsNullOrEmpty(title))
                return "Quiz #" + quizId;

            return string.Format("{0} • {1} question{2}",
                title,
                count,
                count == 1 ? "" : "s");
        }
    }
}
