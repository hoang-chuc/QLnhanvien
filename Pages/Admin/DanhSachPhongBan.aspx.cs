using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace QLNhanVien
{
    public partial class DanhSachPhongBan : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Chỉ cho phép Admin vào xem cấu hình phòng ban/chức vụ
            if (Session["Username"] == null || Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("/Pages/Common/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadData();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadData(txtSearch.Text.Trim());
        }

        private void LoadData(string keyword = "")
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Load dữ liệu Phòng Ban
                string sqlPB = "SELECT MaPB, TenPhongBan, MoTa FROM PhongBan WHERE 1=1";
                if (!string.IsNullOrEmpty(keyword))
                    sqlPB += " AND (TenPhongBan LIKE @Keyword OR MoTa LIKE @Keyword)";
                SqlCommand cmdPB = new SqlCommand(sqlPB, conn);
                if (!string.IsNullOrEmpty(keyword))
                    cmdPB.Parameters.AddWithValue("@Keyword", "%" + keyword + "%");
                SqlDataAdapter daPB = new SqlDataAdapter(cmdPB);
                DataTable dtPB = new DataTable();
                daPB.Fill(dtPB);
                gvPhongBan.DataSource = dtPB;
                gvPhongBan.DataBind();

                // Load dữ liệu Chức Vụ
                string sqlCV = "SELECT MaCV, TenChucVu, HeSoLuong FROM ChucVu WHERE 1=1";
                if (!string.IsNullOrEmpty(keyword))
                    sqlCV += " AND TenChucVu LIKE @Keyword";
                SqlCommand cmdCV = new SqlCommand(sqlCV, conn);
                if (!string.IsNullOrEmpty(keyword))
                    cmdCV.Parameters.AddWithValue("@Keyword", "%" + keyword + "%");
                SqlDataAdapter daCV = new SqlDataAdapter(cmdCV);
                DataTable dtCV = new DataTable();
                daCV.Fill(dtCV);
                gvChucVu.DataSource = dtCV;
                gvChucVu.DataBind();
            }
        }
    }
}