using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace QLNhanVien
{
    public partial class QuanLyCongTacPage : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Kiểm tra quyền: Chỉ Admin hoặc Quản lý mới được vào xem lịch sử
            if (Session["Username"] == null || Session["Role"] == null || (Session["Role"].ToString() != "Admin" && Session["Role"].ToString() != "QuanLy"))
            {
                Response.Redirect("/Pages/Common/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadLichSuNghiPhep();
            }
        }

        protected void ddlFilterTrangThai_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLichSuNghiPhep();
        }

        private void LoadLichSuNghiPhep()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = @"SELECT np.MaDon, n.MaNV, n.HoTen, np.NgayBatDau, np.NgayKetThuc, 
                                      np.SoNgay, np.LyDo, np.TrangThai, np.NgayTao 
                               FROM NghiPhep np
                               INNER JOIN NhanVien n ON np.MaNV = n.MaNV
                               WHERE 1=1 ";

                if (Session["Role"].ToString() == "QuanLy")
                {
                    sql += " AND n.MaPB = @MaPB_QuanLy ";
                }

                if (ddlFilterTrangThai.SelectedValue != "Tất cả")
                {
                    sql += " AND np.TrangThai = @TrangThai ";
                }

                sql += " ORDER BY np.NgayTao DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);

                if (Session["Role"].ToString() == "QuanLy")
                    cmd.Parameters.AddWithValue("@MaPB_QuanLy", Session["MaPB_QuanLy"]);

                if (ddlFilterTrangThai.SelectedValue != "Tất cả")
                    cmd.Parameters.AddWithValue("@TrangThai", ddlFilterTrangThai.SelectedValue);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvNghiPhep.DataSource = dt;
                gvNghiPhep.DataBind();
            }
        }
    }
}