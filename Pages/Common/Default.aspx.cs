using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QLNhanVien
{
    public partial class Default : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null)
            {
                Response.Redirect("~/Pages/Auth/Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadThongKe();
            }
        }

        // ================== LOGIC THỐNG KÊ (4 KHỐI TRÊN CÙNG) ==================
        private void LoadThongKe()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();

                // 1. Đếm nhân viên đang làm
                string sqlNV = "SELECT COUNT(*) FROM NhanVien WHERE TrangThai = N'Đang làm'";
                if (Session["Role"].ToString() == "QuanLy") sqlNV += " AND MaPB = '" + Session["MaPB_QuanLy"] + "'";
                lblTongNhanVien.Text = new SqlCommand(sqlNV, conn).ExecuteScalar().ToString();

                // 2. Đếm phòng ban
                lblTongPhongBan.Text = new SqlCommand("SELECT COUNT(*) FROM PhongBan", conn).ExecuteScalar().ToString();

                // 3. Đếm tài khoản
                lblTongTaiKhoan.Text = new SqlCommand("SELECT COUNT(*) FROM TaiKhoan", conn).ExecuteScalar().ToString();

                // 4. Đếm nhân viên nghỉ việc
                string sqlNghi = "SELECT COUNT(*) FROM NhanVien WHERE TrangThai = N'Đã nghỉ việc'";
                if (Session["Role"].ToString() == "QuanLy") sqlNghi += " AND MaPB = '" + Session["MaPB_QuanLy"] + "'";
                lblNVNghiViec.Text = new SqlCommand(sqlNghi, conn).ExecuteScalar().ToString();
            }
        }

        // ================== LOGIC XUẤT EXCEL DANH SÁCH NHÂN VIÊN ==================
        protected void btnXuatExcelNhanVien_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = @"SELECT n.MaNV as [Mã NV], n.HoTen as [Họ Tên], n.GioiTinh as [Giới Tính], 
                                      CONVERT(varchar, n.NgaySinh, 103) as [Ngày Sinh], n.SDT as [SĐT], 
                                      p.TenPhongBan as [Phòng Ban], c.TenChucVu as [Chức Vụ], n.TrangThai as [Trạng Thái]
                               FROM NhanVien n 
                               LEFT JOIN PhongBan p ON n.MaPB = p.MaPB 
                               LEFT JOIN ChucVu c ON n.MaCV = c.MaCV";

                // Quản lý chỉ được xuất nhân viên phòng mình
                if (Session["Role"].ToString() == "QuanLy")
                {
                    sql += " WHERE n.MaPB = @MaPB_QuanLy";
                }

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (Session["Role"].ToString() == "QuanLy")
                {
                    cmd.Parameters.AddWithValue("@MaPB_QuanLy", Session["MaPB_QuanLy"]);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ExportDataTableToExcel(dt, "DanhSachNhanVien.xls");
            }
        }

        // ================== LOGIC XUẤT EXCEL BẢNG LƯƠNG ==================
        protected void btnXuatExcelLuong_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Mặc định xuất bảng lương của tháng/năm hiện tại
                int thang = DateTime.Now.Month;
                int nam = DateTime.Now.Year;

                string sql = @"SELECT l.MaNV as [Mã NV], n.HoTen as [Họ Tên], p.TenPhongBan as [Phòng Ban], 
                                      l.Thang as [Tháng], l.Nam as [Năm], 
                                      l.LuongCoBan as [Lương Cơ Bản], l.Thuong as [Thưởng], l.Phat as [Phạt], 
                                      l.TongLuong as [Thực Lĩnh]
                               FROM Luong l
                               INNER JOIN NhanVien n ON l.MaNV = n.MaNV
                               LEFT JOIN PhongBan p ON n.MaPB = p.MaPB
                               WHERE l.Thang = @Thang AND l.Nam = @Nam";

                if (Session["Role"].ToString() == "QuanLy")
                {
                    sql += " AND n.MaPB = @MaPB_QuanLy";
                }

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Thang", thang);
                cmd.Parameters.AddWithValue("@Nam", nam);

                if (Session["Role"].ToString() == "QuanLy")
                {
                    cmd.Parameters.AddWithValue("@MaPB_QuanLy", Session["MaPB_QuanLy"]);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ExportDataTableToExcel(dt, "BangLuongThang_" + thang + "_" + nam + ".xls");
            }
        }

        // ================== HÀM HỖ TRỢ XUẤT EXCEL CHUNG ==================
        private void ExportDataTableToExcel(DataTable dt, string filename)
        {
            if (dt.Rows.Count > 0)
            {
                GridView gridView = new GridView();
                gridView.DataSource = dt;
                gridView.DataBind();

                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=" + filename);
                Response.Charset = "utf-8";
                Response.ContentType = "application/vnd.ms-excel";

                // Định dạng chuẩn Unicode để không bị lỗi font tiếng Việt
                Response.ContentEncoding = System.Text.Encoding.Unicode;
                Response.BinaryWrite(System.Text.Encoding.Unicode.GetPreamble());

                using (StringWriter sw = new StringWriter())
                {
                    using (HtmlTextWriter hw = new HtmlTextWriter(sw))
                    {
                        // Thêm CSS style mỏng để file Excel nhìn đẹp hơn, có viền bảng
                        hw.WriteLine("<style> td, th { border: 1px solid black; } th { background-color: #27ae60; color: white; font-weight: bold; } </style>");

                        gridView.RenderControl(hw);
                        Response.Output.Write(sw.ToString());
                        Response.Flush();
                        Response.End();
                    }
                }
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Không có dữ liệu để xuất trong tháng này!');", true);
            }
        }

        // Bắt buộc phải có override này để ASP.NET cho phép xuất GridView động ra Response
        public override void VerifyRenderingInServerForm(Control control)
        {
            // Xác nhận việc render Control bên ngoài Form
        }
    }
}