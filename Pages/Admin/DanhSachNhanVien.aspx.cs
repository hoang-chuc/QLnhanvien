using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace QLNhanVien
{
    public partial class DanhSachNhanVienPage : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // BẢO MẬT: Chỉ Admin và Quản lý mới được vào trang này
            if (Session["Username"] == null || (Session["Role"].ToString() != "Admin" && Session["Role"].ToString() != "QuanLy"))
            {
                Response.Redirect("~/Pages/Common/Default.aspx");
            }

            if (!IsPostBack)
            {
                LoadPhongBan();
                LoadChucVu();
                LoadDanhSachNhanVien("");
            }
        }

        // 1. TẢI DỮ LIỆU DANH MỤC CHO FORM
        private void LoadPhongBan()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT MaPB, TenPhongBan FROM PhongBan", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlPhongBan.DataSource = dt;
                ddlPhongBan.DataTextField = "TenPhongBan";
                ddlPhongBan.DataValueField = "MaPB";
                ddlPhongBan.DataBind();
                ddlPhongBan.Items.Insert(0, new ListItem("-- Chọn phòng ban --", "0"));
            }
        }

        private void LoadChucVu()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT MaCV, TenChucVu FROM ChucVu", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlChucVu.DataSource = dt;
                ddlChucVu.DataTextField = "TenChucVu";
                ddlChucVu.DataValueField = "MaCV";
                ddlChucVu.DataBind();
                ddlChucVu.Items.Insert(0, new ListItem("-- Chọn chức vụ --", "0"));
            }
        }

        // 2. TẢI DANH SÁCH NHÂN VIÊN (CÓ PHÂN QUYỀN)
        private void LoadDanhSachNhanVien(string searchKeyword)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = @"SELECT n.*, p.TenPhongBan, c.TenChucVu 
                               FROM NhanVien n 
                               LEFT JOIN PhongBan p ON n.MaPB = p.MaPB
                               LEFT JOIN ChucVu c ON n.MaCV = c.MaCV
                               WHERE 1=1 ";

                // PHÂN QUYỀN: Quản lý chỉ thấy nhân viên thuộc phòng ban mình phụ trách
                if (Session["Role"].ToString() == "QuanLy")
                {
                    sql += " AND n.MaPB = @MaPB_QuanLy ";
                }

                if (!string.IsNullOrEmpty(searchKeyword))
                {
                    sql += " AND n.HoTen LIKE @SearchKeyword ";
                }

                sql += " ORDER BY n.MaNV DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);

                if (Session["Role"].ToString() == "QuanLy")
                    cmd.Parameters.AddWithValue("@MaPB_QuanLy", Session["MaPB_QuanLy"]);

                if (!string.IsNullOrEmpty(searchKeyword))
                    cmd.Parameters.AddWithValue("@SearchKeyword", "%" + searchKeyword + "%");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvNhanVien.DataSource = dt;
                gvNhanVien.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadDanhSachNhanVien(txtSearch.Text.Trim());
        }

        // ================= XỬ LÝ CHUYỂN ĐỔI GIAO DIỆN =================
        protected void btnShowThem_Click(object sender, EventArgs e)
        {
            ClearForm();
            lblFormTitle.Text = "Thêm nhân viên mới";
            mvNhanVien.ActiveViewIndex = 1;
        }

        protected void btnHuy_Click(object sender, EventArgs e)
        {
            mvNhanVien.ActiveViewIndex = 0;
        }

        private void ClearForm()
        {
            hdfMaNV.Value = "";
            txtHoTen.Text = txtNgaySinh.Text = txtCCCD.Text = txtSDT.Text = txtEmail.Text = txtDiaChi.Text = txtLuong.Text = "";
            ddlGioiTinh.SelectedIndex = ddlPhongBan.SelectedIndex = ddlChucVu.SelectedIndex = ddlTrangThai.SelectedIndex = 0;
        }

        // ================= XỬ LÝ NÚT SỬA / XÓA TRÊN LƯỚI =================
        protected void gvNhanVien_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string maNV = e.CommandArgument.ToString();

            if (e.CommandName == "DeleteNV")
            {
                XoaNhanVien(maNV);
            }
            else if (e.CommandName == "EditNV")
            {
                LoadDataLenForm(maNV);
            }
        }

        private void XoaNhanVien(string maNV)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                using (SqlTransaction trans = conn.BeginTransaction())
                {
                    try
                    {
                        SqlCommand cmd = new SqlCommand(@"
                            DELETE FROM ChamCong WHERE MaNV = @MaNV;
                            DELETE FROM NghiPhep WHERE MaNV = @MaNV;
                            DELETE FROM Luong WHERE MaNV = @MaNV;
                            DELETE FROM TaiKhoan WHERE MaNV = @MaNV;
                            DELETE FROM NhanVien WHERE MaNV = @MaNV;", conn, trans);

                        cmd.Parameters.AddWithValue("@MaNV", maNV);
                        cmd.ExecuteNonQuery();
                        trans.Commit();
                        LoadDanhSachNhanVien(txtSearch.Text);
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Xóa thành công!');", true);
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Lỗi khi xóa: {ex.Message}');", true);
                    }
                }
            }
        }

        private void LoadDataLenForm(string maNV)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM NhanVien WHERE MaNV = @MaNV", conn);
                cmd.Parameters.AddWithValue("@MaNV", maNV);
                conn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        hdfMaNV.Value = dr["MaNV"].ToString();
                        txtHoTen.Text = dr["HoTen"].ToString();
                        if (dr["NgaySinh"] != DBNull.Value)
                            txtNgaySinh.Text = Convert.ToDateTime(dr["NgaySinh"]).ToString("yyyy-MM-dd");
                        ddlGioiTinh.SelectedValue = dr["GioiTinh"].ToString();
                        txtCCCD.Text = dr["CCCD"].ToString();
                        txtSDT.Text = dr["SDT"].ToString();
                        txtEmail.Text = dr["Email"].ToString();
                        txtDiaChi.Text = dr["DiaChi"].ToString();
                        if (dr["MaPB"] != DBNull.Value) ddlPhongBan.SelectedValue = dr["MaPB"].ToString();
                        if (dr["MaCV"] != DBNull.Value) ddlChucVu.SelectedValue = dr["MaCV"].ToString();
                        txtLuong.Text = Convert.ToInt32(dr["LuongCoBan"]).ToString();
                        ddlTrangThai.SelectedValue = dr["TrangThai"].ToString();

                        lblFormTitle.Text = "Cập nhật thông tin nhân viên (Mã: MNV" + maNV + ")";
                        mvNhanVien.ActiveViewIndex = 1;
                    }
                }
            }
        }

        // ================= XỬ LÝ NÚT LƯU TRÊN FORM =================
        protected void btnLuu_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                using (SqlTransaction trans = conn.BeginTransaction())
                {
                    try
                    {
                        SqlCommand cmd = new SqlCommand();
                        cmd.Connection = conn;
                        cmd.Transaction = trans;

                        object pb = ddlPhongBan.SelectedValue == "0" ? DBNull.Value : (object)ddlPhongBan.SelectedValue;
                        object cv = ddlChucVu.SelectedValue == "0" ? DBNull.Value : (object)ddlChucVu.SelectedValue;
                        object luong = string.IsNullOrEmpty(txtLuong.Text) ? 0 : (object)txtLuong.Text;
                        object ngaySinh = string.IsNullOrEmpty(txtNgaySinh.Text) ? DBNull.Value : (object)txtNgaySinh.Text;

                        if (string.IsNullOrEmpty(hdfMaNV.Value))
                        {
                            // 1. THÊM MỚI NHÂN VIÊN
                            cmd.CommandText = @"INSERT INTO NhanVien (HoTen, GioiTinh, NgaySinh, DiaChi, CCCD, SDT, Email, MaPB, MaCV, LuongCoBan, TrangThai, NgayVaoLam, NgayTao) 
                                                VALUES (@HoTen, @GioiTinh, @NgaySinh, @DiaChi, @CCCD, @SDT, @Email, @MaPB, @MaCV, @Luong, @TrangThai, GETDATE(), GETDATE());
                                                SELECT SCOPE_IDENTITY();";
                            AddParameters(cmd, ngaySinh, pb, cv, luong);
                            int newMaNV = Convert.ToInt32(cmd.ExecuteScalar());

                            // BẢO MẬT: Hash mật khẩu bằng SHA256 trước khi lưu
                            string hashedPassword = PasswordHelper.HashPassword("123456");
                            SqlCommand cmdTK = new SqlCommand(@"INSERT INTO TaiKhoan (Username, PasswordHash, MaNV, Role, TrangThai) 
                                                                VALUES (@User, @Password, @MaNV, 'NhanVien', 1)", conn, trans);
                            cmdTK.Parameters.AddWithValue("@Password", hashedPassword);
                            cmdTK.Parameters.AddWithValue("@User", string.IsNullOrEmpty(txtSDT.Text) ? "NV" + newMaNV : txtSDT.Text);
                            cmdTK.Parameters.AddWithValue("@MaNV", newMaNV);
                            cmdTK.ExecuteNonQuery();

                            // INSERT lương mới - tính TongLuong theo HeSoLuong (nhất quán với btnTaoBangLuong)
                            SqlCommand cmdLuong = new SqlCommand(@"INSERT INTO Luong (MaNV, Thang, Nam, LuongCoBan, Thuong, Phat, TongLuong, DaThanhToan) 
                                                                   SELECT @MaNV, @Thang, @Nam, @LuongCoBan, 0, 0, (@LuongCoBan * ISNULL(c.HeSoLuong, 1)), 0 
                                                                   FROM NhanVien nv LEFT JOIN ChucVu c ON nv.MaCV = c.MaCV 
                                                                   WHERE nv.MaNV = @MaNV", conn, trans);
                            cmdLuong.Parameters.AddWithValue("@MaNV", newMaNV);
                            cmdLuong.Parameters.AddWithValue("@Thang", DateTime.Now.Month);
                            cmdLuong.Parameters.AddWithValue("@Nam", DateTime.Now.Year);
                            cmdLuong.Parameters.AddWithValue("@LuongCoBan", luong);
                            cmdLuong.ExecuteNonQuery();
                        }
                        else
                        {
                            // CẬP NHẬT NHÂN VIÊN
                            cmd.CommandText = @"UPDATE NhanVien SET HoTen=@HoTen, GioiTinh=@GioiTinh, NgaySinh=@NgaySinh, DiaChi=@DiaChi, 
                                                CCCD=@CCCD, SDT=@SDT, Email=@Email, MaPB=@MaPB, MaCV=@MaCV, LuongCoBan=@Luong, TrangThai=@TrangThai 
                                                WHERE MaNV = @MaNV";
                            AddParameters(cmd, ngaySinh, pb, cv, luong);
                            cmd.Parameters.AddWithValue("@MaNV", hdfMaNV.Value);
                            cmd.ExecuteNonQuery();

                            // Cập nhật trạng thái tài khoản
                            SqlCommand cmdTK = new SqlCommand("UPDATE TaiKhoan SET TrangThai = CASE WHEN @TT = N'Đã nghỉ việc' THEN 0 ELSE 1 END WHERE MaNV = @MaNV", conn, trans);
                            cmdTK.Parameters.AddWithValue("@TT", ddlTrangThai.SelectedValue);
                            cmdTK.Parameters.AddWithValue("@MaNV", hdfMaNV.Value);
                            cmdTK.ExecuteNonQuery();

                            // Cập nhật lại Lương Cơ Bản trong bảng Lương tháng hiện tại nếu có thay đổi
                            // FIX: Tính TongLuong = (LuongCoBan × HeSoLuong) + Thuong - Phat (nhất quán với btnTaoBangLuong)
                            SqlCommand cmdUpdLuong = new SqlCommand(@"UPDATE l 
                                                                      SET l.LuongCoBan = @LuongCoBan, 
                                                                          l.TongLuong = (@LuongCoBan * ISNULL(c.HeSoLuong, 1)) + l.Thuong - l.Phat 
                                                                      FROM Luong l
                                                                      INNER JOIN NhanVien n ON l.MaNV = n.MaNV
                                                                      LEFT JOIN ChucVu c ON n.MaCV = c.MaCV
                                                                      WHERE l.MaNV = @MaNV AND l.Thang = @Thang AND l.Nam = @Nam", conn, trans);
                            cmdUpdLuong.Parameters.AddWithValue("@LuongCoBan", luong);
                            cmdUpdLuong.Parameters.AddWithValue("@MaNV", hdfMaNV.Value);
                            cmdUpdLuong.Parameters.AddWithValue("@Thang", DateTime.Now.Month);
                            cmdUpdLuong.Parameters.AddWithValue("@Nam", DateTime.Now.Year);
                            cmdUpdLuong.ExecuteNonQuery();
                        }

                        trans.Commit();
                        mvNhanVien.ActiveViewIndex = 0;
                        LoadDanhSachNhanVien(txtSearch.Text);
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Lỗi: {ex.Message.Replace("'", "")}');", true);
                    }
                }
            }
        }

        private void AddParameters(SqlCommand cmd, object ngaySinh, object pb, object cv, object luong)
        {
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@HoTen", txtHoTen.Text.Trim());
            cmd.Parameters.AddWithValue("@GioiTinh", ddlGioiTinh.SelectedValue);
            cmd.Parameters.AddWithValue("@NgaySinh", ngaySinh);
            cmd.Parameters.AddWithValue("@DiaChi", txtDiaChi.Text.Trim());
            cmd.Parameters.AddWithValue("@CCCD", txtCCCD.Text.Trim());
            cmd.Parameters.AddWithValue("@SDT", txtSDT.Text.Trim());
            cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
            cmd.Parameters.AddWithValue("@MaPB", pb);
            cmd.Parameters.AddWithValue("@MaCV", cv);
            cmd.Parameters.AddWithValue("@Luong", luong);
            cmd.Parameters.AddWithValue("@TrangThai", ddlTrangThai.SelectedValue);
        }
    }
}