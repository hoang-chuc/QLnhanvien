using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace QLNhanVien
{
    public partial class ThongKe : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        public string LabelsPhongBan = "[]";
        public string DataNhanVien = "[]";
        public string DataQuyLuong = "[]";
        public string LabelsNghiPhep = "[]";
        public string DataNghiPhep = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Chỉ Admin mới được xem thống kê tổng
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("/Pages/Common/Default.aspx");
            }

            if (!IsPostBack)
            {
                LoadDuLieuBieuDo();
            }
        }

        private void LoadDuLieuBieuDo()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();

                int thangHienTai = DateTime.Now.Month;
                int namHienTai = DateTime.Now.Year;

                string sqlPhongBan = @"
                    SELECT 
                        p.TenPhongBan,
                        COUNT(DISTINCT n.MaNV) AS SoLaoDong,
                        ISNULL(SUM(l.TongLuong), 0) AS TongQuyLuong
                    FROM PhongBan p
                    LEFT JOIN NhanVien n ON p.MaPB = n.MaPB AND n.TrangThai = N'Đang làm'
                    LEFT JOIN Luong l ON n.MaNV = l.MaNV AND l.Thang = @Thang AND l.Nam = @Nam
                    GROUP BY p.TenPhongBan";

                SqlCommand cmdPB = new SqlCommand(sqlPhongBan, conn);
                cmdPB.Parameters.AddWithValue("@Thang", thangHienTai);
                cmdPB.Parameters.AddWithValue("@Nam", namHienTai);

                SqlDataReader drPB = cmdPB.ExecuteReader();

                string strLblPB = "";
                string strDataNV = "";
                string strDataLuong = "";

                while (drPB.Read())
                {
                    // BẢO MẬT: Escape ký tự đặc biệt trong tên để tránh XSS
                    string tenPB = drPB["TenPhongBan"].ToString().Replace("\\", "\\\\").Replace("'", "\\'").Replace("\"", "\\\"");
                    strLblPB += "'" + tenPB + "',";
                    strDataNV += drPB["SoLaoDong"].ToString() + ",";
                    strDataLuong += drPB["TongQuyLuong"].ToString() + ",";
                }
                drPB.Close();

                if (strLblPB.Length > 0)
                {

                    LabelsPhongBan = "[" + strLblPB.TrimEnd(',') + "]";
                    DataNhanVien = "[" + strDataNV.TrimEnd(',') + "]";
                    DataQuyLuong = "[" + strDataLuong.TrimEnd(',') + "]";
                }

                string sqlNghiPhep = @"
                    SELECT TrangThai, COUNT(MaDon) AS SoLuong 
                    FROM NghiPhep 
                    GROUP BY TrangThai";

                SqlCommand cmdNP = new SqlCommand(sqlNghiPhep, conn);
                SqlDataReader drNP = cmdNP.ExecuteReader();

                string strLblNP = "";
                string strDataNP = "";

                while (drNP.Read())
                {
                    // BẢO MẬT: Escape ký tự đặc biệt
                    string trangThai = drNP["TrangThai"].ToString().Replace("\\", "\\\\").Replace("'", "\\'");
                    strLblNP += "'" + trangThai + "',";
                    strDataNP += drNP["SoLuong"].ToString() + ",";
                }
                drNP.Close();

                if (strLblNP.Length > 0)
                {
                    LabelsNghiPhep = "[" + strLblNP.TrimEnd(',') + "]";
                    DataNghiPhep = "[" + strDataNP.TrimEnd(',') + "]";
                }
            }
        }
    }
}