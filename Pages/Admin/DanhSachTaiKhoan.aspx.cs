using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace QLNhanVien
{
    public partial class DanhSachTaiKhoan : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // CHỐT CHẶN BẢO MẬT: Phân quyền URL
            // Chỉ Admin mới được phép ở lại trang này, nếu không phải đá về trang chủ
            if (Session["Username"] == null || Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("/Pages/Common/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadDanhSachTaiKhoan();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadDanhSachTaiKhoan(txtSearch.Text.Trim());
        }

        private void LoadDanhSachTaiKhoan(string keyword = "")
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = @"SELECT t.MaTK, t.Username, t.PasswordHash, 
                                      ISNULL(n.HoTen, N'Tài khoản Quản trị HT') AS TenNhanVien, 
                                      t.Role, t.TrangThai, t.NgayTao 
                               FROM TaiKhoan t
                               LEFT JOIN NhanVien n ON t.MaNV = n.MaNV
                               WHERE 1=1";

                if (!string.IsNullOrEmpty(keyword))
                {
                    sql += " AND (t.Username LIKE @Keyword OR ISNULL(n.HoTen, '') LIKE @Keyword)";
                }

                sql += " ORDER BY t.Role ASC, t.Username ASC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (!string.IsNullOrEmpty(keyword))
                    cmd.Parameters.AddWithValue("@Keyword", "%" + keyword + "%");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTaiKhoan.DataSource = dt;
                gvTaiKhoan.DataBind();
            }
        }
    }
}