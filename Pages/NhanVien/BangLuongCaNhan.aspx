<%@ Page Title="Bảng lương của tôi" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="BangLuongCaNhan.aspx.cs" Inherits="QLNhanVien.BangLuongCaNhan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-header d-flex justify-content-between align-items-center mb-3 bg-light p-2 border-bottom">
        <h3 class="fs-4 mb-0 fw-normal">Thu nhập cá nhân</h3>
        <small class="text-muted"><i class="fas fa-wallet"></i> Trang cá nhân > Bảng lương của tôi</small>
    </div>

    <div class="content-body">
        <div class="card shadow-sm border-0 border-top border-success border-3">
            <div class="card-header bg-white p-3 d-flex justify-content-between align-items-center">
                <h5 class="mb-0 fw-bold text-success"><i class="fas fa-history me-2"></i>Lịch sử nhận lương</h5>
                <span class="text-muted small">Đơn vị tính: VNĐ</span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <asp:GridView ID="gvLuongCaNhan" runat="server" CssClass="table table-hover align-middle mb-0" 
                        AutoGenerateColumns="False" GridLines="None" BorderWidth="0">
                        <HeaderStyle CssClass="table-light" ForeColor="#333" Font-Bold="true" />
                        <Columns>
                            <asp:TemplateField HeaderText="Kỳ lương">
                                <ItemTemplate>
                                    <div class="fw-bold">Tháng <%# Eval("Thang") %> / <%# Eval("Nam") %></div>
                                </ItemTemplate>
                                <ItemStyle Width="150px" HorizontalAlign="Center" />
                            </asp:TemplateField>

                            <asp:BoundField DataField="LuongCoBan" HeaderText="Lương cơ bản" DataFormatString="{0:N0}" />
                            
                            <asp:TemplateField HeaderText="Thưởng">
                                <ItemTemplate>
                                    <span class="text-success">+<%# Eval("Thuong", "{0:N0}") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Khấu trừ / Phạt">
                                <ItemTemplate>
                                    <span class="text-danger">-<%# Eval("Phat", "{0:N0}") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Thực lĩnh">
                                <ItemTemplate>
                                    <div class="fw-bold text-primary fs-5">
                                        <%# Eval("TongLuong", "{0:N0}") %>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Trạng thái">
                                <ItemTemplate>
                                    <span class='badge rounded-pill px-3 py-2 <%# Convert.ToBoolean(Eval("DaThanhToan")) ? "bg-success" : "bg-warning text-dark" %>'>
                                        <%# Convert.ToBoolean(Eval("DaThanhToan")) ? "Đã thanh toán" : "Đang xử lý" %>
                                    </span>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="text-center p-5">
                                <i class="fas fa-receipt fa-3x text-light mb-3"></i>
                                <p class="text-muted">Chưa có dữ liệu lương cho tài khoản này.</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
            <div class="card-footer bg-white text-muted small">
                <i class="fas fa-info-circle me-1"></i> Ghi chú: Tổng lương thực lĩnh được tính theo công thức: 
                <strong>Tổng lương = (Lương cơ bản × Hệ số chức vụ) + Thưởng - Phạt</strong>
            </div>
        </div>
    </div>
</asp:Content>