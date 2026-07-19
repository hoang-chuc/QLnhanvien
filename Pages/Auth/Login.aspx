<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="QLNhanVien.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Hệ thống Quản lý Nhân viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="../Assets/CSS/style.css" rel="stylesheet" />
</head>
<body class="login-body">
    <form id="form1" runat="server">
        <div class="container login-container">
            <div class="card shadow">
                <div class="card-body p-4">
                    
                    <%-- THÔNG BÁO CHUNG --%>
                    <asp:Label ID="lblMessage" runat="server" CssClass="mb-3 d-block text-center fw-bold"></asp:Label>

                    <asp:MultiView ID="mvAuth" runat="server" ActiveViewIndex="0">
                        
                        <%-- ================= VIEW 0: ĐĂNG NHẬP ================= --%>
                        <asp:View ID="vLogin" runat="server">
                            <h3 class="text-center mb-4 text-primary fw-bold">ĐĂNG NHẬP</h3>
                            <div class="mb-3">
                                <label class="form-label">Tên đăng nhập</label>
                                <asp:TextBox ID="txtLoginUsername" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mật khẩu</label>
                                <asp:TextBox ID="txtLoginPassword" runat="server" CssClass="form-control" TextMode="Password" required="required"></asp:TextBox>
                            </div>
                            <asp:Button ID="btnLogin" runat="server" Text="Đăng nhập" CssClass="btn btn-primary w-100 mb-3" OnClick="btnLogin_Click" />
                            <div class="d-flex justify-content-between">
                                <asp:LinkButton ID="btnGoToRegister" runat="server" CssClass="text-decoration-none" CausesValidation="false" OnClick="btnGoToRegister_Click">Đăng ký mới</asp:LinkButton>
                                <asp:LinkButton ID="btnGoToForgot" runat="server" CssClass="text-decoration-none text-danger" CausesValidation="false" OnClick="btnGoToForgot_Click">Quên mật khẩu?</asp:LinkButton>
                            </div>
                        </asp:View>

                        <%-- ================= VIEW 1: ĐĂNG KÝ ================= --%>
                        <asp:View ID="vRegister" runat="server">
                            <h3 class="text-center mb-4 text-success fw-bold">ĐĂNG KÝ</h3>
                            <div class="mb-3">
                                <label class="form-label">Họ và tên nhân viên</label>
                                <asp:TextBox ID="txtRegFullName" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Tên đăng nhập mới</label>
                                <asp:TextBox ID="txtRegUsername" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mật khẩu</label>
                                <asp:TextBox ID="txtRegPassword" runat="server" CssClass="form-control" TextMode="Password" required="required"></asp:TextBox>
                            </div>
                            <asp:Button ID="btnRegister" runat="server" Text="Tạo tài khoản" CssClass="btn btn-success w-100 mb-3" OnClick="btnRegister_Click" />
                            <div class="text-center">
                                <asp:LinkButton ID="btnBackToLogin1" runat="server" CssClass="text-decoration-none" CausesValidation="false" OnClick="btnBackToLogin_Click">Đã có tài khoản? Đăng nhập</asp:LinkButton>
                            </div>
                        </asp:View>

                        <%-- ================= VIEW 2: QUÊN MẬT KHẨU ================= --%>
                        <asp:View ID="vForgot" runat="server">
                            <h3 class="text-center mb-4 text-danger fw-bold">ĐẶT LẠI MẬT KHẨU</h3>
                            <div class="mb-3">
                                <label class="form-label">Tên đăng nhập</label>
                                <asp:TextBox ID="txtForgotUsername" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Số Căn cước công dân (CCCD)</label>
                                <asp:TextBox ID="txtForgotCCCD" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Số điện thoại</label>
                                <asp:TextBox ID="txtForgotSDT" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mật khẩu mới</label>
                                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" required="required"></asp:TextBox>
                            </div>
                            <asp:Button ID="btnResetPass" runat="server" Text="Cập nhật mật khẩu" CssClass="btn btn-danger w-100 mb-3" OnClick="btnResetPass_Click" />
                            <div class="text-center">
                                <asp:LinkButton ID="btnBackToLogin2" runat="server" CssClass="text-decoration-none" CausesValidation="false" OnClick="btnBackToLogin_Click">Quay lại đăng nhập</asp:LinkButton>
                            </div>
                        </asp:View>

                    </asp:MultiView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>