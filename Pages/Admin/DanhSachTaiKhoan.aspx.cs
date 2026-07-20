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
                string sql = @"SELECT t.MaTK, t.Username,
                                      ISNULL(n.HoTen, N'Tài khoản Quản trị HT') AS TenNhanVien, 
                                      t.Role, t.TrangThai, t.NgayTao 
                               FROM TaiKhoan t
                               LEFT JOIN NhanVien n ON t.MaNV = n.MaNV
                               WHERE 1=1";

                if (!string.IsNullOrEmpty(keyword))
                    sql += " AND (t.Username LIKE @Keyword OR ISNULL(n.HoTen, '') LIKE @Keyword)";

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

        protected void gvTaiKhoan_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ToggleLock")
            {
                // CommandArgument format: "MaTK|TrangThai|Role"
                string[] parts = e.CommandArgument.ToString().Split('|');
                string maTK = parts[0];
                bool currentStatus = Convert.ToBoolean(parts[1]);
                string role = parts[2];

                // Bảo vệ: không cho khóa Admin
                if (role == "Admin") return;

                bool newStatus = !currentStatus;
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE TaiKhoan SET TrangThai=@TT WHERE MaTK=@MaTK", conn);
                    cmd.Parameters.AddWithValue("@TT", newStatus);
                    cmd.Parameters.AddWithValue("@MaTK", maTK);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                string action = newStatus ? "Mở khóa" : "Khóa";
                string type = newStatus ? "success" : "warning";
                ClientScript.RegisterStartupScript(this.GetType(), "toastMsg", $"window.showToast('{action} tài khoản thành công!', '{type}');", true);

                LoadDanhSachTaiKhoan(txtSearch.Text.Trim());
            }
        }
    }
}