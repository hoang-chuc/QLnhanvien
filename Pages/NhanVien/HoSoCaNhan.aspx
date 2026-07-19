<%@ Page Title="Hồ sơ cá nhân" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="HoSoCaNhan.aspx.cs" Inherits="QLNhanVien.HoSoCaNhan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-header d-flex justify-content-between align-items-center mb-3 bg-light p-2 border-bottom">
        <h3 class="fs-4 mb-0 fw-normal">Thông tin tài khoản</h3>
        <small class="text-muted"><i class="fas fa-user-circle"></i> Trang cá nhân > Hồ sơ nhân viên</small>
    </div>

    <div class="content-body">
        <div class="row">
            <div class="col-md-4">
                <div class="card shadow-sm border-0 mb-4 text-center p-4">
                    <div class="card-body">
                        <asp:Image ID="imgAvatar" runat="server" CssClass="rounded-circle img-thumbnail mb-3 shadow-sm" style="width: 150px; height: 150px; object-fit: cover;" />
                        <h4 class="fw-bold text-dark"><asp:Label ID="lblHoTenTitle" runat="server" /></h4>
                        <p class="text-muted mb-0"><asp:Label ID="lblChucVuTitle" runat="server" /></p>
                        <hr />
                        <div class="d-grid">
                            <button type="button" class="btn btn-outline-primary btn-sm"><i class="fas fa-camera"></i> Đổi ảnh đại diện</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card shadow-sm border-0 border-top border-primary border-3">
                    <div class="card-header bg-white p-3">
                        <h5 class="mb-0 fw-bold"><i class="fas fa-info-circle me-2 text-primary"></i>Thông tin chi tiết</h5>
                    </div>
                    <div class="card-body p-4">
                        <div class="row mb-3">
                            <div class="col-sm-4 fw-bold text-secondary">Mã nhân viên:</div>
                            <div class="col-sm-8 text-dark fw-bold text-primary">MNV<asp:Label ID="lblMaNV" runat="server" /></div>
                        </div>
                        <div class="row mb-3 border-top pt-2">
                            <div class="col-sm-4 fw-bold text-secondary">Họ và tên:</div>
                            <div class="col-sm-8"><asp:Label ID="lblHoTen" runat="server" /></div>
                        </div>
                        <div class="row mb-3 border-top pt-2">
                            <div class="col-sm-4 fw-bold text-secondary">Ngày sinh:</div>
                            <div class="col-sm-8"><asp:Label ID="lblNgaySinh" runat="server" /></div>
                        </div>
                        <div class="row mb-3 border-top pt-2">
                            <div class="col-sm-4 fw-bold text-secondary">Giới tính:</div>
                            <div class="col-sm-8"><asp:Label ID="lblGioiTinh" runat="server" /></div>
                        </div>
                        <div class="row mb-3 border-top pt-2">
                            <div class="col-sm-4 fw-bold text-secondary">Số CMND/CCCD:</div>
                            <div class="col-sm-8"><asp:Label ID="lblCCCD" runat="server" /></div>
                        </div>
                        <div class="row mb-3 border-top pt-2">
                            <div class="col-sm-4 fw-bold text-secondary">Phòng ban:</div>
                            <div class="col-sm-8"><asp:Label ID="lblPhongBan" runat="server" /></div>
                        </div>
                        <div class="row mb-3 border-top pt-2">
                            <div class="col-sm-4 fw-bold text-secondary">Chức vụ:</div>
                            <div class="col-sm-8"><asp:Label ID="lblChucVu" runat="server" /></div>
                        </div>
                        <div class="row mb-3 border-top pt-2">
                            <div class="col-sm-4 fw-bold text-secondary">Số điện thoại:</div>
                            <div class="col-sm-8"><asp:Label ID="lblSDT" runat="server" /></div>
                        </div>
                        <div class="row mb-3 border-top pt-2">
                            <div class="col-sm-4 fw-bold text-secondary">Email liên hệ:</div>
                            <div class="col-sm-8"><asp:Label ID="lblEmail" runat="server" /></div>
                        </div>
                        <div class="row mb-3 border-top pt-2">
                            <div class="col-sm-4 fw-bold text-secondary">Địa chỉ thường trú:</div>
                            <div class="col-sm-8"><asp:Label ID="lblDiaChi" runat="server" /></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>