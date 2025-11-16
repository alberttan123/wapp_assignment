using Microsoft.Ajax.Utilities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace WAPP_Assignment.Student
{
    public partial class ViewCourse : System.Web.UI.Page
    {
        string CourseId = ""; //need to set courseId
        protected void Page_Load(object sender, EventArgs e)
        {
            var (isAuthenticated, userId, userType) = AuthCookieHelper.ReadAuthCookie();

            if (!Request.QueryString["CourseId"].IsNullOrWhiteSpace() && !userId.IsNullOrWhiteSpace())
            {
                CourseId = Request.QueryString["CourseId"].ToString();
                if (checkUserInCourse(userId)) //returns bool true
                {
                    UpdateLastAccessed(userId, CourseId);
                    initialLoad();
                }
                else 
                {
                    Response.Redirect("~/Student/Dashboard.aspx", true);
                }
            }
            else
            {
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            //add check to see if user is logged in
            //if not logged in redir to /base/landing
            //if logged in check if user is part of the class by checking enrollments
                //if not part of class redir to /Student/Dashboard
        }

        protected void initialLoad()
        {
            string title = "";
            string description = "";
            string createdAt = "";
            string chapterTotal = "";

            // Store chapters: (Id, Title, Order)
            List<(string ChapterId, string ChapterTitle, int ChapterOrder)> chapters = new List<(string, string, int)>();

            // Store content grouped by chapterId
            Dictionary<string, List<string>> chapterContentMap = new Dictionary<string, List<string>>();

            using (var conn = DataAccess.GetOpenConnection())
            {
                // Fetch course header
                SqlCommand cmd = new SqlCommand("SELECT CourseTitle, CourseDescription, CourseCreatedAt FROM dbo.Courses WHERE CourseId=@CourseId", conn);
                cmd.Parameters.AddWithValue("@CourseId", CourseId);

                using (var rd = cmd.ExecuteReader())
                {
                    if (rd.Read())
                    {
                        title = rd.GetString(0);
                        description = rd.GetString(1);
                        createdAt = rd.GetDateTime(2).ToString();
                    }
                }

                // Count chapters
                SqlCommand cmd1 = new SqlCommand(
                    "SELECT COUNT(*) FROM dbo.Chapters WHERE CourseId=@CourseId", conn);
                cmd1.Parameters.AddWithValue("@CourseId", CourseId);

                chapterTotal = ((int)cmd1.ExecuteScalar()).ToString();

                // Fetch chapters
                SqlCommand cmd2 = new SqlCommand(
                    "SELECT ChapterId, ChapterTitle, ChapterOrder FROM dbo.Chapters WHERE CourseId=@CourseId ORDER BY ChapterOrder ASC", conn);
                cmd2.Parameters.AddWithValue("@CourseId", CourseId);

                using (var rd = cmd2.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        string chId = rd.GetInt32(0).ToString();
                        string chTitle = rd.GetString(1);
                        int chOrder = rd.GetInt32(2);

                        chapters.Add((chId, chTitle, chOrder));
                        chapterContentMap[chId] = new List<string>(); // prepare space
                    }
                }

                // Fetch chapter contents grouped
                foreach (var chapter in chapters)
                {
                    SqlCommand cmd3 = new SqlCommand(
                        "SELECT ContentId FROM dbo.ChapterContents WHERE ChapterId=@ChapterId ORDER BY ContentId ASC", conn);
                    cmd3.Parameters.AddWithValue("@ChapterId", chapter.ChapterId);

                    using (var rd = cmd3.ExecuteReader())
                    {
                        while (rd.Read())
                        {
                            string contentId = rd.GetInt32(0).ToString();
                            chapterContentMap[chapter.ChapterId].Add(contentId);
                        }
                    }
                }
            }

            renderHeader(title, description, createdAt, chapterTotal);

            // Rendering chapters in the correct order
            foreach (var chapter in chapters)
            {
                string chapterId = chapter.ChapterId;
                string chapterTitle = chapter.ChapterTitle;
                List<string> contentIds = chapterContentMap[chapterId];

                Panel card = makeContentCard(chapterTitle, contentIds);
                course_content_container.Controls.Add(card);
            }
        }

        protected void addContentsToContainer(List<Panel> allPanels) 
        {
            int count = 0;
            while (count < allPanels.Count)
            {
                course_content_container.Controls.Add(allPanels[count]);
                count++;
            }
        }

        protected Panel makeContentCard(string chapterTitle, List<string> contentIds) 
        {
            Panel mainPanel = new Panel();
            mainPanel.CssClass = "content-card";

            Panel titleContainer = new Panel();
            titleContainer.CssClass = "course-content-title";
            Label chapterTitleLabel = new Label();
            chapterTitleLabel.Text = chapterTitle;
            titleContainer.Controls.Add(chapterTitleLabel);

            Panel contentContainer = new Panel();
            contentContainer.CssClass = "content-container";

            int count = 0;
            while (count < contentIds.Count) {
                HtmlAnchor content = makeSubContent(contentIds[count]);
                contentContainer.Controls.Add(content);
                count++;
            }

            mainPanel.Controls.Add(titleContainer);
            mainPanel.Controls.Add(contentContainer);

            return mainPanel;
        }

        protected HtmlAnchor makeSubContent(string contentId)
        {
            string contentTitle = "";
            string contentType = "";
            string linkId = "";

            using (var conn = DataAccess.GetOpenConnection())
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT ContentTitle, ContentType, LinkId 
            FROM dbo.ChapterContents 
            WHERE ContentId = @ContentId;", conn);

                cmd.Parameters.AddWithValue("@ContentId", contentId);

                using (var rd = cmd.ExecuteReader())
                {
                    if (rd.Read())
                    {
                        contentTitle = rd.GetString(0);
                        contentType = rd.GetString(1).ToLower(); // normalize
                        linkId = rd.GetInt32(2).ToString();
                    }
                }
            }

            // ---------------------------------
            // Determine URL based on contentType
            // ---------------------------------
            string redirectUrl = "#";

            switch (contentType)
            {
                case "page":
                    redirectUrl = ResolveUrl("~/Student/ViewPage.aspx?PageId=" + linkId);
                    break;

                case "quiz":
                    {
                        string quizType = GetQuizType(linkId); // linkId = QuizId

                        if (quizType == "exercise")
                        {
                            redirectUrl = ResolveUrl("~/Quiz/Exercise.aspx?QuizId=" + linkId);
                            contentTitle += " Exercise";
                        }
                        else if (quizType == "assessment") 
                        {
                            redirectUrl = ResolveUrl("~/Quiz/Assessment.aspx?QuizId=" + linkId);
                            contentTitle += " Assessment";
                        }
                        else
                            redirectUrl = "#"; // fallback if somehow no type found

                        break;
                    }
                case "file":
                    redirectUrl = ResolveUrl("~/Student/DownloadFile.aspx?FileId=" + linkId);
                    break;

                default:
                    redirectUrl = "#"; // fallback
                    break;
            }

            // ---------------------------------
            // Build UI card
            // ---------------------------------
            HtmlAnchor mainContainer = new HtmlAnchor();
            mainContainer.HRef = redirectUrl;
            mainContainer.Attributes.Add("class", "subcontent-container");

            // Container panel
            Panel subContainer = new Panel();
            subContainer.CssClass = "subcontent";

            // Icon (optional placeholder)
            Label icon = new Label();
            icon.CssClass = "subcontent-icon";

            if (contentType == "page")
                icon.Text = "📄";
            else if (contentType == "quiz")
                icon.Text = "📝";
            else if (contentType == "file")
                icon.Text = "📁";

            // Title label
            Label titleLabel = new Label();
            titleLabel.CssClass = "subcontent-title";
            titleLabel.Text = contentTitle;

            // Add elements to container
            subContainer.Controls.Add(icon);
            subContainer.Controls.Add(titleLabel);

            // Add inner panel to anchor
            mainContainer.Controls.Add(subContainer);

            return mainContainer;
        }

        protected void renderHeader(string title, string description, string createdat, string chapterTotal)
        {
            courseTitle.Text = title;
            courseDescription.Text = description;

            string courseinfo = "Created At: " + createdat + " | Total Number of Chapters: " + chapterTotal;
            courseInfo.Text = courseinfo;
        }

        protected bool checkUserInCourse(string userId)
        {
            using (var conn = DataAccess.GetOpenConnection())
            {
                SqlCommand cmd = new SqlCommand(@"SELECT TOP 1 CourseId FROM dbo.Enrollments WHERE UserId = @UserId AND CourseId = @CourseId;", conn);

                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@CourseId", CourseId);

                object result = cmd.ExecuteScalar();

                if (result == null)
                    return false;

                return true;
            }
        }

        private string GetQuizType(string quizId)
        {
            using (var conn = DataAccess.GetOpenConnection())
            using (var cmd = new SqlCommand("SELECT QuizType FROM dbo.Quiz WHERE QuizId=@q", conn))
            {
                cmd.Parameters.AddWithValue("@q", quizId);

                object result = cmd.ExecuteScalar();
                return (result == null) ? "" : result.ToString().ToLower();
            }
        }

        private void UpdateLastAccessed(string userId, string courseId)
        {
            try
            {
                using (var conn = DataAccess.GetOpenConnection())
                using (var cmd = new SqlCommand(@"
            UPDATE dbo.Enrollments
            SET LastAccessedAt = SYSUTCDATETIME()
            WHERE UserId = @UserId
              AND CourseId = @CourseId;
        ", conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@CourseId", courseId);

                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                // dbgLabel.Text = "LastAccessed update failed: " + ex.Message;
            }
        }



    }
}