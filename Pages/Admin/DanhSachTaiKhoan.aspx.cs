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
            if (Session["Username"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Pages/Common/Default.aspx");
            }

            if (!IsPostBack)
            {
                LoadDanhSachTaiKhoan();
            }
        }

        private void LoadDanhSachTaiKhoan()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Truy vấn lấy toàn bộ thông tin tài khoản và nối với bảng Nhân Viên để lấy tên Chủ sở hữu
                string sql = @"SELECT t.MaTK, t.Username, t.PasswordHash, 
                                      ISNULL(n.HoTen, N'Tài khoản Quản trị HT') AS TenNhanVien, 
                                      t.Role, t.TrangThai, t.NgayTao 
                               FROM TaiKhoan t
                               LEFT JOIN NhanVien n ON t.MaNV = n.MaNV
                               ORDER BY t.Role ASC, t.Username ASC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTaiKhoan.DataSource = dt;
                gvTaiKhoan.DataBind();
            }
        }
    }
}