<%@ Page Title="Quản lý công tác & Nghỉ phép" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="QuanLyCongTac.aspx.cs" Inherits="QLNhanVien.QuanLyCongTacPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="content-header d-flex justify-content-between align-items-center mb-3 bg-light p-2 border-bottom">
        <h3 class="fs-4 mb-0 fw-normal">Lịch sử nghỉ phép</h3>
        <small class="text-muted"><i class="fas fa-tachometer-alt"></i> Tổng quan > Quản lý công tác > Lịch sử nghỉ phép</small>
    </div>

    <div class="content-body">
        <div class="box border-primary" style="border-top: 3px solid #0d6efd;">
            <div class="box-header bg-white border-bottom p-3 d-flex justify-content-between align-items-center">
                <h5 class="mb-0 text-muted">Danh sách đơn xin nghỉ phép</h5>
                
                <div class="d-flex align-items-center">
                    <label class="me-2 fw-bold text-secondary">Lọc trạng thái:</label>
                    <asp:DropDownList ID="ddlFilterTrangThai" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="ddlFilterTrangThai_SelectedIndexChanged" style="width: 150px;">
                        <asp:ListItem Value="Tất cả">-- Tất cả --</asp:ListItem>
                        <asp:ListItem Value="Chờ duyệt">Chờ duyệt</asp:ListItem>
                        <asp:ListItem Value="Đã duyệt">Đã duyệt</asp:ListItem>
                        <asp:ListItem Value="Từ chối">Từ chối</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <div class="box-body table-responsive p-3 bg-white">
                <asp:GridView ID="gvNghiPhep" runat="server" CssClass="table table-hover align-middle" AutoGenerateColumns="False" GridLines="Horizontal" BorderWidth="0">
                    <HeaderStyle BackColor="#f8f9fa" ForeColor="#333" Font-Bold="true" BorderColor="#dee2e6" />
                    <Columns>
                        <asp:TemplateField HeaderText="STT">
                            <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Nhân viên">
                            <ItemTemplate>
                                <div class="d-flex align-items-center">
                                    <div class="fw-bold text-primary"><%# Eval("HoTen") %></div>
                                    <div class="ms-2 text-muted small">(MNV<%# Eval("MaNV") %>)</div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="NgayBatDau" HeaderText="Từ ngày" DataFormatString="{0:dd-MM-yyyy}" />
                        <asp:BoundField DataField="NgayKetThuc" HeaderText="Đến ngày" DataFormatString="{0:dd-MM-yyyy}" />
                        
                        <asp:TemplateField HeaderText="Số ngày">
                            <ItemTemplate>
                                <span class="badge bg-secondary"><%# Eval("SoNgay") %> ngày</span>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                        <asp:BoundField DataField="LyDo" HeaderText="Lý do nghỉ" />

                        <asp:TemplateField HeaderText="Trạng thái">
                            <ItemTemplate>
                                <span class='badge <%# 
                                    Eval("TrangThai").ToString() == "Chờ duyệt" ? "bg-warning text-dark" : 
                                    Eval("TrangThai").ToString() == "Đã duyệt" ? "bg-success" : "bg-danger" %>'>
                                    <%# Eval("TrangThai") %>
                                </span>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                        <asp:BoundField DataField="NgayTao" HeaderText="Ngày gửi đơn" DataFormatString="{0:dd-MM-yyyy HH:mm}" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center p-4 text-muted">Không có dữ liệu đơn xin nghỉ nào.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>