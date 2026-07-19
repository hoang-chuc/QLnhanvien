using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;

namespace QLNhanVien
{
    public partial class Login : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Username"] != null)
                {
                    Response.Redirect("~/Pages/Common/Default.aspx");
                }
            }
        }

        // ================= XỬ LÝ CHUYỂN ĐỔI MÀN HÌNH =================
        protected void btnGoToRegister_Click(object sender, EventArgs e)
        {
            mvAuth.ActiveViewIndex = 1;
            ClearMessage();
        }

        protected void btnGoToForgot_Click(object sender, EventArgs e)
        {
            mvAuth.ActiveViewIndex = 2;
            ClearMessage();
        }

        protected void btnBackToLogin_Click(object sender, EventArgs e)
        {
            mvAuth.ActiveViewIndex = 0;
            ClearMessage();
        }

        private void ClearMessage()
        {
            lblMessage.Text = "";
            lblMessage.CssClass = "mb-3 d-block text-center fw-bold";
        }

        private void ShowMessage(string msg, bool isSuccess)
        {
            lblMessage.Text = msg;
            lblMessage.ForeColor = isSuccess ? Color.Green : Color.Red;
        }

        // ================= XỬ LÝ ĐĂNG NHẬP (ĐÃ CẬP NHẬT PHÂN QUYỀN) =================
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // JOIN thêm bảng NhanVien để lấy MaPB và bảng PhongBan để lấy tên phòng mà Quản lý phụ trách
                string sql = @"SELECT t.MaTK, t.MaNV, t.Role, t.TrangThai, t.MaPB_QuanLy, n.MaPB, p.TenPhongBan 
                               FROM TaiKhoan t
                               LEFT JOIN NhanVien n ON t.MaNV = n.MaNV
                               LEFT JOIN PhongBan p ON t.MaPB_QuanLy = p.MaPB
                               WHERE t.Username = @Username AND t.PasswordHash = @Password";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", txtLoginUsername.Text.Trim());
                    cmd.Parameters.AddWithValue("@Password", txtLoginPassword.Text.Trim());

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            if (!Convert.ToBoolean(reader["TrangThai"]))
                            {
                                ShowMessage("Tài khoản đã bị khóa!", false);
                                return;
                            }

                            // 1. Lưu thông tin cơ bản
                            Session["Username"] = txtLoginUsername.Text.Trim();
                            Session["Role"] = reader["Role"].ToString();
                            Session["MaNV"] = reader["MaNV"] != DBNull.Value ? reader["MaNV"].ToString() : "";
                            Session["MaPB"] = reader["MaPB"] != DBNull.Value ? reader["MaPB"].ToString() : "";

                            // 2. Xử lý riêng thông tin cho Quản lý
                            if (reader["Role"].ToString() == "QuanLy")
                            {
                                Session["MaPB_QuanLy"] = reader["MaPB_QuanLy"].ToString();
                                Session["TenPBQuanLy"] = reader["TenPhongBan"] != DBNull.Value ? reader["TenPhongBan"].ToString() : "Chưa xác định";
                            }

                            Response.Redirect("~/Pages/Common/Default.aspx");
                        }
                        else
                        {
                            ShowMessage("Sai tên đăng nhập hoặc mật khẩu!", false);
                        }
                    }
                }
            }
        }

        // ================= XỬ LÝ ĐĂNG KÝ =================
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();

                string checkSql = "SELECT COUNT(*) FROM TaiKhoan WHERE Username = @Username";
                using (SqlCommand cmdCheck = new SqlCommand(checkSql, conn))
                {
                    cmdCheck.Parameters.AddWithValue("@Username", txtRegUsername.Text.Trim());
                    if ((int)cmdCheck.ExecuteScalar() > 0)
                    {
                        ShowMessage("Tên đăng nhập này đã có người sử dụng!", false);
                        return;
                    }
                }

                int newMaNV = 0;
                string insertNVSql = "INSERT INTO NhanVien (HoTen, LuongCoBan) VALUES (@HoTen, 0); SELECT SCOPE_IDENTITY();";
                using (SqlCommand cmdNV = new SqlCommand(insertNVSql, conn))
                {
                    cmdNV.Parameters.AddWithValue("@HoTen", txtRegFullName.Text.Trim());
                    newMaNV = Convert.ToInt32(cmdNV.ExecuteScalar());
                }

                string insertTKSql = "INSERT INTO TaiKhoan (Username, PasswordHash, MaNV, Role, TrangThai) VALUES (@Username, @Password, @MaNV, 'NhanVien', 1)";
                using (SqlCommand cmdTK = new SqlCommand(insertTKSql, conn))
                {
                    cmdTK.Parameters.AddWithValue("@Username", txtRegUsername.Text.Trim());
                    cmdTK.Parameters.AddWithValue("@Password", txtRegPassword.Text.Trim());
                    cmdTK.Parameters.AddWithValue("@MaNV", newMaNV);
                    cmdTK.ExecuteNonQuery();
                }

                ShowMessage("Đăng ký thành công! Hãy đăng nhập.", true);
                mvAuth.ActiveViewIndex = 0;
            }
        }

        // ================= XỬ LÝ QUÊN MẬT KHẨU =================
        protected void btnResetPass_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = @"UPDATE TaiKhoan 
                               SET PasswordHash = @NewPassword 
                               FROM TaiKhoan t
                               INNER JOIN NhanVien n ON t.MaNV = n.MaNV
                               WHERE t.Username = @Username 
                                 AND n.CCCD = @CCCD 
                                 AND n.SDT = @SDT";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", txtForgotUsername.Text.Trim());
                    cmd.Parameters.AddWithValue("@CCCD", txtForgotCCCD.Text.Trim());
                    cmd.Parameters.AddWithValue("@SDT", txtForgotSDT.Text.Trim());
                    cmd.Parameters.AddWithValue("@NewPassword", txtNewPassword.Text.Trim());

                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        ShowMessage("Đổi mật khẩu thành công! Hãy đăng nhập lại.", true);
                        mvAuth.ActiveViewIndex = 0;
                    }
                    else
                    {
                        ShowMessage("Thông tin xác nhận không chính xác!", false);
                    }
                }
            }
        }
    }
}