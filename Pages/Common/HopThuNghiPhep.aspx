<%@ Page Title="Hộp thư nghỉ phép" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="HopThuNghiPhep.aspx.cs" Inherits="QLNhanVien.HopThuNghiPhep" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-header d-flex justify-content-between align-items-center mb-3 bg-light p-2 border-bottom">
        <h3 class="fs-4 mb-0 fw-normal">Hộp thư nghỉ phép</h3>
    </div>

    <div class="content-body">
        <asp:MultiView ID="mvHopThu" runat="server">
            
            <asp:View ID="vNhanVien" runat="server">
                <div class="card shadow-sm border-primary" style="max-width: 600px; margin: 0 auto;">
                    <div class="card-header bg-white">
                        <h5 class="mb-0 text-primary"><i class="fas fa-paper-plane me-2"></i>Gửi đơn xin nghỉ phép</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Từ ngày:</label>
                            <asp:TextBox ID="txtTuNgay" runat="server" CssClass="form-control" TextMode="Date" required="true"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Đến ngày:</label>
                            <asp:TextBox ID="txtDenNgay" runat="server" CssClass="form-control" TextMode="Date" required="true"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Lý do nghỉ:</label>
                            <asp:TextBox ID="txtLyDo" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" required="true" Placeholder="Nhập chi tiết lý do xin nghỉ..."></asp:TextBox>
                        </div>
                        <div class="text-end">
                            <asp:Button ID="btnGuiDon" runat="server" Text="Gửi cho Quản lý" CssClass="btn btn-primary" OnClick="btnGuiDon_Click" />
                        </div>
                    </div>
                </div>
            </asp:View>

            <asp:View ID="vAdminList" runat="server">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white">
                        <h5 class="mb-0"><i class="fas fa-inbox me-2"></i>Hộp thư đến (Đơn xin nghỉ)</h5>
                    </div>
                    <div class="card-body p-0">
                        <asp:GridView ID="gvDonNghi" runat="server" CssClass="table table-hover align-middle mb-0" AutoGenerateColumns="False" GridLines="None" OnRowCommand="gvDonNghi_RowCommand">
                            <HeaderStyle CssClass="table-light" />
                            <Columns>
                                <asp:BoundField DataField="HoTen" HeaderText="Người gửi" ItemStyle-Font-Bold="true" />
                                <asp:BoundField DataField="NgayTao" HeaderText="Thời gian gửi" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                                <asp:BoundField DataField="LyDo" HeaderText="Lý do" />
                                <asp:TemplateField HeaderText="Trạng thái">
                                    <ItemTemplate>
                                        <span class='badge <%# Eval("TrangThai").ToString() == "Chờ duyệt" ? "bg-warning text-dark" : (Eval("TrangThai").ToString() == "Đã duyệt" ? "bg-success" : "bg-danger") %>'>
                                            <%# Eval("TrangThai") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnXem" runat="server" CommandName="XemChiTiet" CommandArgument='<%# Eval("MaDon") %>' CssClass="btn btn-sm btn-outline-primary">
                                            Xem chi tiết
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="p-4 text-center text-muted">Không có tin nhắn nào.</div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </asp:View>

            <asp:View ID="vAdminDetail" runat="server">
                <div class="card shadow-sm border-info" style="max-width: 600px; margin: 0 auto;">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 text-info"><i class="fas fa-envelope-open-text me-2"></i>Chi tiết đơn nghỉ phép</h5>
                        <asp:LinkButton ID="btnBack" runat="server" CssClass="btn btn-sm btn-secondary" OnClick="btnBack_Click"><i class="fas fa-arrow-left"></i> Quay lại</asp:LinkButton>
                    </div>
                    <div class="card-body">
                        <asp:HiddenField ID="hdfMaDon" runat="server" />
                        <table class="table table-borderless">
                            <tr><th style="width: 150px;">Người gửi:</th><td><asp:Label ID="lblChiTietNguoiGui" runat="server" Font-Bold="true" ForeColor="Blue" /></td></tr>
                            <tr><th>Thời gian nghỉ:</th><td><asp:Label ID="lblChiTietThoiGian" runat="server" /></td></tr>
                            <tr><th>Số ngày:</th><td><span class="badge bg-secondary"><asp:Label ID="lblChiTietSoNgay" runat="server" /> ngày</span></td></tr>
                            <tr><th>Lý do:</th><td><div class="p-2 bg-light border rounded"><asp:Label ID="lblChiTietLyDo" runat="server" /></div></td></tr>
                        </table>
                        <hr />
                        <div class="d-flex justify-content-center gap-3">
                            <asp:Button ID="btnChapNhan" runat="server" Text="Chấp nhận" CssClass="btn btn-success px-4" OnClick="btnChapNhan_Click" />
                            <asp:Button ID="btnTuChoi" runat="server" Text="Từ chối" CssClass="btn btn-danger px-4" OnClick="btnTuChoi_Click" />
                            <asp:Button ID="btnChoDuyet" runat="server" Text="Chờ duyệt sau" CssClass="btn btn-warning px-4" OnClick="btnChoDuyet_Click" />
                        </div>
                    </div>
                </div>
            </asp:View>

        </asp:MultiView>
    </div>
</asp:Content>