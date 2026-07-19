using System;

namespace QLNhanVien
{
    public class NhanVien
    {
        public int MaNV { get; set; }
        public string HoTen { get; set; }
        public DateTime? NgaySinh { get; set; }
        public string GioiTinh { get; set; }
        public string CCCD { get; set; }
        public string DiaChi { get; set; }
        public string SDT { get; set; }
        public string Email { get; set; }
        public int? MaPB { get; set; }
        public int? MaCV { get; set; }
        public DateTime? NgayVaoLam { get; set; }
        public decimal LuongCoBan { get; set; }
        public string TrangThai { get; set; }
        public string AnhThe { get; set; }
        public DateTime? NgayTao { get; set; }
    }
}