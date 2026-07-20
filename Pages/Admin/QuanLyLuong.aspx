<%@ Page Title="Quản lý lương" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="QuanLyLuong.aspx.cs" Inherits="QLNhanVien.QuanLyLuong" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-header d-flex justify-content-between align-items-center mb-3 bg-light p-2 border-bottom">
        <h3 class="fs-4 mb-0 fw-normal">Quản lý bảng lương</h3>
    </div>

    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body bg-light">
            <div class="row align-items-end g-3">
                <div class="col-md-2">
                    <label class="form-label fw-bold">Tháng:</label>
                    <asp:DropDownList ID="ddlThang" runat="server" CssClass="form-select">
                        <asp:ListItem Value="1">Tháng 1</asp:ListItem>
                        <asp:ListItem Value="2">Tháng 2</asp:ListItem>
                        <asp:ListItem Value="3">Tháng 3</asp:ListItem>
                        <asp:ListItem Value="4">Tháng 4</asp:ListItem>
                        <asp:ListItem Value="5">Tháng 5</asp:ListItem>
                        <asp:ListItem Value="6">Tháng 6</asp:ListItem>
                        <asp:ListItem Value="7">Tháng 7</asp:ListItem>
                        <asp:ListItem Value="8">Tháng 8</asp:ListItem>
                        <asp:ListItem Value="9">Tháng 9</asp:ListItem>
                        <asp:ListItem Value="10">Tháng 10</asp:ListItem>
                        <asp:ListItem Value="11">Tháng 11</asp:ListItem>
                        <asp:ListItem Value="12">Tháng 12</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-bold">Năm:</label>
                    <asp:TextBox ID="txtNam" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold">Tìm kiếm:</label>
                    <asp:TextBox ID="txtSearchNV" runat="server" CssClass="form-control" placeholder="Tên hoặc mã NV..."></asp:TextBox>
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnXem" runat="server" Text="Tìm kiếm" CssClass="btn btn-secondary w-100" OnClick="btnXem_Click" />
                </div>
                <div class="col-md-3">
                    <asp:Button ID="btnTaoBangLuong" runat="server" Text="+ Khởi tạo lương tháng" CssClass="btn btn-success w-100" OnClick="btnTaoBangLuong_Click" OnClientClick="return confirm('Bạn có chắc muốn khởi tạo bảng lương cho tháng này không?');" />
                </div>
            </div>
        </div>
    </div>

    <asp:Label ID="lblMsg" runat="server" CssClass="mb-2 d-block" />

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <asp:GridView ID="gvLuong" runat="server" CssClass="table table-hover table-bordered align-middle mb-0" 
                AutoGenerateColumns="False" DataKeyNames="MaLuong" 
                OnRowEditing="gvLuong_RowEditing" OnRowCancelingEdit="gvLuong_RowCancelingEdit" OnRowUpdating="gvLuong_RowUpdating">
                <HeaderStyle CssClass="table-dark" />
                <Columns>
                    <asp:BoundField DataField="MaNV" HeaderText="MNV" ReadOnly="True" />
                    <asp:BoundField DataField="HoTen" HeaderText="Họ Tên" ReadOnly="True" />
                    <asp:BoundField DataField="TenPhongBan" HeaderText="Phòng Ban" ReadOnly="True" />
                    
                    <asp:BoundField DataField="LuongCoBan" HeaderText="Lương Căn Bản" ReadOnly="True" DataFormatString="{0:N0}" />
                    
                    <%-- CỘT MỚI: HỆ SỐ LƯƠNG ĐƯỢC LẤY TỪ BẢNG CHỨC VỤ --%>
                    <asp:BoundField DataField="HeSoLuong" HeaderText="Hệ số" ReadOnly="True" DataFormatString="{0:0.00}" ItemStyle-Font-Bold="true" ItemStyle-ForeColor="#e67e22" />
                    
                    <asp:TemplateField HeaderText="Thưởng">
                        <ItemTemplate><%# Eval("Thuong", "{0:N0}") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtThuong" runat="server" CssClass="form-control form-control-sm" Text='<%# Bind("Thuong") %>' TextMode="Number"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Phạt">
                        <ItemTemplate><%# Eval("Phat", "{0:N0}") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtPhat" runat="server" CssClass="form-control form-control-sm" Text='<%# Bind("Phat") %>' TextMode="Number"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="TongLuong" HeaderText="Thực Lĩnh" ReadOnly="True" DataFormatString="{0:N0}" ItemStyle-Font-Bold="true" ItemStyle-ForeColor="Blue" />

                    <asp:TemplateField HeaderText="Thanh toán">
                        <ItemTemplate>
                            <span class='badge <%# Convert.ToBoolean(Eval("DaThanhToan")) ? "bg-success" : "bg-warning text-dark" %>'>
                                <%# Convert.ToBoolean(Eval("DaThanhToan")) ? "Đã trả" : "Chưa trả" %>
                            </span>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:CheckBox ID="chkThanhToan" runat="server" Checked='<%# Bind("DaThanhToan") %>' /> Đã trả
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:CommandField ShowEditButton="True" HeaderText="Thao tác" ControlStyle-CssClass="btn btn-sm btn-primary" CancelText="Hủy" EditText="Sửa" UpdateText="Lưu" />
                </Columns>
                <EmptyDataTemplate>
                    <div class="text-center p-4 text-muted">
                        Chưa có dữ liệu bảng lương cho tháng này. Hãy nhấn "Khởi tạo lương tháng này".
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>