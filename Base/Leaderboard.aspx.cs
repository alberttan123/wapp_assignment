using System;
using System.Data;
using System.Data.SqlClient;
using static WAPP_Assignment.DataAccess;

public partial class Base_Leaderboard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadLeaderboard();
        }
    }

    private void LoadLeaderboard()
    {
        using (var conn = GetOpenConnection())
        using (var cmd = new SqlCommand(@"
            SELECT TOP 10 Username, FullName, XP
            FROM dbo.Users
            WHERE UserType = 'Student'
            ORDER BY XP DESC, UserId ASC;", conn))
        {
            using (var da = new SqlDataAdapter(cmd))
            using (var dt = new DataTable())
            {
                da.Fill(dt);
                rptLeaderboard.DataSource = dt;
                rptLeaderboard.DataBind();
            }
        }
    }

    protected string GetMedal(int rank)
    {
        switch (rank)
        {
            case 1: return "🥇";
            case 2: return "🥈";
            case 3: return "🥉";
            default: return "#" + rank;
        }
    }
}
