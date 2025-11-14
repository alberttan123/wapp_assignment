using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace WAPP_Assignment.Lecturer
{
    public partial class LecturerCourseBuilder : System.Web.UI.Page
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

        protected void Page_Load(object sender, EventArgs e)
        {
            // enable file upload
            if (Page.Form != null)
                Page.Form.Enctype = "multipart/form-data";

            if (!IsPostBack)
            {
                LoadCourses();

                // If a specific courseId is provided, open that course
                if (int.TryParse(Request.QueryString["courseId"], out int cid) && cid > 0)
                {
                    SelectCourse(cid);
                }
                else
                {
                    // Coming from "Build a Course" or direct link with no courseId:
                    // always start in (New course) mode with empty fields
                    if (ddlCourses.Items.FindByValue("0") != null)
                        ddlCourses.SelectedValue = "0";

                    PrepareNewCourse();
                }
            }
        }

        /* ========== Courses ========== */

        private void LoadCourses()
        {
            ddlCourses.Items.Clear();
            ddlCourses.Items.Add(new System.Web.UI.WebControls.ListItem("(New course)", "0"));

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT CourseId, CourseTitle
FROM dbo.Courses
WHERE LecturerId = @lect
ORDER BY CourseCreatedAt DESC;", con))
            {
                cmd.Parameters.AddWithValue("@lect", CurrentLecturerId);
                con.Open();
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        ddlCourses.Items.Add(
                            new System.Web.UI.WebControls.ListItem(
                                r["CourseTitle"].ToString(),
                                r["CourseId"].ToString()));
                    }
                }
            }
        }

        private void SelectCourse(int courseId)
        {
            if (courseId <= 0)
            {
                if (ddlCourses.Items.FindByValue("0") != null)
                    ddlCourses.SelectedValue = "0";
                PrepareNewCourse();
                return;
            }

            if (ddlCourses.Items.FindByValue(courseId.ToString()) != null)
                ddlCourses.SelectedValue = courseId.ToString();

            hfCourseId.Value = courseId.ToString();

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
SELECT CourseId, CourseTitle, CourseDescription, CourseImgUrl
FROM dbo.Courses
WHERE CourseId = @id AND LecturerId = @lect;", con))
            {
                cmd.Parameters.AddWithValue("@id", courseId);
                cmd.Parameters.AddWithValue("@lect", CurrentLecturerId);

                con.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        txtCourseTitle.Text = r["CourseTitle"].ToString();
                        txtCourseDescription.Text = r["CourseDescription"] == DBNull.Value
                            ? ""
                            : r["CourseDescription"].ToString();

                        string imgUrl = r["CourseImgUrl"] == DBNull.Value
                            ? ""
                            : r["CourseImgUrl"].ToString();

                        hfCurrentCourseImgUrl.Value = imgUrl;
                        chkRemoveImg.Checked = false;

                        if (!string.IsNullOrWhiteSpace(imgUrl))
                        {
                            imgPreview.Visible = true;
                            imgPreview.ImageUrl = ResolveUrl(imgUrl);
                        }
                        else
                        {
                            imgPreview.Visible = false;
                        }
                    }
                    else
                    {
                        PrepareNewCourse();
                        ShowStatus("Selected course could not be found or does not belong to you.");
                        return;
                    }
                }
            }
        }

        private void PrepareNewCourse()
        {
            hfCourseId.Value = "0";
            hfCurrentCourseImgUrl.Value = "";
            txtCourseTitle.Text = "";
            txtCourseDescription.Text = "";
            chkRemoveImg.Checked = false;
            imgPreview.Visible = false;
        }

        protected void DdlCourses_SelectedIndexChanged(object sender, EventArgs e)
        {
            int courseId = int.Parse(ddlCourses.SelectedValue);
            SelectCourse(courseId);
        }

        protected void BtnNewCourse_Click(object sender, EventArgs e)
        {
            if (ddlCourses.Items.FindByValue("0") != null)
                ddlCourses.SelectedValue = "0";

            PrepareNewCourse();
        }

        protected void BtnSaveCourse_Click(object sender, EventArgs e)
        {
            lblStatus.Visible = false;

            string title = txtCourseTitle.Text.Trim();
            if (string.IsNullOrEmpty(title))
            {
                ShowStatus("Course title is required.");
                return;
            }

            string desc = string.IsNullOrWhiteSpace(txtCourseDescription.Text)
                ? null
                : txtCourseDescription.Text.Trim();

            // start from existing image
            string imgUrl = hfCurrentCourseImgUrl.Value;
            if (string.IsNullOrWhiteSpace(imgUrl))
                imgUrl = null;

            // handle remove image option
            if (chkRemoveImg.Checked)
            {
                imgUrl = null;
            }

            // replace if new file uploaded
            if (fuCourseImg.HasFile)
            {
                imgUrl = SaveCourseImage(fuCourseImg);
            }

            int courseId = 0;
            int.TryParse(hfCourseId.Value, out courseId);

            if (courseId <= 0)
            {
                // insert new
                using (var con = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand(@"
INSERT INTO dbo.Courses (CourseTitle, CourseDescription, TotalLessons, CourseImgUrl, LecturerId)
VALUES (@title, @desc, 0, @img, @lect);
SELECT CAST(SCOPE_IDENTITY() AS INT);", con))
                {
                    cmd.Parameters.AddWithValue("@title", title);
                    cmd.Parameters.AddWithValue("@desc",
                        (object)desc ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@img",
                        (object)imgUrl ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@lect", CurrentLecturerId);

                    con.Open();
                    courseId = Convert.ToInt32(cmd.ExecuteScalar());
                }

                LoadCourses();
                SelectCourse(courseId);
                ShowStatus("Course created.");
            }
            else
            {
                // update existing
                using (var con = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand(@"
UPDATE dbo.Courses
SET CourseTitle = @title,
    CourseDescription = @desc,
    CourseImgUrl = @img
WHERE CourseId = @id AND LecturerId = @lect;", con))
                {
                    cmd.Parameters.AddWithValue("@title", title);
                    cmd.Parameters.AddWithValue("@desc",
                        (object)desc ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@img",
                        (object)imgUrl ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@id", courseId);
                    cmd.Parameters.AddWithValue("@lect", CurrentLecturerId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadCourses();
                SelectCourse(courseId);
                ShowStatus("Course updated.");
            }
        }

        protected void BtnDeleteCourse_Click(object sender, EventArgs e)
        {
            lblStatus.Visible = false;
            if (!int.TryParse(hfCourseId.Value, out int courseId) || courseId <= 0)
            {
                ShowStatus("No course selected to delete.");
                return;
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
                        cmd.CommandText = @"
DELETE CC
FROM dbo.ChapterContents CC
JOIN dbo.Chapters C ON CC.ChapterId = C.ChapterId
WHERE C.CourseId = @cid;

DELETE FROM dbo.Chapters WHERE CourseId = @cid;

DELETE FROM dbo.Enrollments WHERE CourseId = @cid;
DELETE FROM dbo.Bookmarks WHERE CourseId = @cid;

DELETE FROM dbo.Courses
WHERE CourseId = @cid AND LecturerId = @lect;";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@cid", courseId);
                        cmd.Parameters.AddWithValue("@lect", CurrentLecturerId);

                        cmd.ExecuteNonQuery();
                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        ShowStatus("Could not delete course. Please try again.");
                        return;
                    }
                }
            }

            LoadCourses();
            PrepareNewCourse();
            if (ddlCourses.Items.FindByValue("0") != null)
                ddlCourses.SelectedValue = "0";
            ShowStatus("Course deleted.");
        }

        private void ShowStatus(string message)
        {
            lblStatus.Text = message;
            lblStatus.Visible = true;
        }

        private string SaveCourseImage(System.Web.UI.WebControls.FileUpload fu)
        {
            string folder = Server.MapPath("~/Uploads/Courses");
            if (!Directory.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }

            string ext = Path.GetExtension(fu.FileName);
            if (string.IsNullOrEmpty(ext)) ext = ".png";

            string name = $"course-{DateTime.UtcNow.Ticks}{ext}";
            string physical = Path.Combine(folder, name);
            fu.SaveAs(physical);

            return "~/Uploads/Courses/" + name;
        }
    }
}
