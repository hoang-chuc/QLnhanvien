<%@ Page Title="Tổng quan" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="QLNhanVien.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-header d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
        <h3 class="fs-4 mb-0 fw-bold text-primary">Tổng quan</h3>
        <small class="text-muted">Hệ thống Quản lý Nhân sự | IPlus</small>
    </div>

    <% string role = Session["Role"] != null ? Session["Role"].ToString() : ""; %>

    <% if (role == "Admin" || role == "QuanLy") { %>
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card text-white bg-info h-100 border-0 shadow-sm">
                <div class="card-body">
                    <h2 class="fw-bold"><asp:Label ID="lblTongNhanVien" runat="server" Text="0"></asp:Label></h2>
                    <p class="mb-0 fs-5">Nhân viên</p>
                    <i class="fas fa-user position-absolute" style="font-size: 3rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer bg-info border-0 text-center">
                    <a href="../Admin/DanhSachNhanVien.aspx" class="text-white text-decoration-none small">Danh sách nhân viên <i class="fas fa-arrow-circle-right"></i></a>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-white h-100 border-0 shadow-sm" style="background-color: #6c757d !important;">
                <div class="card-body">
                    <h2 class="fw-bold"><asp:Label ID="lblTongPhongBan" runat="server" Text="0"></asp:Label></h2>
                    <p class="mb-0 fs-5">Phòng ban</p>
                    <i class="fas fa-university position-absolute" style="font-size: 3rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer border-0 text-center" style="background-color: #5a6268;">
                    <a href="../Admin/DanhSachPhongBan.aspx" class="text-white text-decoration-none small">Danh sách phòng ban <i class="fas fa-arrow-circle-right"></i></a>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-white h-100 border-0 shadow-sm" style="background-color: #8e44ad !important;">
                <div class="card-body">
                    <h2 class="fw-bold"><asp:Label ID="lblTongTaiKhoan" runat="server" Text="0"></asp:Label></h2>
                    <p class="mb-0 fs-5">Tài khoản người dùng</p>
                    <i class="fas fa-user-plus position-absolute" style="font-size: 3rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer border-0 text-center" style="background-color: #7d3c98;">
                    <a href="../Admin/DanhSachTaiKhoan.aspx" class="text-white text-decoration-none small">Danh sách tài khoản <i class="fas fa-arrow-circle-right"></i></a>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-white bg-danger h-100 border-0 shadow-sm">
                <div class="card-body">
                    <h2 class="fw-bold"><asp:Label ID="lblNVNghiViec" runat="server" Text="0"></asp:Label></h2>
                    <p class="mb-0 fs-5">Nhân viên nghỉ việc</p>
                    <i class="fas fa-chart-pie position-absolute" style="font-size: 3rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer bg-danger border-0 text-center">
                    <a href="../Admin/DanhSachNhanVien.aspx" class="text-white text-decoration-none small">Danh sách nghỉ việc <i class="fas fa-arrow-circle-right"></i></a>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-6 mb-3">
            <div class="card text-white bg-success h-100 border-0 shadow-sm" style="background-color: #27ae60 !important;">
                <div class="card-body pb-1">
                    <h4 class="fw-bold mb-1">EXCEL</h4>
                    <p class="fs-5">Xuất báo cáo</p>
                    <i class="fas fa-file-excel position-absolute" style="font-size: 4rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer border-0" style="background-color: #229954;">
                    <asp:LinkButton ID="btnXuatExcelNhanVien" runat="server" CssClass="text-white text-decoration-none w-100 d-block small" OnClick="btnXuatExcelNhanVien_Click">
                        Danh sách nhân viên <i class="fas fa-arrow-circle-right float-end mt-1"></i>
                    </asp:LinkButton>
                </div>
            </div>
        </div>

        <div class="col-md-6 mb-3">
            <div class="card text-white bg-success h-100 border-0 shadow-sm" style="background-color: #27ae60 !important;">
                <div class="card-body pb-1">
                    <h4 class="fw-bold mb-1">EXCEL</h4>
                    <p class="fs-5">Xuất báo cáo</p>
                    <i class="fas fa-file-excel position-absolute" style="font-size: 4rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer border-0" style="background-color: #229954;">
                    <asp:LinkButton ID="btnXuatExcelLuong" runat="server" CssClass="text-white text-decoration-none w-100 d-block small" OnClick="btnXuatExcelLuong_Click">
                        Lương nhân viên <i class="fas fa-arrow-circle-right float-end mt-1"></i>
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <% if (role == "NhanVien") { %>
    <div class="col-12 mb-3">
        <h4 class="fw-bold">Xin chào, <asp:Label ID="lblWelcomeName" runat="server" Text="" />!</h4>
    </div>
    <div class="row mb-4">
        <!-- Card 1: Phong ban (Blue/bg-info) -->
        <div class="col-md-3 mb-3">
            <div class="card text-white bg-info h-100 border-0 shadow-sm">
                <div class="card-body">
                    <h2 class="fw-bold fs-3"><asp:Label ID="lblEmpPhongBan" runat="server" Text="Chưa xếp phòng" /></h2>
                    <p class="mb-0 fs-5">Phòng ban</p>
                    <i class="fas fa-university position-absolute" style="font-size: 3rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer bg-info border-0 text-center">
                    <a href="../NhanVien/HoSoCaNhan.aspx" class="text-white text-decoration-none small">Xem chi tiết <i class="fas fa-arrow-circle-right"></i></a>
                </div>
            </div>
        </div>
        <!-- Card 2: Chuc vu (Purple/#8e44ad) -->
        <div class="col-md-3 mb-3">
            <div class="card text-white h-100 border-0 shadow-sm" style="background-color: #8e44ad !important;">
                <div class="card-body">
                    <h2 class="fw-bold fs-3"><asp:Label ID="lblEmpChucVu" runat="server" Text="Nhân viên" /></h2>
                    <p class="mb-0 fs-5">Chức vụ</p>
                    <i class="fas fa-briefcase position-absolute" style="font-size: 3rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer border-0 text-center" style="background-color: #7d3c98;">
                    <a href="../NhanVien/HoSoCaNhan.aspx" class="text-white text-decoration-none small">Xem chi tiết <i class="fas fa-arrow-circle-right"></i></a>
                </div>
            </div>
        </div>
        <!-- Card 3: Trang thai (Grey/#6c757d) -->
        <div class="col-md-3 mb-3">
            <div class="card text-white h-100 border-0 shadow-sm" style="background-color: #6c757d !important;">
                <div class="card-body">
                    <h2 class="fw-bold fs-3"><asp:Label ID="lblEmpTrangThai" runat="server" Text="Đang làm" /></h2>
                    <p class="mb-0 fs-5">Trạng thái làm việc</p>
                    <i class="fas fa-info-circle position-absolute" style="font-size: 3rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer border-0 text-center" style="background-color: #5a6268;">
                    <a href="../NhanVien/HoSoCaNhan.aspx" class="text-white text-decoration-none small">Xem chi tiết <i class="fas fa-arrow-circle-right"></i></a>
                </div>
            </div>
        </div>
        <!-- Card 4: Luong ky gan nhat (Red/bg-danger) -->
        <div class="col-md-3 mb-3">
            <div class="card text-white bg-danger h-100 border-0 shadow-sm">
                <div class="card-body">
                    <h2 class="fw-bold fs-3"><asp:Label ID="lblEmpLuongStatus" runat="server" Text="Chưa nhận" /></h2>
                    <p class="mb-0 fs-5">Lương kỳ gần nhất</p>
                    <i class="fas fa-money-bill-wave position-absolute" style="font-size: 3rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer bg-danger border-0 text-center">
                    <a href="../NhanVien/BangLuongCaNhan.aspx" class="text-white text-decoration-none small">Xem bảng lương <i class="fas fa-arrow-circle-right"></i></a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="row">
        <div class="col-md-4 mb-3">
            <div class="card text-white bg-success h-100 border-0 shadow-sm" style="background-color: #27ae60 !important;">
                <div class="card-body pb-1">
                    <h4 class="fw-bold mb-1">HỒ SƠ</h4>
                    <p class="fs-5">Thông tin cá nhân</p>
                    <i class="fas fa-user-circle position-absolute" style="font-size: 4rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer border-0" style="background-color: #229954;">
                    <a href="../NhanVien/HoSoCaNhan.aspx" class="text-white text-decoration-none w-100 d-block small">
                        Xem hồ sơ cá nhân <i class="fas fa-arrow-circle-right float-end mt-1"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4 mb-3">
            <div class="card text-white bg-success h-100 border-0 shadow-sm" style="background-color: #27ae60 !important;">
                <div class="card-body pb-1">
                    <h4 class="fw-bold mb-1">THU NHẬP</h4>
                    <p class="fs-5">Xem lịch sử lương</p>
                    <i class="fas fa-money-bill-wave position-absolute" style="font-size: 4rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer border-0" style="background-color: #229954;">
                    <a href="../NhanVien/BangLuongCaNhan.aspx" class="text-white text-decoration-none w-100 d-block small">
                        Xem bảng lương của tôi <i class="fas fa-arrow-circle-right float-end mt-1"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4 mb-3">
            <div class="card text-white bg-success h-100 border-0 shadow-sm" style="background-color: #27ae60 !important;">
                <div class="card-body pb-1">
                    <h4 class="fw-bold mb-1">NGHỈ PHÉP</h4>
                    <p class="fs-5">Tạo đơn nghỉ phép</p>
                    <i class="fas fa-envelope-open-text position-absolute" style="font-size: 4rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer border-0" style="background-color: #229954;">
                    <a href="../Common/HopThuNghiPhep.aspx" class="text-white text-decoration-none w-100 d-block small">
                        Gửi đơn xin nghỉ phép <i class="fas fa-arrow-circle-right float-end mt-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
    <% } %>
</asp:Content>