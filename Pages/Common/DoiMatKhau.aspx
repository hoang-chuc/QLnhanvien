<%@ Page Title="Đổi mật khẩu" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="DoiMatKhau.aspx.cs" Inherits="QLNhanVien.DoiMatKhau" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-header d-flex justify-content-between align-items-center mb-3 bg-light p-2 border-bottom">
        <h3 class="fs-4 mb-0 fw-normal">Đổi mật khẩu tài khoản</h3>
        <small class="text-muted"><i class="fas fa-key"></i> Tài khoản > Đổi mật khẩu</small>
    </div>

    <div class="content-body d-flex justify-content-center">
        <div class="card shadow-sm border-0 border-top border-warning border-3" style="width: 100%; max-width: 500px;">
            <div class="card-header bg-white p-3">
                <h5 class="mb-0 fw-bold text-warning"><i class="fas fa-lock me-2"></i>Thiết lập mật khẩu mới</h5>
            </div>
            <div class="card-body p-4">
                <asp:Label ID="lblMsg" runat="server" CssClass="mb-3 d-block" />

                <div class="mb-3">
                    <label class="form-label fw-bold">Mật khẩu hiện tại <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtOldPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Nhập mật khẩu hiện tại..."></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Mật khẩu mới <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Tối thiểu 6 ký tự..."></asp:TextBox>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Nhập lại mật khẩu mới..."></asp:TextBox>
                </div>

                <div class="d-grid gap-2">
                    <asp:Button ID="btnSubmit" runat="server" Text="Cập nhật mật khẩu" CssClass="btn btn-warning" OnClick="btnSubmit_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
