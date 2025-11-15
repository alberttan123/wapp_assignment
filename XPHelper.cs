
using System;
using System.Data.SqlClient;
using static WAPP_Assignment.DataAccess;

namespace WAPP_Assignment
{
    public static class XPHelper
    {
        public static void IncreaseXP(int userId, int xpIncreaseBy)
        {
            if (xpIncreaseBy <= 0) return; // no negative XP

            using (var conn = GetOpenConnection())
            {
                // fetch current XP
                int currentXP = 0;

                using (var cmd = new SqlCommand(
                    "SELECT XP FROM dbo.Users WHERE UserId = @id", conn))
                {
                    cmd.Parameters.AddWithValue("@id", userId);

                    var result = cmd.ExecuteScalar();
                    if (result == null) return;  // user not found

                    currentXP = Convert.ToInt32(result);
                }

                // increase XP
                int newXP = currentXP + xpIncreaseBy;

                // update XP in database
                using (var cmd = new SqlCommand(
                    "UPDATE dbo.Users SET XP = @xp WHERE UserId = @id", conn))
                {
                    cmd.Parameters.AddWithValue("@xp", newXP);
                    cmd.Parameters.AddWithValue("@id", userId);

                    cmd.ExecuteNonQuery();
                }
            }
        }

        public static string FetchXP(int userId)
        {
            using (var conn = GetOpenConnection())
            using (var cmd = new SqlCommand(
                "SELECT XP FROM dbo.Users WHERE UserId = @id", conn))
            {
                cmd.Parameters.AddWithValue("@id", userId);

                object result = cmd.ExecuteScalar();

                if (result == null || result == DBNull.Value)
                    return "0";

                return result.ToString();
            }
        }
    }
}
