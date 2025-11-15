using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace WAPP_Assignment.Admin
{
    public partial class AdminDashboard : Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            var (isAuth, userIdStr, userType) = AuthCookieHelper.ReadAuthCookie();
            if (!isAuth || string.IsNullOrEmpty(userIdStr) ||
                !string.Equals(userType, "Admin", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Base/Landing.aspx", true);
                return;
            }

            if (!IsPostBack)
            {
                litDashboardSubtitle.Text = "Overview of platform activity and account status.";

                BindProfileHeader(userIdStr);
                BindPasswordResets();
                BindLoginsToday();
                BindSignupsToday();
                BindSnapshot();
            }
        }

        private void BindProfileHeader(string userIdStr)
        {
            if (!int.TryParse(userIdStr, out int userId))
                return;

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
                        litProfileName.Text = rd["DisplayName"].ToString();
                        litProfileEmail.Text = rd["Email"].ToString();
                        litProfileRole.Text = rd["UserType"].ToString();
                    }
                }
            }
        }

        private void BindPasswordResets()
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
                SELECT 
                    UserId,
                    Username,
                    UserType,
                    COALESCE(NULLIF(FullName, ''), Username) AS DisplayName,
                    CreatedAt
                FROM dbo.Users
                WHERE IsPasswordReset = 1
                ORDER BY CreatedAt DESC;", con))
            {
                con.Open();
                using (var da = new SqlDataAdapter(cmd))
                {
                    var table = new DataTable();
                    da.Fill(table);

                    int count = table.Rows.Count;
                    litResetCount.Text = count == 1
                        ? "1 request"
                        : count + " requests";

                    if (count == 0)
                    {
                        pnlPasswordResetList.Visible = false;
                        pnlPasswordResetEmpty.Visible = true;
                    }
                    else
                    {
                        pnlPasswordResetList.Visible = true;
                        pnlPasswordResetEmpty.Visible = false;
                        rptPasswordResets.DataSource = table;
                        rptPasswordResets.DataBind();
                    }
                }
            }
        }

        private void BindLoginsToday()
        {
            int adminsTotal = 0, adminsToday = 0;
            int eduTotal = 0, eduToday = 0;
            int stuTotal = 0, stuToday = 0;

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
                SELECT 
                    UserType,
                    COUNT(*) AS TotalCount,
                    SUM(
                        CASE 
                            WHEN LastLogin IS NOT NULL 
                                 AND DATEDIFF(
                                     DAY,
                                     DATEADD(HOUR, 8, LastLogin),           -- LastLogin in MYT
                                     DATEADD(HOUR, 8, SYSUTCDATETIME())     -- now in MYT
                                 ) = 0
                            THEN 1 ELSE 0 
                        END
                    ) AS LoggedToday
                FROM dbo.Users
                GROUP BY UserType;", con))
            {
                con.Open();
                using (var rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        string type = rd["UserType"].ToString();
                        int total = Convert.ToInt32(rd["TotalCount"]);
                        int today = rd["LoggedToday"] == DBNull.Value
                            ? 0
                            : Convert.ToInt32(rd["LoggedToday"]);

                        switch (type)
                        {
                            case "Admin":
                                adminsTotal = total;
                                adminsToday = today;
                                break;
                            case "Educator":
                                eduTotal = total;
                                eduToday = today;
                                break;
                            case "Student":
                                stuTotal = total;
                                stuToday = today;
                                break;
                        }
                    }
                }
            }

            int totalUsers = adminsTotal + eduTotal + stuTotal;
            int totalToday = adminsToday + eduToday + stuToday;
            int notToday = totalUsers - totalToday;

            litLoginSummary.Text = totalUsers == 0
                ? "No users"
                : $"{totalToday} / {totalUsers} logged in";

            double pctLogged = 0;
            if (totalUsers > 0)
            {
                pctLogged = (double)totalToday * 100.0 / totalUsers;
            }

            string pctText = totalUsers == 0 ? "--" : $"{pctLogged:0}%";
            litLoginPercent.Text = pctText;

            string pieBg;
            if (totalUsers == 0)
            {
                pieBg = "conic-gradient(from -90deg, var(--panel-2) 0 100%)";
            }
            else
            {
                double pAdmin = adminsToday * 100.0 / totalUsers;
                double pEdu = eduToday * 100.0 / totalUsers;
                double pStu = stuToday * 100.0 / totalUsers;
                double pNot = notToday * 100.0 / totalUsers;

                double aEnd = Math.Round(pAdmin, 2);
                if (aEnd < 0) aEnd = 0; if (aEnd > 100) aEnd = 100;

                double eEnd = aEnd + Math.Round(pEdu, 2);
                if (eEnd < 0) eEnd = 0; if (eEnd > 100) eEnd = 100;

                double sEnd = eEnd + Math.Round(pStu, 2);
                if (sEnd < 0) sEnd = 0; if (sEnd > 100) sEnd = 100;

                double nStart = sEnd;
                double nEnd = 100.0;

                pieBg =
                    $"conic-gradient(from -90deg," +
                    $" var(--ad-pie-admin) 0 {aEnd:0.##}%," +
                    $" var(--ad-pie-educator) {aEnd:0.##}% {eEnd:0.##}%," +
                    $" var(--ad-pie-student) {eEnd:0.##}% {sEnd:0.##}%," +
                    $" var(--panel-2) {nStart:0.##}% {nEnd:0.##}%)";
            }

            divLoginPie.Style["background"] = pieBg;

            litLoginPieCaption.Text = totalUsers == 0
                ? "No users yet"
                : "Logged vs not logged today";

            litLoginAdmin.Text = $"{adminsToday} / {adminsTotal}";
            litLoginEducator.Text = $"{eduToday} / {eduTotal}";
            litLoginStudent.Text = $"{stuToday} / {stuTotal}";
            litLoginNotToday.Text = $"{notToday} users";
        }

        private void BindSignupsToday()
        {
            int signAdmin = 0, signEdu = 0, signStu = 0;

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
                SELECT 
                    UserType,
                    SUM(
                        CASE 
                            WHEN DATEDIFF(
                                     DAY,
                                     DATEADD(HOUR, 8, CreatedAt),
                                     DATEADD(HOUR, 8, SYSUTCDATETIME())
                                 ) = 0
                            THEN 1 ELSE 0 
                        END
                    ) AS SignedToday
                FROM dbo.Users
                GROUP BY UserType;", con))
            {
                con.Open();
                using (var rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        string type = rd["UserType"].ToString();
                        int count = rd["SignedToday"] == DBNull.Value
                            ? 0
                            : Convert.ToInt32(rd["SignedToday"]);

                        switch (type)
                        {
                            case "Admin":
                                signAdmin = count;
                                break;
                            case "Educator":
                                signEdu = count;
                                break;
                            case "Student":
                                signStu = count;
                                break;
                        }
                    }
                }
            }

            litSignupAdmin.Text = signAdmin.ToString();
            litSignupEducator.Text = signEdu.ToString();
            litSignupStudent.Text = signStu.ToString();

            int maxVal = Math.Max(signAdmin, Math.Max(signEdu, signStu));
            if (maxVal <= 0)
            {
                barSignupAdmin.Style["height"] = "4px";
                barSignupEducator.Style["height"] = "4px";
                barSignupStudent.Style["height"] = "4px";
                litSignupNote.Text = "No new sign-ups recorded today.";
            }
            else
            {
                barSignupAdmin.Style["height"] = $"{Math.Max(8, (int)(signAdmin * 100.0 / maxVal))}px";
                barSignupEducator.Style["height"] = $"{Math.Max(8, (int)(signEdu * 100.0 / maxVal))}px";
                barSignupStudent.Style["height"] = $"{Math.Max(8, (int)(signStu * 100.0 / maxVal))}px";

                int total = signAdmin + signEdu + signStu;
                litSignupNote.Text = total == 1
                    ? "1 new user created today."
                    : $"{total} new users created today.";
            }

            int totalSignups = signAdmin + signEdu + signStu;
            litSignupSummary.Text = totalSignups == 1
                ? "1 new signup"
                : totalSignups + " new signups";
        }

        private void BindSnapshot()
        {
            int totalAdmin = 0, totalEdu = 0, totalStu = 0;
            int totalCourses = 0, totalQuizzes = 0;
            int totalPosts = 0, totalComments = 0;

            using (var con = new SqlConnection(ConnStr))
            {
                con.Open();

                using (var cmd = new SqlCommand(@"
                    SELECT UserType, COUNT(*) AS Cnt
                    FROM dbo.Users
                    GROUP BY UserType;", con))
                using (var rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        string type = rd["UserType"].ToString();
                        int cnt = Convert.ToInt32(rd["Cnt"]);

                        switch (type)
                        {
                            case "Admin":
                                totalAdmin = cnt;
                                break;
                            case "Educator":
                                totalEdu = cnt;
                                break;
                            case "Student":
                                totalStu = cnt;
                                break;
                        }
                    }
                }

                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM dbo.Courses;", con))
                {
                    var obj = cmd.ExecuteScalar();
                    totalCourses = obj == null ? 0 : Convert.ToInt32(obj);
                }

                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM dbo.Quiz;", con))
                {
                    var obj = cmd.ExecuteScalar();
                    totalQuizzes = obj == null ? 0 : Convert.ToInt32(obj);
                }

                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM dbo.ForumPost;", con))
                {
                    var obj = cmd.ExecuteScalar();
                    totalPosts = obj == null ? 0 : Convert.ToInt32(obj);
                }
                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM dbo.ForumComment;", con))
                {
                    var obj = cmd.ExecuteScalar();
                    totalComments = obj == null ? 0 : Convert.ToInt32(obj);
                }
            }

            int totalUsers = totalAdmin + totalEdu + totalStu;

            litTotalUsers.Text = totalUsers.ToString();
            litTotalAdmins.Text = totalAdmin.ToString();
            litTotalEducators.Text = totalEdu.ToString();
            litTotalStudents.Text = totalStu.ToString();
            litTotalCourses.Text = totalCourses.ToString();
            litTotalQuizzes.Text = totalQuizzes.ToString();
            litForumPosts.Text = totalPosts.ToString();
            litForumComments.Text = totalComments.ToString();
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
