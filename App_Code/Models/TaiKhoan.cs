using System;

namespace QLNhanVien
{
    public class TaiKhoan
    {
        public int MaTK { get; set; }
        public string Username { get; set; }
        public string PasswordHash { get; set; }
        public int? MaNV { get; set; }
        public string Role { get; set; }
        public int? MaPB_QuanLy { get; set; }
        public bool TrangThai { get; set; }
        public DateTime? NgayTao { get; set; }
    }
}