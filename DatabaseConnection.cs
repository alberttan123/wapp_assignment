using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace WAPP_Assignment
{
    public class DataAccess
    {
        private static readonly string ConnStr =
        ConfigurationManager.ConnectionStrings["DatabaseConnection"].ConnectionString;

        public static SqlConnection GetOpenConnection()
        {
            var conn = new SqlConnection(ConnStr);
            conn.Open();
            return conn;
        }
    }
}