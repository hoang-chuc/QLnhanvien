using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

namespace QLNhanVien
{
    public partial class HoSoCaNhan : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["QLNhanVienConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
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
                        string hoTen = dr["HoTen"].ToString();
                        lblMaNV.Text = dr["MaNV"].ToString();
                        lblHoTen.Text = hoTen;
                        lblHoTenTitle.Text = hoTen;

                        lblNgaySinh.Text = dr["NgaySinh"] != DBNull.Value
                                           ? Convert.ToDateTime(dr["NgaySinh"]).ToString("dd/MM/yyyy")
                                           : "Chưa cập nhật";

                        lblGioiTinh.Text = dr["GioiTinh"].ToString();
                        lblCCCD.Text = dr["CCCD"].ToString();
                        
                        string sdt = dr["SDT"].ToString();
                        string email = dr["Email"].ToString();
                        string diaChi = dr["DiaChi"].ToString();

                        lblSDT.Text = string.IsNullOrEmpty(sdt) ? "Chưa cập nhật" : sdt;
                        lblEmail.Text = string.IsNullOrEmpty(email) ? "Chưa cập nhật" : email;
                        lblDiaChi.Text = string.IsNullOrEmpty(diaChi) ? "Chưa cập nhật" : diaChi;

                        txtSDT.Text = sdt;
                        txtEmail.Text = email;
                        txtDiaChi.Text = diaChi;

                        string tenPhong = dr["TenPhongBan"] != DBNull.Value ? dr["TenPhongBan"].ToString() : "Chưa xếp phòng";
                        string tenChucVu = dr["TenChucVu"] != DBNull.Value ? dr["TenChucVu"].ToString() : "Nhân viên";

                        lblPhongBan.Text = tenPhong;
                        lblChucVu.Text = tenChucVu;
                        lblChucVuTitle.Text = tenChucVu;

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
                    ShowMsg("Lỗi tải thông tin cá nhân: " + ex.Message, false);
                }
            }
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            SetEditMode(true);
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            SetEditMode(false);
            LoadThongTinCaNhan();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = "UPDATE NhanVien SET SDT = @SDT, Email = @Email, DiaChi = @DiaChi WHERE MaNV = @MaNV";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@SDT", txtSDT.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@DiaChi", txtDiaChi.Text.Trim());
                cmd.Parameters.AddWithValue("@MaNV", Session["MaNV"].ToString());

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    ShowMsg("Cập nhật thông tin thành công!", true);
                    SetEditMode(false);
                    LoadThongTinCaNhan();
                }
                catch (Exception ex)
                {
                    ShowMsg("Lỗi lưu thông tin: " + ex.Message, false);
                }
            }
        }

        protected void btnUploadAvatar_Click(object sender, EventArgs e)
        {
            if (fuAvatar.HasFile)
            {
                try
                {
                    string ext = Path.GetExtension(fuAvatar.FileName).ToLower();
                    if (ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".gif")
                    {
                        string folderPath = Server.MapPath("~/Uploads/Avatars/");
                        if (!Directory.Exists(folderPath))
                        {
                            Directory.CreateDirectory(folderPath);
                        }

                        string fileName = "avatar_" + Session["MaNV"].ToString() + ext;
                        string savePath = folderPath + fileName;
                        fuAvatar.SaveAs(savePath);

                        string relativePath = "~/Uploads/Avatars/" + fileName;

                        // Cập nhật Database
                        using (SqlConnection conn = new SqlConnection(strConn))
                        {
                            SqlCommand cmd = new SqlCommand("UPDATE NhanVien SET AnhThe = @AnhThe WHERE MaNV = @MaNV", conn);
                            cmd.Parameters.AddWithValue("@AnhThe", relativePath);
                            cmd.Parameters.AddWithValue("@MaNV", Session["MaNV"].ToString());
                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }

                        ShowMsg("Tải ảnh đại diện thành công!", true);
                        LoadThongTinCaNhan();
                    }
                    else
                    {
                        ShowMsg("Chỉ chấp nhận các tệp ảnh .jpg, .jpeg, .png, .gif", false);
                    }
                }
                catch (Exception ex)
                {
                    ShowMsg("Lỗi tải ảnh lên: " + ex.Message, false);
                }
            }
            else
            {
                ShowMsg("Vui lòng chọn một tệp ảnh đại diện để tải lên.", false);
            }
        }

        private void SetEditMode(bool isEdit)
        {
            lblSDT.Visible = !isEdit;
            lblEmail.Visible = !isEdit;
            lblDiaChi.Visible = !isEdit;

            txtSDT.Visible = isEdit;
            txtEmail.Visible = isEdit;
            txtDiaChi.Visible = isEdit;

            btnEdit.Visible = !isEdit;
            btnSave.Visible = isEdit;
            btnCancel.Visible = isEdit;
        }

        private void ShowMsg(string msg, bool isSuccess)
        {
            string alertClass = isSuccess ? "alert-success" : "alert-danger";
            string iconClass = isSuccess ? "fa-check-circle" : "fa-exclamation-triangle";
            lblMsg.Text = $"<div class='alert {alertClass} alert-dismissible fade show' role='alert'><i class='fas {iconClass} me-2'></i>{msg}<button type='button' class='btn-close' data-bs-dismiss='alert'></button></div>";
        }
    }
}