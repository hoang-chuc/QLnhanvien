using System.Security.Cryptography;
using System.Text;

namespace QLNhanVien
{
    public static class PasswordHelper
    {
        /// <summary>
        /// Mã hóa mật khẩu bằng SHA256 + salt đơn giản.
        /// </summary>
        public static string HashPassword(string password)
        {
            // Thêm "QLNhanVien_" prefix làm salt đơn giản
            string salted = "QLNhanVien_" + password + "_2026";
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(salted));
                StringBuilder sb = new StringBuilder();
                foreach (byte b in bytes)
                {
                    sb.Append(b.ToString("x2"));
                }
                return sb.ToString();
            }
        }

        /// <summary>
        /// Kiểm tra mật khẩu nhập vào có khớp với hash lưu trong DB không.
        /// Hỗ trợ cả plain text cũ (để migration dần).
        /// </summary>
        public static bool VerifyPassword(string inputPassword, string storedHash)
        {
            // 1. Thử so sánh hash trước
            string hashedInput = HashPassword(inputPassword);
            if (hashedInput == storedHash)
                return true;

            // 2. Fallback: hỗ trợ plain text cũ (để không bị khóa tài khoản khi chưa migrate)
            if (inputPassword == storedHash)
                return true;

            return false;
        }

        /// <summary>
        /// Kiểm tra xem password trong DB đã là hash chưa.
        /// Nếu chưa hash thì trả về true (cần re-hash).
        /// </summary>
        public static bool IsPlainText(string storedValue)
        {
            // Hash SHA256 luôn có 64 ký tự hex
            if (storedValue == null) return false;
            if (storedValue.Length != 64) return true;
            foreach (char c in storedValue)
            {
                if (!((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f')))
                    return true;
            }
            return false;
        }
    }
}
