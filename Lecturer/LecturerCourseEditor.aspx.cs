using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;

namespace WAPP_Assignment.Lecturer
{
    public partial class LecturerCourseEditor : System.Web.UI.Page
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
                return 2; // fallback to geo_teacher from seed data
            }
        }

        // cache of all quizzes (exercise + assessment) for this page
        private DataTable QuizCache
        {
            get => ViewState["QuizCache"] as DataTable;
            set => ViewState["QuizCache"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // enable file upload for chapter files
            if (Page.Form != null)
                Page.Form.Enctype = "multipart/form-data";

            if (!IsPostBack)
            {
                if (int.TryParse(Request.QueryString["courseId"], out int cid) && cid > 0)
                {
                    LoadCourse(cid);
                    EnsureQuizCache();
                }
                else
                {
                    ShowInfo("No course selected.");
                    pnlEditor.Visible = false;
                }
            }
        }

        private void LoadCourse(int courseId)
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT CourseId, CourseTitle
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
                        pnlEditor.Visible = false;
                        return;
                    }

                    hfCourseId.Value = r["CourseId"].ToString();
                    litCourseTitle.Text = r["CourseTitle"].ToString();
                }
            }

            // link back to details
            lnkBackDetails.NavigateUrl =
                "~/Lecturer/LecturerCourseDetails.aspx?courseId=" + hfCourseId.Value;

            BindChapters();
        }

        private int CurrentCourseIdFromHidden()
        {
            return int.TryParse(hfCourseId.Value, out int id) ? id : 0;
        }

        private void BindChapters()
        {
            int courseId = CurrentCourseIdFromHidden();
            if (courseId <= 0)
            {
                rptChapters.DataSource = null;
                rptChapters.DataBind();
                return;
            }

            using (var con = new SqlConnection(ConnStr))
            using (var da = new SqlDataAdapter(@"
SELECT ChapterId, ChapterOrder, ChapterTitle
FROM dbo.Chapters
WHERE CourseId = @cid
ORDER BY ChapterOrder ASC;", con))
            {
                da.SelectCommand.Parameters.AddWithValue("@cid", courseId);
                var dt = new DataTable();
                da.Fill(dt);

                rptChapters.DataSource = dt;
                rptChapters.DataBind();
            }
        }

        private void EnsureQuizCache()
        {
            if (QuizCache != null) return;

            using (var con = new SqlConnection(ConnStr))
            using (var da = new SqlDataAdapter(@"
SELECT QuizId, QuizTitle, QuizType
FROM dbo.Quiz
ORDER BY QuizTitle;", con))
            {
                var dt = new DataTable();
                da.Fill(dt);
                QuizCache = dt;
            }
        }

        private void BindQuizDropdowns(DropDownList ddlExercises, DropDownList ddlAssessments)
        {
            if (ddlExercises == null || ddlAssessments == null) return;

            ddlExercises.Items.Clear();
            ddlAssessments.Items.Clear();

            ddlExercises.Items.Add(new ListItem("(Select exercise)", "0"));
            ddlAssessments.Items.Add(new ListItem("(Select assessment)", "0"));

            if (QuizCache == null) return;

            foreach (DataRow row in QuizCache.Rows)
            {
                string type = row["QuizType"].ToString();
                string text = row["QuizTitle"].ToString();
                string value = row["QuizId"].ToString();

                if (string.Equals(type, "exercise", StringComparison.OrdinalIgnoreCase))
                {
                    ddlExercises.Items.Add(new ListItem(text, value));
                }
                else if (string.Equals(type, "assessment", StringComparison.OrdinalIgnoreCase))
                {
                    ddlAssessments.Items.Add(new ListItem(text, value));
                }
            }
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

            // Bind existing contents
            using (var con = new SqlConnection(ConnStr))
            using (var da = new SqlDataAdapter(@"
SELECT CC.ContentId,
       CC.ContentType,
       CC.ContentTitle,
       CC.LinkId
FROM dbo.ChapterContents CC
WHERE CC.ChapterId = @cid
ORDER BY CC.ContentId ASC;", con))
            {
                da.SelectCommand.Parameters.AddWithValue("@cid", chapterId);
                var dt = new DataTable();
                da.Fill(dt);

                if (!dt.Columns.Contains("RightMeta"))
                    dt.Columns.Add("RightMeta", typeof(string));

                foreach (DataRow row in dt.Rows)
                {
                    string type = (row["ContentType"] ?? "").ToString();
                    int linkId = row["LinkId"] == DBNull.Value ? 0 : Convert.ToInt32(row["LinkId"]);

                    switch (type)
                    {
                        case "Quiz":
                            row["RightMeta"] = GetQuizMeta(linkId);
                            break;
                        case "File":
                            row["RightMeta"] = GetFileMeta(linkId);
                            break;
                        case "Page":
                            row["RightMeta"] = "Static page";
                            break;
                        default:
                            row["RightMeta"] = "";
                            break;
                    }
                }

                rptContents.DataSource = dt;
                rptContents.DataBind();
            }

            // Bind quiz dropdowns (exercise & assessment)
            EnsureQuizCache();
            var ddlExercises = e.Item.FindControl("ddlExercises") as DropDownList;
            var ddlAssessments = e.Item.FindControl("ddlAssessments") as DropDownList;
            BindQuizDropdowns(ddlExercises, ddlAssessments);
        }

        protected void BtnAddChapter_Click(object sender, EventArgs e)
        {
            lblInfo.Visible = false;

            int courseId = CurrentCourseIdFromHidden();
            if (courseId <= 0)
            {
                ShowInfo("Course context is missing.");
                return;
            }

            string title = txtNewChapterTitle.Text.Trim();
            if (string.IsNullOrEmpty(title))
            {
                ShowInfo("Chapter title is required.");
                return;
            }

            int nextOrder;
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT ISNULL(MAX(ChapterOrder), 0) + 1
FROM dbo.Chapters
WHERE CourseId = @cid;", con))
            {
                cmd.Parameters.AddWithValue("@cid", courseId);
                con.Open();
                nextOrder = (int)cmd.ExecuteScalar();
            }

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
INSERT INTO dbo.Chapters (CourseId, ChapterOrder, ChapterTitle)
VALUES (@cid, @ord, @title);", con))
            {
                cmd.Parameters.AddWithValue("@cid", courseId);
                cmd.Parameters.AddWithValue("@ord", nextOrder);
                cmd.Parameters.AddWithValue("@title", title);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            UpdateTotalLessons(courseId);
            txtNewChapterTitle.Text = "";
            BindChapters();
            ShowInfo("Chapter added.");
        }

        protected void RptChapters_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            lblInfo.Visible = false;

            if (!int.TryParse(e.CommandArgument as string, out int chapterId) || chapterId <= 0)
                return;

            switch (e.CommandName)
            {
                case "save":
                    SaveChapterTitle(e, chapterId);
                    break;
                case "up":
                    ReorderChapter(chapterId, moveUp: true);
                    break;
                case "down":
                    ReorderChapter(chapterId, moveUp: false);
                    break;
                case "delete":
                    DeleteChapter(chapterId);
                    break;
                case "addFile":
                    AddFileToChapter(e, chapterId);
                    break;
                case "addExercise":
                    AddQuizToChapter(e, chapterId, "exercise");
                    break;
                case "addAssessment":
                    AddQuizToChapter(e, chapterId, "assessment");
                    break;
            }

            int courseId = CurrentCourseIdFromHidden();
            if (courseId > 0)
                UpdateTotalLessons(courseId);

            BindChapters();
        }

        private void SaveChapterTitle(RepeaterCommandEventArgs e, int chapterId)
        {
            var txt = (TextBox)e.Item.FindControl("txtChapterTitle");
            if (txt == null) return;

            string title = txt.Text.Trim();
            if (string.IsNullOrEmpty(title))
            {
                ShowInfo("Chapter title cannot be empty.");
                return;
            }

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
UPDATE dbo.Chapters
SET ChapterTitle = @title
WHERE ChapterId = @id;", con))
            {
                cmd.Parameters.AddWithValue("@title", title);
                cmd.Parameters.AddWithValue("@id", chapterId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            ShowInfo("Chapter title updated.");
        }

        private void ReorderChapter(int chapterId, bool moveUp)
        {
            int courseId;
            int order;

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT ChapterId, CourseId, ChapterOrder
FROM dbo.Chapters
WHERE ChapterId = @id;", con))
            {
                cmd.Parameters.AddWithValue("@id", chapterId);
                con.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (!r.Read()) return;
                    courseId = (int)r["CourseId"];
                    order = (int)r["ChapterOrder"];
                }
            }

            int neighborId = 0;
            int neighborOrder = 0;

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand())
            {
                cmd.Connection = con;
                if (moveUp)
                {
                    cmd.CommandText = @"
SELECT TOP 1 ChapterId, ChapterOrder
FROM dbo.Chapters
WHERE CourseId = @cid AND ChapterOrder < @ord
ORDER BY ChapterOrder DESC;";
                }
                else
                {
                    cmd.CommandText = @"
SELECT TOP 1 ChapterId, ChapterOrder
FROM dbo.Chapters
WHERE CourseId = @cid AND ChapterOrder > @ord
ORDER BY ChapterOrder ASC;";
                }

                cmd.Parameters.AddWithValue("@cid", courseId);
                cmd.Parameters.AddWithValue("@ord", order);

                con.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (!r.Read()) return;
                    neighborId = (int)r["ChapterId"];
                    neighborOrder = (int)r["ChapterOrder"];
                }
            }

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand())
            {
                cmd.Connection = con;
                con.Open();
                using (var tx = con.BeginTransaction())
                {
                    cmd.Transaction = tx;
                    try
                    {
                        cmd.CommandText = "UPDATE dbo.Chapters SET ChapterOrder = @ord2 WHERE ChapterId = @id1;";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@ord2", neighborOrder);
                        cmd.Parameters.AddWithValue("@id1", chapterId);
                        cmd.ExecuteNonQuery();

                        cmd.CommandText = "UPDATE dbo.Chapters SET ChapterOrder = @ord1 WHERE ChapterId = @id2;";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@ord1", order);
                        cmd.Parameters.AddWithValue("@id2", neighborId);
                        cmd.ExecuteNonQuery();

                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        ShowInfo("Could not re-order chapter.");
                    }
                }
            }
        }

        private void DeleteChapter(int chapterId)
        {
            int courseId = CurrentCourseIdFromHidden();
            if (courseId <= 0) return;

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand())
            {
                cmd.Connection = con;
                con.Open();
                using (var tx = con.BeginTransaction())
                {
                    cmd.Transaction = tx;
                    try
                    {
                        // Check for linked contents; do not delete if any
                        cmd.CommandText = @"
SELECT COUNT(*)
FROM dbo.ChapterContents
WHERE ChapterId = @cid;";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@cid", chapterId);
                        int count = (int)cmd.ExecuteScalar();
                        if (count > 0)
                        {
                            tx.Rollback();
                            ShowInfo("Cannot delete: chapter has linked contents.");
                            return;
                        }

                        cmd.CommandText = "DELETE FROM dbo.Chapters WHERE ChapterId = @cid;";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@cid", chapterId);
                        cmd.ExecuteNonQuery();

                        tx.Commit();
                        ShowInfo("Chapter deleted.");
                    }
                    catch
                    {
                        tx.Rollback();
                        ShowInfo("Could not delete chapter.");
                    }
                }
            }
        }

        private void AddFileToChapter(RepeaterCommandEventArgs e, int chapterId)
        {
            var txtTitle = (TextBox)e.Item.FindControl("txtNewContentTitle");
            var fuFile = (FileUpload)e.Item.FindControl("fuNewFile");

            if (txtTitle == null || fuFile == null) return;

            string title = txtTitle.Text.Trim();
            if (string.IsNullOrEmpty(title))
            {
                ShowInfo("File title is required.");
                return;
            }

            if (!fuFile.HasFile)
            {
                ShowInfo("Please choose a file to upload.");
                return;
            }

            string filePath = SaveChapterFile(fuFile, out string fileName);

            int fileId;
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
INSERT INTO dbo.Files (FilePath, FileName)
VALUES (@path, @name);
SELECT CAST(SCOPE_IDENTITY() AS INT);", con))
            {
                cmd.Parameters.AddWithValue("@path", filePath);
                cmd.Parameters.AddWithValue("@name", fileName);
                con.Open();
                fileId = Convert.ToInt32(cmd.ExecuteScalar());
            }

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
INSERT INTO dbo.ChapterContents (ChapterId, ContentType, ContentTitle, LinkId)
VALUES (@cid, 'File', @title, @fileId);", con))
            {
                cmd.Parameters.AddWithValue("@cid", chapterId);
                cmd.Parameters.AddWithValue("@title", title);
                cmd.Parameters.AddWithValue("@fileId", fileId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            txtTitle.Text = "";
            ShowInfo("File added to chapter.");
        }

        private void AddQuizToChapter(RepeaterCommandEventArgs e, int chapterId, string quizType)
        {
            DropDownList ddl = null;
            string label;

            if (quizType == "exercise")
            {
                ddl = e.Item.FindControl("ddlExercises") as DropDownList;
                label = "exercise";
            }
            else
            {
                ddl = e.Item.FindControl("ddlAssessments") as DropDownList;
                label = "assessment";
            }

            if (ddl == null)
                return;

            if (!int.TryParse(ddl.SelectedValue, out int quizId) || quizId <= 0)
            {
                ShowInfo($"Please choose an {label} to add.");
                return;
            }

            string title = "";
            string actualType = "";

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT QuizTitle, QuizType
FROM dbo.Quiz
WHERE QuizId = @id;", con))
            {
                cmd.Parameters.AddWithValue("@id", quizId);
                con.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (!r.Read())
                    {
                        ShowInfo("Selected quiz no longer exists.");
                        return;
                    }

                    title = r["QuizTitle"].ToString();
                    actualType = r["QuizType"].ToString();
                }
            }

            if (!string.Equals(actualType, quizType, StringComparison.OrdinalIgnoreCase))
            {
                ShowInfo("Selected quiz type does not match the expected type.");
                return;
            }

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
INSERT INTO dbo.ChapterContents (ChapterId, ContentType, ContentTitle, LinkId)
VALUES (@cid, 'Quiz', @title, @qid);", con))
            {
                cmd.Parameters.AddWithValue("@cid", chapterId);
                cmd.Parameters.AddWithValue("@title", title);
                cmd.Parameters.AddWithValue("@qid", quizId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            ShowInfo(char.ToUpper(label[0]) + label.Substring(1) + " added to chapter.");
        }

        protected void RptContents_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            lblInfo.Visible = false;

            if (!int.TryParse(e.CommandArgument as string, out int contentId) || contentId <= 0)
                return;

            switch (e.CommandName)
            {
                case "saveContent":
                    SaveContentTitle(e, contentId);
                    break;
                case "deleteContent":
                    DeleteContent(e, contentId);
                    break;
            }

            BindChapters();
        }

        private void SaveContentTitle(RepeaterCommandEventArgs e, int contentId)
        {
            var txt = (TextBox)e.Item.FindControl("txtContentTitle");
            if (txt == null) return;

            string title = txt.Text.Trim();
            if (string.IsNullOrEmpty(title))
            {
                ShowInfo("Content title cannot be empty.");
                return;
            }

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
UPDATE dbo.ChapterContents
SET ContentTitle = @title
WHERE ContentId = @id;", con))
            {
                cmd.Parameters.AddWithValue("@title", title);
                cmd.Parameters.AddWithValue("@id", contentId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            ShowInfo("Content title updated.");
        }

        private void DeleteContent(RepeaterCommandEventArgs e, int contentId)
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
DELETE FROM dbo.ChapterContents
WHERE ContentId = @id;", con))
            {
                cmd.Parameters.AddWithValue("@id", contentId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            ShowInfo("Content removed from chapter.");
        }

        private void UpdateTotalLessons(int courseId)
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
UPDATE dbo.Courses
SET TotalLessons = (
    SELECT COUNT(*) FROM dbo.Chapters WHERE CourseId = @cid
)
WHERE CourseId = @cid;", con))
            {
                cmd.Parameters.AddWithValue("@cid", courseId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private string GetQuizMeta(int quizId)
        {
            if (quizId <= 0) return "";

            int count = 0;
            string title = "";
            string type = "";

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT q.QuizTitle,
       q.QuizType,
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
                        type = r["QuizType"].ToString();
                        count = r["QCount"] == DBNull.Value
                            ? 0
                            : Convert.ToInt32(r["QCount"]);
                    }
                }
            }

            if (string.IsNullOrEmpty(title))
                return "Quiz #" + quizId;

            string typeLabel = string.IsNullOrEmpty(type) ? "" : (" • " + type);
            return string.Format("{0}{1} • {2} question{3}",
                title,
                typeLabel,
                count,
                count == 1 ? "" : "s");
        }

        private string GetFileMeta(int fileId)
        {
            if (fileId <= 0) return "";

            string name = "";

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT FileName
FROM dbo.Files
WHERE FileId = @id;", con))
            {
                cmd.Parameters.AddWithValue("@id", fileId);
                con.Open();
                var obj = cmd.ExecuteScalar();
                if (obj != null && obj != DBNull.Value)
                    name = obj.ToString();
            }

            return string.IsNullOrEmpty(name) ? "File #" + fileId : name;
        }

        private string SaveChapterFile(FileUpload fu, out string fileName)
        {
            string folder = Server.MapPath("~/Uploads/Files");
            if (!Directory.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }

            string ext = Path.GetExtension(fu.FileName);
            if (string.IsNullOrEmpty(ext)) ext = ".dat";

            fileName = Path.GetFileName(fu.FileName);
            string uniqueName = $"chapter-{DateTime.UtcNow.Ticks}{ext}";
            string physical = Path.Combine(folder, uniqueName);
            fu.SaveAs(physical);

            return "~/Uploads/Files/" + uniqueName;
        }

        private void ShowInfo(string message)
        {
            lblInfo.Text = message;
            lblInfo.Visible = true;
        }
    }
}
