using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace QLNhanVien
{
    public partial class BangLuongCaNhan : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null || Session["MaNV"] == null)
            {
                Response.Redirect("~/Pages/Auth/Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadDataLuong();
            }
        }

        /// <summary>
        /// Tải dữ liệu lương của chính nhân viên đang đăng nhập
        /// </summary>
        private void LoadDataLuong()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = @"SELECT MaLuong, Thang, Nam, LuongCoBan, Thuong, Phat, TongLuong, DaThanhToan 
                               FROM Luong 
                               WHERE MaNV = @MaNV 
                               ORDER BY Nam DESC, Thang DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);

                cmd.Parameters.AddWithValue("@MaNV", Session["MaNV"].ToString());

                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvLuongCaNhan.DataSource = dt;
                    gvLuongCaNhan.DataBind();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Có lỗi xảy ra khi tải bảng lương: " + ex.Message + "');</script>");
                }
            }
        }
    }
}