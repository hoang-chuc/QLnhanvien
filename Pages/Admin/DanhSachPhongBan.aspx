<%@ Page Title="Phòng ban & Chức vụ" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="DanhSachPhongBan.aspx.cs" Inherits="QLNhanVien.DanhSachPhongBan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-header d-flex justify-content-between align-items-center mb-3 bg-light p-2 border-bottom">
        <h3 class="fs-4 mb-0 fw-normal">Phòng ban &amp; Chức vụ</h3>
        <small class="text-muted"><i class="fas fa-tachometer-alt"></i> Hệ thống &gt; Phòng ban &amp; Chức vụ</small>
    </div>

    <asp:Label ID="lblMsg" runat="server" CssClass="mb-2 d-block" />

    <div class="content-body">
        <div class="row">
            <%-- ========== PHÒNG BAN ========== --%>
            <div class="col-md-6 mb-4">
                <div class="box border-warning" style="border-top: 3px solid #ffc107;">
                    <div class="box-header bg-white border-bottom p-3 d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 fw-bold text-warning"><i class="fas fa-university"></i> Danh sách phòng ban</h5>
                        <asp:Button ID="btnShowAddPB" runat="server" Text="+ Thêm phòng ban" CssClass="btn btn-sm btn-warning" OnClick="btnShowAddPB_Click" />
                    </div>

                    <%-- Form thêm/sửa Phòng ban --%>
                    <asp:Panel ID="pnlFormPB" runat="server" Visible="false" CssClass="p-3 border-bottom bg-light">
                        <h6 class="fw-bold text-warning mb-3"><asp:Label ID="lblFormTitlePB" runat="server" Text="Thêm phòng ban mới" /></h6>
                        <asp:HiddenField ID="hdfMaPB" runat="server" />
                        <div class="mb-2">
                            <label class="form-label fw-bold">Tên phòng ban <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtTenPB" runat="server" CssClass="form-control form-control-sm" placeholder="Nhập tên phòng ban..." />
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Mô tả</label>
                            <asp:TextBox ID="txtMoTaPB" runat="server" CssClass="form-control form-control-sm" TextMode="MultiLine" Rows="2" placeholder="Mô tả ngắn về phòng ban..." />
                        </div>
                        <div class="d-flex gap-2">
                            <asp:Button ID="btnLuuPB" runat="server" Text="Lưu" CssClass="btn btn-warning btn-sm" OnClick="btnLuuPB_Click" />
                            <asp:Button ID="btnHuyPB" runat="server" Text="Hủy" CssClass="btn btn-secondary btn-sm" OnClick="btnHuyPB_Click" CausesValidation="false" />
                        </div>
                    </asp:Panel>

                    <div class="box-body table-responsive p-3 bg-white">
                        <asp:GridView ID="gvPhongBan" runat="server" CssClass="table table-hover table-bordered text-center align-middle" AutoGenerateColumns="False" DataKeyNames="MaPB" OnRowCommand="gvPhongBan_RowCommand">
                            <HeaderStyle BackColor="#f8f9fa" />
                            <Columns>
                                <asp:BoundField DataField="MaPB" HeaderText="Mã" ItemStyle-Width="50px" />
                                <asp:BoundField DataField="TenPhongBan" HeaderText="Tên phòng" ItemStyle-HorizontalAlign="Left" />
                                <asp:BoundField DataField="MoTa" HeaderText="Mô tả" ItemStyle-HorizontalAlign="Left" />
                                <asp:TemplateField HeaderText="Thao tác" ItemStyle-Width="110px">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" CommandName="SuaPB" CommandArgument='<%# Eval("MaPB") %>' CssClass="btn btn-warning btn-sm me-1"><i class="fas fa-edit"></i></asp:LinkButton>
                                        <asp:LinkButton runat="server" CommandName="XoaPB" CommandArgument='<%# Eval("MaPB") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Xóa phòng ban này? Đảm bảo không còn nhân viên trong phòng!');"><i class="fas fa-trash"></i></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate><div class="p-3 text-center text-muted">Chưa có phòng ban nào.</div></EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <%-- ========== CHỨC VỤ ========== --%>
            <div class="col-md-6 mb-4">
                <div class="box border-info" style="border-top: 3px solid #17a2b8;">
                    <div class="box-header bg-white border-bottom p-3 d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 fw-bold text-info"><i class="fas fa-briefcase"></i> Danh sách chức vụ</h5>
                        <asp:Button ID="btnShowAddCV" runat="server" Text="+ Thêm chức vụ" CssClass="btn btn-sm btn-info text-white" OnClick="btnShowAddCV_Click" />
                    </div>

                    <%-- Form thêm/sửa Chức vụ --%>
                    <asp:Panel ID="pnlFormCV" runat="server" Visible="false" CssClass="p-3 border-bottom bg-light">
                        <h6 class="fw-bold text-info mb-3"><asp:Label ID="lblFormTitleCV" runat="server" Text="Thêm chức vụ mới" /></h6>
                        <asp:HiddenField ID="hdfMaCV" runat="server" />
                        <div class="mb-2">
                            <label class="form-label fw-bold">Tên chức vụ <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtTenCV" runat="server" CssClass="form-control form-control-sm" placeholder="Nhập tên chức vụ..." />
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Hệ số lương <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtHeSoLuong" runat="server" CssClass="form-control form-control-sm" placeholder="VD: 1.0, 1.5, 2.0..." />
                            <small class="text-muted">Lương thực nhận = Lương cơ bản × Hệ số</small>
                        </div>
                        <div class="d-flex gap-2">
                            <asp:Button ID="btnLuuCV" runat="server" Text="Lưu" CssClass="btn btn-info btn-sm text-white" OnClick="btnLuuCV_Click" />
                            <asp:Button ID="btnHuyCV" runat="server" Text="Hủy" CssClass="btn btn-secondary btn-sm" OnClick="btnHuyCV_Click" CausesValidation="false" />
                        </div>
                    </asp:Panel>

                    <div class="box-body table-responsive p-3 bg-white">
                        <asp:GridView ID="gvChucVu" runat="server" CssClass="table table-hover table-bordered text-center align-middle" AutoGenerateColumns="False" DataKeyNames="MaCV" OnRowCommand="gvChucVu_RowCommand">
                            <HeaderStyle BackColor="#f8f9fa" />
                            <Columns>
                                <asp:BoundField DataField="MaCV" HeaderText="Mã" ItemStyle-Width="50px" />
                                <asp:BoundField DataField="TenChucVu" HeaderText="Tên chức vụ" ItemStyle-HorizontalAlign="Left" />
                                <asp:BoundField DataField="HeSoLuong" HeaderText="Hệ số lương" DataFormatString="{0:N2}" />
                                <asp:TemplateField HeaderText="Thao tác" ItemStyle-Width="110px">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" CommandName="SuaCV" CommandArgument='<%# Eval("MaCV") %>' CssClass="btn btn-info btn-sm me-1 text-white"><i class="fas fa-edit"></i></asp:LinkButton>
                                        <asp:LinkButton runat="server" CommandName="XoaCV" CommandArgument='<%# Eval("MaCV") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Xóa chức vụ này?');"><i class="fas fa-trash"></i></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate><div class="p-3 text-center text-muted">Chưa có chức vụ nào.</div></EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>