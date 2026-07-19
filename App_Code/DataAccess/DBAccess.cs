using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace QLNhanVien
{
    public class DBAccess
    {
        private static string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        public static SqlConnection GetConnection()
        {
            return new SqlConnection(strConn);
        }

        public static DataTable GetDataTable(string sql)
        {
            using (SqlConnection conn = GetConnection())
            {
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }
    }
}