<%@ Page Title="Danh sách tài khoản" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="DanhSachTaiKhoan.aspx.cs" Inherits="QLNhanVien.DanhSachTaiKhoan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="content-header d-flex justify-content-between align-items-center mb-3 bg-light p-2 border-bottom">
        <h3 class="fs-4 mb-0 fw-normal">Tài khoản hệ thống</h3>
        <small class="text-muted"><i class="fas fa-tachometer-alt"></i> Tổng quan > Hệ thống > Danh sách tài khoản</small>
    </div>

    <div class="content-body">
        <div class="box border-danger" style="border-top: 3px solid #dc3545;">
            <div class="box-header bg-white border-bottom p-3 d-flex justify-content-between align-items-center">
                <h5 class="mb-0 text-danger fw-bold"><i class="fas fa-lock"></i> Khu vực bảo mật (Chỉ Admin)</h5>
                <div class="d-flex align-items-center">
                    <label class="me-2 fw-bold text-secondary">Search:</label>
                    <div class="input-group" style="width: 250px;">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control form-control-sm" Placeholder="Nhập tên đăng nhập..." onkeyup="debounceSearch()"></asp:TextBox>
                        <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-sm btn-secondary" OnClick="btnSearch_Click">
                            <i class="fas fa-search"></i>
                        </asp:LinkButton>
                    </div>
                </div>
            </div>

            <div class="box-body table-responsive p-3 bg-white">
                <asp:GridView ID="gvTaiKhoan" runat="server" CssClass="table table-hover align-middle table-bordered" AutoGenerateColumns="False">
                    <HeaderStyle BackColor="#f8f9fa" ForeColor="#333" Font-Bold="true" />
                    <Columns>
                        <asp:TemplateField HeaderText="STT">
                            <ItemTemplate>
                                <%# Container.DataItemIndex + 1 %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" Width="50px" />
                        </asp:TemplateField>

                        <asp:BoundField DataField="Username" HeaderText="Tên đăng nhập (Username)" ItemStyle-Font-Bold="true" />
                        
                        <asp:TemplateField HeaderText="Mật khẩu">
                            <ItemTemplate>
                                <span class="text-danger fw-bold"><%# Eval("PasswordHash") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="TenNhanVien" HeaderText="Chủ sở hữu" />
                        
                        <asp:TemplateField HeaderText="Quyền hạn (Role)">
                            <ItemTemplate>
                                <span class='badge rounded-pill px-3 py-2 
                                    <%# Eval("Role").ToString() == "Admin" ? "bg-danger" : 
                                        Eval("Role").ToString() == "QuanLy" ? "bg-warning text-dark" : "bg-info text-dark" %>'>
                                    <%# Eval("Role") %>
                                </span>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Trạng thái">
                            <ItemTemplate>
                                <span class='badge <%# Convert.ToBoolean(Eval("TrangThai")) ? "bg-success" : "bg-secondary" %>'>
                                    <%# Convert.ToBoolean(Eval("TrangThai")) ? "Đang hoạt động" : "Đã khóa" %>
                                </span>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        
                        <asp:BoundField DataField="NgayTao" HeaderText="Ngày tạo" DataFormatString="{0:dd-MM-yyyy HH:mm}" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        var searchTimer = null;
        function debounceSearch() {
            if (searchTimer) clearTimeout(searchTimer);
            searchTimer = setTimeout(function () {
                __doPostBack('<%= btnSearch.UniqueID %>', '');
            }, 500);
        }
    </script>
</asp:Content>