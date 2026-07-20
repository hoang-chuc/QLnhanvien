using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace QLNhanVien
{
    public partial class HoSoCaNhan : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Kiểm tra đăng nhập
            if (Session["Username"] == null || Session["MaNV"] == null)
            {
                Response.Redirect("/Pages/Auth/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadThongTinCaNhan();
            }
        }

        private void LoadThongTinCaNhan()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Truy vấn JOIN 3 bảng để lấy đầy đủ thông tin hiển thị
                string sql = @"SELECT n.*, p.TenPhongBan, c.TenChucVu 
                               FROM NhanVien n
                               LEFT JOIN PhongBan p ON n.MaPB = p.MaPB
                               LEFT JOIN ChucVu c ON n.MaCV = c.MaCV
                               WHERE n.MaNV = @MaNV";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaNV", Session["MaNV"].ToString());

                try
                {
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        // Đổ dữ liệu vào các Label
                        string hoTen = dr["HoTen"].ToString();
                        lblMaNV.Text = dr["MaNV"].ToString();
                        lblHoTen.Text = hoTen;
                        lblHoTenTitle.Text = hoTen;

                        lblNgaySinh.Text = dr["NgaySinh"] != DBNull.Value
                                           ? Convert.ToDateTime(dr["NgaySinh"]).ToString("dd/MM/yyyy")
                                           : "Chưa cập nhật";

                        lblGioiTinh.Text = dr["GioiTinh"].ToString();
                        lblCCCD.Text = dr["CCCD"].ToString();
                        lblSDT.Text = dr["SDT"].ToString();
                        lblEmail.Text = dr["Email"].ToString();
                        lblDiaChi.Text = dr["DiaChi"].ToString();

                        string tenPhong = dr["TenPhongBan"] != DBNull.Value ? dr["TenPhongBan"].ToString() : "Chưa xếp phòng";
                        string tenChucVu = dr["TenChucVu"] != DBNull.Value ? dr["TenChucVu"].ToString() : "Nhân viên";

                        lblPhongBan.Text = tenPhong;
                        lblChucVu.Text = tenChucVu;
                        lblChucVuTitle.Text = tenChucVu;

                        // Xử lý ảnh đại diện (Nếu chưa có ảnh thì dùng ui-avatars tự động tạo theo tên)
                        string anhThe = dr["AnhThe"] != DBNull.Value ? dr["AnhThe"].ToString() : "";
                        if (string.IsNullOrEmpty(anhThe))
                        {
                            imgAvatar.ImageUrl = "https://ui-avatars.com/api/?size=256&name=" + Server.UrlEncode(hoTen) + "&background=random&color=fff";
                        }
                        else
                        {
                            imgAvatar.ImageUrl = ResolveUrl(anhThe);
                        }
                    }
                    dr.Close();
                }
                catch (Exception ex)
                {
                    // BẢO MẬT: Escape message để tránh XSS
                    string safeMsg = ex.Message.Replace("'", "\\'").Replace("</script>", "");
                    Response.Write("<script>alert('Lỗi tải dữ liệu: " + safeMsg + "');</script>");
                }
            }
        }
    }
}