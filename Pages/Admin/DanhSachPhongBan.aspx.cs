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
            if (Session["Username"] == null || Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("/Pages/Common/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData(string keyword = "")
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sqlPB = "SELECT MaPB, TenPhongBan, MoTa FROM PhongBan WHERE 1=1";
                if (!string.IsNullOrEmpty(keyword))
                    sqlPB += " AND (TenPhongBan LIKE @Keyword OR MoTa LIKE @Keyword)";
                SqlCommand cmdPB = new SqlCommand(sqlPB, conn);
                if (!string.IsNullOrEmpty(keyword))
                    cmdPB.Parameters.AddWithValue("@Keyword", "%" + keyword + "%");
                SqlDataAdapter daPB = new SqlDataAdapter(cmdPB);
                DataTable dtPB = new DataTable();
                daPB.Fill(dtPB);
                gvPhongBan.DataSource = dtPB;
                gvPhongBan.DataBind();

                string sqlCV = "SELECT MaCV, TenChucVu, HeSoLuong FROM ChucVu WHERE 1=1";
                if (!string.IsNullOrEmpty(keyword))
                    sqlCV += " AND TenChucVu LIKE @Keyword";
                SqlCommand cmdCV = new SqlCommand(sqlCV, conn);
                if (!string.IsNullOrEmpty(keyword))
                    cmdCV.Parameters.AddWithValue("@Keyword", "%" + keyword + "%");
                SqlDataAdapter daCV = new SqlDataAdapter(cmdCV);
                DataTable dtCV = new DataTable();
                daCV.Fill(dtCV);
                gvChucVu.DataSource = dtCV;
                gvChucVu.DataBind();
            }
        }

        // ========== PHÒNG BAN ==========
        protected void btnShowAddPB_Click(object sender, EventArgs e)
        {
            hdfMaPB.Value = "";
            txtTenPB.Text = txtMoTaPB.Text = "";
            lblFormTitlePB.Text = "Thêm phòng ban mới";
            pnlFormPB.Visible = true;
            pnlFormCV.Visible = false;
        }

        protected void btnHuyPB_Click(object sender, EventArgs e)
        {
            pnlFormPB.Visible = false;
        }

        protected void btnLuuPB_Click(object sender, EventArgs e)
        {
            string ten = txtTenPB.Text.Trim();
            if (string.IsNullOrEmpty(ten))
            {
                ShowMsg("Tên phòng ban không được để trống.", false);
                return;
            }

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                SqlCommand cmd;
                if (string.IsNullOrEmpty(hdfMaPB.Value))
                {
                    // Kiểm tra trùng tên
                    SqlCommand chk = new SqlCommand("SELECT COUNT(*) FROM PhongBan WHERE TenPhongBan = @Ten", conn);
                    chk.Parameters.AddWithValue("@Ten", ten);
                    if ((int)chk.ExecuteScalar() > 0) { ShowMsg("Tên phòng ban đã tồn tại.", false); return; }

                    cmd = new SqlCommand("INSERT INTO PhongBan (TenPhongBan, MoTa) VALUES (@Ten, @MoTa)", conn);
                    cmd.Parameters.AddWithValue("@Ten", ten);
                    cmd.Parameters.AddWithValue("@MoTa", txtMoTaPB.Text.Trim());
                    cmd.ExecuteNonQuery();
                    ShowMsg("Thêm phòng ban thành công!", true);
                }
                else
                {
                    cmd = new SqlCommand("UPDATE PhongBan SET TenPhongBan=@Ten, MoTa=@MoTa WHERE MaPB=@MaPB", conn);
                    cmd.Parameters.AddWithValue("@Ten", ten);
                    cmd.Parameters.AddWithValue("@MoTa", txtMoTaPB.Text.Trim());
                    cmd.Parameters.AddWithValue("@MaPB", hdfMaPB.Value);
                    cmd.ExecuteNonQuery();
                    ShowMsg("Cập nhật phòng ban thành công!", true);
                }
            }
            pnlFormPB.Visible = false;
            LoadData();
        }

        protected void gvPhongBan_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "SuaPB")
            {
                string maPB = e.CommandArgument.ToString();
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM PhongBan WHERE MaPB=@MaPB", conn);
                    cmd.Parameters.AddWithValue("@MaPB", maPB);
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            hdfMaPB.Value = dr["MaPB"].ToString();
                            txtTenPB.Text = dr["TenPhongBan"].ToString();
                            txtMoTaPB.Text = dr["MoTa"].ToString();
                            lblFormTitlePB.Text = "Cập nhật phòng ban (Mã: " + maPB + ")";
                        }
                    }
                }
                pnlFormPB.Visible = true;
                pnlFormCV.Visible = false;
            }
            else if (e.CommandName == "XoaPB")
            {
                string maPB = e.CommandArgument.ToString();
                try
                {
                    using (SqlConnection conn = new SqlConnection(strConn))
                    {
                        SqlCommand chk = new SqlCommand("SELECT COUNT(*) FROM NhanVien WHERE MaPB=@MaPB", conn);
                        chk.Parameters.AddWithValue("@MaPB", maPB);
                        conn.Open();
                        if ((int)chk.ExecuteScalar() > 0)
                        {
                            ShowMsg("Không thể xóa: Phòng ban này vẫn còn nhân viên!", false);
                            return;
                        }
                        SqlCommand del = new SqlCommand("DELETE FROM PhongBan WHERE MaPB=@MaPB", conn);
                        del.Parameters.AddWithValue("@MaPB", maPB);
                        del.ExecuteNonQuery();
                    }
                    ShowMsg("Xóa phòng ban thành công!", true);
                }
                catch (Exception ex)
                {
                    ShowMsg("Lỗi khi xóa: " + ex.Message, false);
                }
                LoadData();
            }
        }

        // ========== CHỨC VỤ ==========
        protected void btnShowAddCV_Click(object sender, EventArgs e)
        {
            hdfMaCV.Value = "";
            txtTenCV.Text = txtHeSoLuong.Text = "";
            lblFormTitleCV.Text = "Thêm chức vụ mới";
            pnlFormCV.Visible = true;
            pnlFormPB.Visible = false;
        }

        protected void btnHuyCV_Click(object sender, EventArgs e)
        {
            pnlFormCV.Visible = false;
        }

        protected void btnLuuCV_Click(object sender, EventArgs e)
        {
            string ten = txtTenCV.Text.Trim();
            if (string.IsNullOrEmpty(ten))
            {
                ShowMsg("Tên chức vụ không được để trống.", false);
                return;
            }
            if (!decimal.TryParse(txtHeSoLuong.Text.Trim(), out decimal heso) || heso <= 0)
            {
                ShowMsg("Hệ số lương phải là số dương (VD: 1.0, 1.5).", false);
                return;
            }

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                if (string.IsNullOrEmpty(hdfMaCV.Value))
                {
                    SqlCommand chk = new SqlCommand("SELECT COUNT(*) FROM ChucVu WHERE TenChucVu = @Ten", conn);
                    chk.Parameters.AddWithValue("@Ten", ten);
                    if ((int)chk.ExecuteScalar() > 0) { ShowMsg("Tên chức vụ đã tồn tại.", false); return; }

                    SqlCommand cmd = new SqlCommand("INSERT INTO ChucVu (TenChucVu, HeSoLuong) VALUES (@Ten, @HeSo)", conn);
                    cmd.Parameters.AddWithValue("@Ten", ten);
                    cmd.Parameters.AddWithValue("@HeSo", heso);
                    cmd.ExecuteNonQuery();
                    ShowMsg("Thêm chức vụ thành công!", true);
                }
                else
                {
                    SqlCommand cmd = new SqlCommand("UPDATE ChucVu SET TenChucVu=@Ten, HeSoLuong=@HeSo WHERE MaCV=@MaCV", conn);
                    cmd.Parameters.AddWithValue("@Ten", ten);
                    cmd.Parameters.AddWithValue("@HeSo", heso);
                    cmd.Parameters.AddWithValue("@MaCV", hdfMaCV.Value);
                    cmd.ExecuteNonQuery();
                    ShowMsg("Cập nhật chức vụ thành công!", true);
                }
            }
            pnlFormCV.Visible = false;
            LoadData();
        }

        protected void gvChucVu_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "SuaCV")
            {
                string maCV = e.CommandArgument.ToString();
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM ChucVu WHERE MaCV=@MaCV", conn);
                    cmd.Parameters.AddWithValue("@MaCV", maCV);
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            hdfMaCV.Value = dr["MaCV"].ToString();
                            txtTenCV.Text = dr["TenChucVu"].ToString();
                            txtHeSoLuong.Text = dr["HeSoLuong"].ToString();
                            lblFormTitleCV.Text = "Cập nhật chức vụ (Mã: " + maCV + ")";
                        }
                    }
                }
                pnlFormCV.Visible = true;
                pnlFormPB.Visible = false;
            }
            else if (e.CommandName == "XoaCV")
            {
                string maCV = e.CommandArgument.ToString();
                try
                {
                    using (SqlConnection conn = new SqlConnection(strConn))
                    {
                        SqlCommand chk = new SqlCommand("SELECT COUNT(*) FROM NhanVien WHERE MaCV=@MaCV", conn);
                        chk.Parameters.AddWithValue("@MaCV", maCV);
                        conn.Open();
                        if ((int)chk.ExecuteScalar() > 0)
                        {
                            ShowMsg("Không thể xóa: Chức vụ này vẫn còn nhân viên đang giữ!", false);
                            return;
                        }
                        SqlCommand del = new SqlCommand("DELETE FROM ChucVu WHERE MaCV=@MaCV", conn);
                        del.Parameters.AddWithValue("@MaCV", maCV);
                        del.ExecuteNonQuery();
                    }
                    ShowMsg("Xóa chức vụ thành công!", true);
                }
                catch (Exception ex)
                {
                    ShowMsg("Lỗi khi xóa: " + ex.Message, false);
                }
                LoadData();
            }
        }

        private void ShowMsg(string msg, bool ok)
        {
            string type = ok ? "success" : "danger";
            string escapedMsg = msg.Replace("'", "\\'").Replace("\r", "").Replace("\n", " ");
            ClientScript.RegisterStartupScript(this.GetType(), "toastMsg", $"window.showToast('{escapedMsg}', '{type}');", true);
        }
    }
}