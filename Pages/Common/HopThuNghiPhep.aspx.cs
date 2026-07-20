using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace QLNhanVien
{
    public partial class HopThuNghiPhep : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["MaNV"] == null)
            {
                Response.Redirect("/Pages/Auth/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (Session["Role"].ToString() == "NhanVien")
                {
                    mvHopThu.ActiveViewIndex = 0;
                    LoadLichSuNghiPhep();
                }
                else
                {
                    mvHopThu.ActiveViewIndex = 1;
                    LoadDanhSachDon();
                }
            }
        }

        protected void btnGuiDon_Click(object sender, EventArgs e)
        {
            DateTime tuNgay = DateTime.Parse(txtTuNgay.Text);
            DateTime denNgay = DateTime.Parse(txtDenNgay.Text);
            int soNgay = (int)(denNgay - tuNgay).TotalDays + 1;

            if (soNgay <= 0)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu!');", true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = @"INSERT INTO NghiPhep (MaNV, NgayBatDau, NgayKetThuc, SoNgay, LyDo, TrangThai, NgayTao) 
                               VALUES (@MaNV, @TuNgay, @DenNgay, @SoNgay, @LyDo, N'Chờ duyệt', GETDATE())";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaNV", Session["MaNV"]);
                cmd.Parameters.AddWithValue("@TuNgay", tuNgay);
                cmd.Parameters.AddWithValue("@DenNgay", denNgay);
                cmd.Parameters.AddWithValue("@SoNgay", soNgay);
                cmd.Parameters.AddWithValue("@LyDo", txtLyDo.Text.Trim());

                conn.Open();
                cmd.ExecuteNonQuery();

                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Đã gửi đơn xin nghỉ thành công!');", true);
                txtTuNgay.Text = txtDenNgay.Text = txtLyDo.Text = "";
                LoadLichSuNghiPhep();
            }
        }

        private void LoadLichSuNghiPhep()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = @"SELECT NgayBatDau, NgayKetThuc, SoNgay, LyDo, TrangThai, NgayTao 
                               FROM NghiPhep 
                               WHERE MaNV = @MaNV 
                               ORDER BY NgayTao DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaNV", Session["MaNV"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvLichSuNghiPhep.DataSource = dt;
                gvLichSuNghiPhep.DataBind();
            }
        }

        private void LoadDanhSachDon()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = @"SELECT np.MaDon, n.HoTen, np.NgayTao, np.LyDo, np.TrangThai 
                               FROM NghiPhep np
                               INNER JOIN NhanVien n ON np.MaNV = n.MaNV WHERE 1=1 ";

                if (Session["Role"].ToString() == "QuanLy")
                {
                    sql += " AND n.MaPB = @MaPB_QuanLy ";
                }

                sql += " ORDER BY CASE WHEN np.TrangThai = N'Chờ duyệt' THEN 0 ELSE 1 END, np.NgayTao DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (Session["Role"].ToString() == "QuanLy")
                {
                    cmd.Parameters.AddWithValue("@MaPB_QuanLy", Session["MaPB_QuanLy"]);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvDonNghi.DataSource = dt;
                gvDonNghi.DataBind();
            }
        }

        protected void gvDonNghi_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "XemChiTiet")
            {
                string maDon = e.CommandArgument.ToString();
                LoadChiTietDon(maDon);
                mvHopThu.ActiveViewIndex = 2;
            }
        }

        private void LoadChiTietDon(string maDon)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = @"SELECT np.MaDon, n.HoTen, np.NgayBatDau, np.NgayKetThuc, np.SoNgay, np.LyDo 
                               FROM NghiPhep np INNER JOIN NhanVien n ON np.MaNV = n.MaNV 
                               WHERE np.MaDon = @MaDon";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaDon", maDon);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    hdfMaDon.Value = dr["MaDon"].ToString();
                    lblChiTietNguoiGui.Text = dr["HoTen"].ToString();
                    lblChiTietThoiGian.Text = $"Từ {Convert.ToDateTime(dr["NgayBatDau"]).ToString("dd/MM/yyyy")} đến {Convert.ToDateTime(dr["NgayKetThuc"]).ToString("dd/MM/yyyy")}";
                    lblChiTietSoNgay.Text = dr["SoNgay"].ToString();
                    lblChiTietLyDo.Text = dr["LyDo"].ToString().Replace("\n", "<br/>");
                }
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            mvHopThu.ActiveViewIndex = 1;
        }

        protected void btnChapNhan_Click(object sender, EventArgs e) { CapNhatTrangThai("Đã duyệt"); }
        protected void btnTuChoi_Click(object sender, EventArgs e) { CapNhatTrangThai("Từ chối"); }
        protected void btnChoDuyet_Click(object sender, EventArgs e) { CapNhatTrangThai("Chờ duyệt"); }

        private void CapNhatTrangThai(string trangThaiMoi)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = "UPDATE NghiPhep SET TrangThai = @TT WHERE MaDon = @MaDon";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@TT", trangThaiMoi);
                cmd.Parameters.AddWithValue("@MaDon", hdfMaDon.Value);
                conn.Open();
                cmd.ExecuteNonQuery();

                LoadDanhSachDon();
                mvHopThu.ActiveViewIndex = 1;
            }
        }
    }
}