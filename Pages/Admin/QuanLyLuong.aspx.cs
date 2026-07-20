using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace QLNhanVien
{
    public partial class QuanLyLuong : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() == "NhanVien")
            {
                Response.Redirect("/Pages/Auth/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                ddlThang.SelectedValue = DateTime.Now.Month.ToString();
                txtNam.Text = DateTime.Now.Year.ToString();
                LoadBangLuong();
            }
        }

        private void LoadBangLuong()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // CẬP NHẬT: JOIN thêm bảng ChucVu để lấy HeSoLuong
                string sql = @"SELECT l.MaLuong, l.MaNV, n.HoTen, p.TenPhongBan, c.HeSoLuong,
                                      l.LuongCoBan, l.Thuong, l.Phat, l.TongLuong, l.DaThanhToan
                               FROM Luong l
                               INNER JOIN NhanVien n ON l.MaNV = n.MaNV
                               LEFT JOIN PhongBan p ON n.MaPB = p.MaPB
                               LEFT JOIN ChucVu c ON n.MaCV = c.MaCV
                               WHERE l.Thang = @Thang AND l.Nam = @Nam ";

                if (Session["Role"].ToString() == "QuanLy")
                {
                    sql += " AND n.MaPB = @MaPB_QuanLy ";
                }

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Thang", ddlThang.SelectedValue);
                cmd.Parameters.AddWithValue("@Nam", txtNam.Text.Trim());

                if (Session["Role"].ToString() == "QuanLy")
                {
                    cmd.Parameters.AddWithValue("@MaPB_QuanLy", Session["MaPB_QuanLy"]);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvLuong.DataSource = dt;
                gvLuong.DataBind();
            }
        }

        protected void btnXem_Click(object sender, EventArgs e)
        {
            LoadBangLuong();
        }

        // ================= LOGIC KHỞI TẠO BẢNG LƯƠNG HÀNG THÁNG =================
        protected void btnTaoBangLuong_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // CẬP NHẬT: Tính Tổng Lương ban đầu = Lương Cơ Bản * Hệ Số Lương
                string sql = @"INSERT INTO Luong (MaNV, Thang, Nam, LuongCoBan, Thuong, Phat, TongLuong, DaThanhToan)
                               SELECT n.MaNV, @Thang, @Nam, n.LuongCoBan, 0, 0, (n.LuongCoBan * ISNULL(c.HeSoLuong, 1)), 0
                               FROM NhanVien n
                               LEFT JOIN ChucVu c ON n.MaCV = c.MaCV
                               WHERE n.TrangThai = N'Đang làm' 
                               AND NOT EXISTS (
                                   SELECT 1 FROM Luong l WHERE l.MaNV = n.MaNV AND l.Thang = @Thang AND l.Nam = @Nam
                               )";

                if (Session["Role"].ToString() == "QuanLy")
                {
                    sql = @"INSERT INTO Luong (MaNV, Thang, Nam, LuongCoBan, Thuong, Phat, TongLuong, DaThanhToan)
                            SELECT n.MaNV, @Thang, @Nam, n.LuongCoBan, 0, 0, (n.LuongCoBan * ISNULL(c.HeSoLuong, 1)), 0
                            FROM NhanVien n
                            LEFT JOIN ChucVu c ON n.MaCV = c.MaCV
                            WHERE n.TrangThai = N'Đang làm' AND n.MaPB = @MaPB_QuanLy
                            AND NOT EXISTS (
                                SELECT 1 FROM Luong l WHERE l.MaNV = n.MaNV AND l.Thang = @Thang AND l.Nam = @Nam
                            )";
                }

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Thang", ddlThang.SelectedValue);
                cmd.Parameters.AddWithValue("@Nam", txtNam.Text.Trim());

                if (Session["Role"].ToString() == "QuanLy")
                {
                    cmd.Parameters.AddWithValue("@MaPB_QuanLy", Session["MaPB_QuanLy"]);
                }

                conn.Open();
                int rowsAffected = cmd.ExecuteNonQuery();

                if (rowsAffected > 0)
                {
                    ShowMsg($"Khởi tạo thành công lương cho {rowsAffected} nhân viên trong tháng!", true);
                }
                else
                {
                    ShowMsg("Mọi nhân viên hiện tại đều đã có dữ liệu lương trong tháng này.", false);
                }

                LoadBangLuong();
            }
        }

        // ================= CÁC SỰ KIỆN SỬA LƯỚI (THƯỞNG/PHẠT) =================
        protected void gvLuong_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvLuong.EditIndex = e.NewEditIndex;
            LoadBangLuong();
        }

        protected void gvLuong_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvLuong.EditIndex = -1;
            LoadBangLuong();
        }

        protected void gvLuong_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            string maLuong = gvLuong.DataKeys[e.RowIndex].Value.ToString();

            GridViewRow row = gvLuong.Rows[e.RowIndex];
            TextBox txtThuong = (TextBox)row.FindControl("txtThuong");
            TextBox txtPhat = (TextBox)row.FindControl("txtPhat");
            CheckBox chkThanhToan = (CheckBox)row.FindControl("chkThanhToan");

            decimal thuong = string.IsNullOrEmpty(txtThuong.Text) ? 0 : Convert.ToDecimal(txtThuong.Text);
            decimal phat = string.IsNullOrEmpty(txtPhat.Text) ? 0 : Convert.ToDecimal(txtPhat.Text);
            bool daThanhToan = chkThanhToan.Checked;

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // CẬP NHẬT: Khi sửa Thưởng/Phạt, tính lại Tổng Lương = (Lương Cơ Bản * Hệ Số) + Thưởng - Phạt
                string sql = @"UPDATE l 
                               SET l.Thuong = @Thuong, 
                                   l.Phat = @Phat, 
                                   l.TongLuong = (l.LuongCoBan * ISNULL(c.HeSoLuong, 1)) + @Thuong - @Phat, 
                                   l.DaThanhToan = @DaThanhToan 
                               FROM Luong l
                               INNER JOIN NhanVien n ON l.MaNV = n.MaNV
                               LEFT JOIN ChucVu c ON n.MaCV = c.MaCV
                               WHERE l.MaLuong = @MaLuong";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Thuong", thuong);
                cmd.Parameters.AddWithValue("@Phat", phat);
                cmd.Parameters.AddWithValue("@DaThanhToan", daThanhToan);
                cmd.Parameters.AddWithValue("@MaLuong", maLuong);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            gvLuong.EditIndex = -1;
            LoadBangLuong();
        }

        private void ShowMsg(string msg, bool ok)
        {
            string type = ok ? "success" : "warning";
            string escapedMsg = msg.Replace("'", "\\'").Replace("\r", "").Replace("\n", " ");
            ClientScript.RegisterStartupScript(this.GetType(), "toastMsg", $"window.showToast('{escapedMsg}', '{type}');", true);
        }
    }
}