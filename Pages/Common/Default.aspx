<%@ Page Title="Tổng quan" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="QLNhanVien.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-header d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
        <h3 class="fs-4 mb-0 fw-bold text-primary">Tổng quan</h3>
        <small class="text-muted">Đề tài thực tập | Quản lý nhân sự tại công ty</small>
    </div>

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
            <div class="card text-dark bg-warning h-100 border-0 shadow-sm">
                <div class="card-body">
                    <h2 class="fw-bold"><asp:Label ID="lblTongPhongBan" runat="server" Text="0"></asp:Label></h2>
                    <p class="mb-0 fs-5">Phòng ban</p>
                    <i class="fas fa-university position-absolute" style="font-size: 3rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer bg-warning border-0 text-center">
                    <a href="../Admin/DanhSachPhongBan.aspx" class="text-dark text-decoration-none small">Danh sách phòng ban <i class="fas fa-arrow-circle-right"></i></a>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-white bg-warning h-100 border-0 shadow-sm" style="background-color: #f39c12 !important;">
                <div class="card-body">
                    <h2 class="fw-bold"><asp:Label ID="lblTongTaiKhoan" runat="server" Text="0"></asp:Label></h2>
                    <p class="mb-0 fs-5">Tài khoản người dùng</p>
                    <i class="fas fa-user-plus position-absolute" style="font-size: 3rem; right: 20px; top: 20px; opacity: 0.3;"></i>
                </div>
                <div class="card-footer border-0 text-center" style="background-color: #d68910;">
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
</asp:Content>