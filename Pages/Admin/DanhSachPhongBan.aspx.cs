using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace QLNhanVien
{
    public partial class DanhSachPhongBan : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Chỉ cho phép Admin vào xem cấu hình phòng ban/chức vụ
            if (Session["Username"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Pages/Common/Default.aspx");
            }

            if (!IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                // Load dữ liệu Phòng Ban
                SqlDataAdapter daPB = new SqlDataAdapter("SELECT MaPB, TenPhongBan, MoTa FROM PhongBan", conn);
                DataTable dtPB = new DataTable();
                daPB.Fill(dtPB);
                gvPhongBan.DataSource = dtPB;
                gvPhongBan.DataBind();

                // Load dữ liệu Chức Vụ
                SqlDataAdapter daCV = new SqlDataAdapter("SELECT MaCV, TenChucVu, HeSoLuong FROM ChucVu", conn);
                DataTable dtCV = new DataTable();
                daCV.Fill(dtCV);
                gvChucVu.DataSource = dtCV;
                gvChucVu.DataBind();
            }
        }
    }
}