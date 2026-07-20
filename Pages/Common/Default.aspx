<%@ Page Title="Tổng quan" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="QLNhanVien.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-header d-flex justify-content-between align-items-center mb-0 border-bottom pb-2">
        <h3 class="fs-4 mb-0 fw-bold text-primary">Tổng quan</h3>
        <small class="text-muted"><i class="fas fa-tachometer-alt me-1"></i>Hệ thống Quản lý Nhân sự | IPlus</small>
    </div>

    <% string role = Session["Role"] != null ? Session["Role"].ToString() : ""; %>

    <%-- ===================== ADMIN / QUANLY ===================== --%>
    <% if (role == "Admin" || role == "QuanLy") { %>
    <div class="content-body">

        <%-- Hàng thống kê --%>
        <div class="row g-3 mb-4">
            <div class="col-md-3 col-sm-6">
                <div class="dash-card dc-info h-100">
                    <div class="dc-body">
                        <p class="dc-label mb-1"><i class="fas fa-users me-1"></i>Tổng nhân viên</p>
                        <h2 class="dc-number"><asp:Label ID="lblTongNhanVien" runat="server" Text="0"></asp:Label></h2>
                    </div>
                    <i class="fas fa-user dc-icon"></i>
                    <a href="../Admin/DanhSachNhanVien.aspx" class="dc-footer">
                        Danh sách nhân viên <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="dash-card dc-gray h-100">
                    <div class="dc-body">
                        <p class="dc-label mb-1"><i class="fas fa-building me-1"></i>Phòng ban</p>
                        <h2 class="dc-number"><asp:Label ID="lblTongPhongBan" runat="server" Text="0"></asp:Label></h2>
                    </div>
                    <i class="fas fa-university dc-icon"></i>
                    <a href="../Admin/DanhSachPhongBan.aspx" class="dc-footer">
                        Danh sách phòng ban <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="dash-card dc-purple h-100">
                    <div class="dc-body">
                        <p class="dc-label mb-1"><i class="fas fa-id-card me-1"></i>Tài khoản</p>
                        <h2 class="dc-number"><asp:Label ID="lblTongTaiKhoan" runat="server" Text="0"></asp:Label></h2>
                    </div>
                    <i class="fas fa-user-plus dc-icon"></i>
                    <a href="../Admin/DanhSachTaiKhoan.aspx" class="dc-footer">
                        Danh sách tài khoản <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="dash-card dc-danger h-100">
                    <div class="dc-body">
                        <p class="dc-label mb-1"><i class="fas fa-user-minus me-1"></i>Nghỉ việc</p>
                        <h2 class="dc-number"><asp:Label ID="lblNVNghiViec" runat="server" Text="0"></asp:Label></h2>
                    </div>
                    <i class="fas fa-chart-pie dc-icon"></i>
                    <a href="../Admin/DanhSachNhanVien.aspx" class="dc-footer">
                        Danh sách nghỉ việc <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>

        <%-- Xuất Excel --%>
        <div class="row g-3">
            <div class="col-md-6">
                <div class="dash-card dc-excel h-100">
                    <div class="dc-body">
                        <p class="dc-label mb-1" style="font-size:11px; opacity:0.7; text-transform:uppercase; letter-spacing:1px;">Xuất báo cáo</p>
                        <h4 class="dc-number" style="font-size:26px; letter-spacing:0;">
                            <i class="fas fa-file-excel me-2" style="font-size:22px;"></i>Danh sách nhân viên
                        </h4>
                    </div>
                    <i class="fas fa-file-excel dc-icon" style="font-size:80px;"></i>
                    <asp:LinkButton ID="btnXuatExcelNhanVien" runat="server"
                        CssClass="dc-footer text-decoration-none"
                        OnClick="btnXuatExcelNhanVien_Click">
                        Tải xuống Excel <i class="fas fa-download ms-1"></i>
                    </asp:LinkButton>
                </div>
            </div>
            <div class="col-md-6">
                <div class="dash-card dc-teal h-100">
                    <div class="dc-body">
                        <p class="dc-label mb-1" style="font-size:11px; opacity:0.7; text-transform:uppercase; letter-spacing:1px;">Xuất báo cáo</p>
                        <h4 class="dc-number" style="font-size:26px; letter-spacing:0;">
                            <i class="fas fa-file-invoice-dollar me-2" style="font-size:22px;"></i>Bảng lương nhân viên
                        </h4>
                    </div>
                    <i class="fas fa-file-invoice-dollar dc-icon" style="font-size:80px;"></i>
                    <asp:LinkButton ID="btnXuatExcelLuong" runat="server"
                        CssClass="dc-footer text-decoration-none"
                        OnClick="btnXuatExcelLuong_Click">
                        Tải xuống Excel <i class="fas fa-download ms-1"></i>
                    </asp:LinkButton>
                </div>
            </div>
        </div>

    </div>
    <% } %>

    <%-- ===================== NHÂN VIÊN ===================== --%>
    <% if (role == "NhanVien") { %>
    <div class="content-body">

        <div class="col-12 mb-3">
            <h4 class="fw-bold mb-0" style="color:#1e293b;">
                Xin chào, <span style="color:#3b82f6;"><asp:Label ID="lblWelcomeName" runat="server" Text="" /></span>! 👋
            </h4>
            <p class="text-muted mb-0" style="font-size:13px;">Đây là tổng quan tài khoản của bạn</p>
        </div>

        <%-- Row 1: 4 thẻ thông tin --%>
        <div class="row g-3 mb-3">
            <div class="col-md-3 col-sm-6">
                <div class="dash-card dc-info h-100">
                    <div class="dc-body">
                        <p class="dc-label mb-1">Phòng ban</p>
                        <h3 class="dc-number" style="font-size:22px; letter-spacing:0;">
                            <asp:Label ID="lblEmpPhongBan" runat="server" Text="Chưa xếp phòng" />
                        </h3>
                    </div>
                    <i class="fas fa-university dc-icon"></i>
                    <a href="../NhanVien/HoSoCaNhan.aspx" class="dc-footer">
                        Xem chi tiết <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="dash-card dc-purple h-100">
                    <div class="dc-body">
                        <p class="dc-label mb-1">Chức vụ</p>
                        <h3 class="dc-number" style="font-size:22px; letter-spacing:0;">
                            <asp:Label ID="lblEmpChucVu" runat="server" Text="Nhân viên" />
                        </h3>
                    </div>
                    <i class="fas fa-briefcase dc-icon"></i>
                    <a href="../NhanVien/HoSoCaNhan.aspx" class="dc-footer">
                        Xem chi tiết <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="dash-card dc-gray h-100">
                    <div class="dc-body">
                        <p class="dc-label mb-1">Trạng thái làm việc</p>
                        <h3 class="dc-number" style="font-size:22px; letter-spacing:0;">
                            <asp:Label ID="lblEmpTrangThai" runat="server" Text="Đang làm" />
                        </h3>
                    </div>
                    <i class="fas fa-info-circle dc-icon"></i>
                    <a href="../NhanVien/HoSoCaNhan.aspx" class="dc-footer">
                        Xem chi tiết <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="dash-card dc-danger h-100">
                    <div class="dc-body">
                        <p class="dc-label mb-1">Lương kỳ gần nhất</p>
                        <h3 class="dc-number" style="font-size:22px; letter-spacing:0;">
                            <asp:Label ID="lblEmpLuongStatus" runat="server" Text="Chưa nhận" />
                        </h3>
                    </div>
                    <i class="fas fa-money-bill-wave dc-icon"></i>
                    <a href="../NhanVien/BangLuongCaNhan.aspx" class="dc-footer">
                        Xem bảng lương <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>

        <%-- Row 2: 3 thẻ hành động --%>
        <div class="row g-3">
            <div class="col-md-4">
                <div class="dash-card dc-success h-100">
                    <div class="dc-body">
                        <p class="dc-label mb-1" style="font-size:11px; opacity:0.7; text-transform:uppercase; letter-spacing:1px;">Tài liệu cá nhân</p>
                        <h4 class="dc-number" style="font-size:22px; letter-spacing:0;">
                            <i class="fas fa-user-circle me-2" style="font-size:18px;"></i>Hồ Sơ
                        </h4>
                        <p class="dc-label" style="font-size:12px;">Thông tin cá nhân đầy đủ</p>
                    </div>
                    <i class="fas fa-user-circle dc-icon" style="font-size:80px;"></i>
                    <a href="../NhanVien/HoSoCaNhan.aspx" class="dc-footer">
                        Xem hồ sơ cá nhân <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="dash-card dc-teal h-100">
                    <div class="dc-body">
                        <p class="dc-label mb-1" style="font-size:11px; opacity:0.7; text-transform:uppercase; letter-spacing:1px;">Thu nhập</p>
                        <h4 class="dc-number" style="font-size:22px; letter-spacing:0;">
                            <i class="fas fa-money-bill-wave me-2" style="font-size:18px;"></i>Bảng Lương
                        </h4>
                        <p class="dc-label" style="font-size:12px;">Xem lịch sử lương tháng</p>
                    </div>
                    <i class="fas fa-wallet dc-icon" style="font-size:80px;"></i>
                    <a href="../NhanVien/BangLuongCaNhan.aspx" class="dc-footer">
                        Xem bảng lương của tôi <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="dash-card dc-amber h-100">
                    <div class="dc-body">
                        <p class="dc-label mb-1" style="font-size:11px; opacity:0.7; text-transform:uppercase; letter-spacing:1px;">Đăng ký</p>
                        <h4 class="dc-number" style="font-size:22px; letter-spacing:0;">
                            <i class="fas fa-calendar-times me-2" style="font-size:18px;"></i>Nghỉ Phép
                        </h4>
                        <p class="dc-label" style="font-size:12px;">Tạo đơn xin nghỉ phép</p>
                    </div>
                    <i class="fas fa-envelope-open-text dc-icon" style="font-size:80px;"></i>
                    <a href="../Common/HopThuNghiPhep.aspx" class="dc-footer">
                        Gửi đơn xin nghỉ phép <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>

    </div>
    <% } %>
</asp:Content>