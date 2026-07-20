using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;

namespace QLNhanVien
{
    public partial class DoiMatKhau : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("/Pages/Auth/Login.aspx");
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string oldPass = txtOldPassword.Text;
            string newPass = txtNewPassword.Text;
            string confirmPass = txtConfirmPassword.Text;

            if (string.IsNullOrEmpty(oldPass) || string.IsNullOrEmpty(newPass) || string.IsNullOrEmpty(confirmPass))
            {
                ShowMsg("Vui lòng điền đầy đủ các thông tin bắt buộc!", false);
                return;
            }

            if (newPass.Length < 6)
            {
                ShowMsg("Mật khẩu mới phải có độ dài tối thiểu là 6 ký tự!", false);
                return;
            }

            if (newPass != confirmPass)
            {
                ShowMsg("Xác nhận mật khẩu mới không khớp!", false);
                return;
            }

            string username = Session["Username"].ToString();

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Lấy mật khẩu hiện tại trong DB
                string currentDbPass = "";
                SqlCommand getCmd = new SqlCommand("SELECT PasswordHash FROM TaiKhoan WHERE Username = @Username", conn);
                getCmd.Parameters.AddWithValue("@Username", username);

                try
                {
                    conn.Open();
                    object val = getCmd.ExecuteScalar();
                    if (val != null)
                    {
                        currentDbPass = val.ToString();
                    }
                }
                catch (Exception ex)
                {
                    ShowMsg("Lỗi hệ thống: " + ex.Message, false);
                    return;
                }

                // Kiểm tra mật khẩu cũ (hỗ trợ cả plain text cũ và SHA-256 mới)
                bool isCorrect = PasswordHelper.VerifyPassword(oldPass, currentDbPass);

                if (!isCorrect)
                {
                    ShowMsg("Mật khẩu hiện tại không chính xác!", false);
                    return;
                }

                // Cập nhật mật khẩu mới (Bắt buộc lưu dưới dạng băm SHA-256)
                string newPassHash = PasswordHelper.HashPassword(newPass);
                SqlCommand updateCmd = new SqlCommand("UPDATE TaiKhoan SET PasswordHash = @NewPassword WHERE Username = @Username", conn);
                updateCmd.Parameters.AddWithValue("@NewPassword", newPassHash);
                updateCmd.Parameters.AddWithValue("@Username", username);

                try
                {
                    updateCmd.ExecuteNonQuery();
                    ShowMsg("Thay đổi mật khẩu thành công!", true);
                    txtOldPassword.Text = txtNewPassword.Text = txtConfirmPassword.Text = "";
                }
                catch (Exception ex)
                {
                    ShowMsg("Lỗi khi lưu mật khẩu mới: " + ex.Message, false);
                }
            }
        }

        private void ShowMsg(string msg, bool isSuccess)
        {
            string alertClass = isSuccess ? "alert-success" : "alert-danger";
            string iconClass = isSuccess ? "fa-check-circle" : "fa-exclamation-triangle";
            lblMsg.Text = $"<div class='alert {alertClass} alert-dismissible fade show' role='alert'><i class='fas {iconClass} me-2'></i>{msg}<button type='button' class='btn-close' data-bs-dismiss='alert'></button></div>";
        }
    }
}
