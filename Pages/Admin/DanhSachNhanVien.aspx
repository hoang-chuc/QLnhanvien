<%@ Page Title="Danh sách nhân viên" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="DanhSachNhanVien.aspx.cs" Inherits="QLNhanVien.DanhSachNhanVienPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="content-header d-flex justify-content-between align-items-center mb-3 bg-light p-2 border-bottom">
        <h3 class="fs-4 mb-0 fw-normal">Quản lý nhân viên</h3>
        <small class="text-muted"><i class="fas fa-tachometer-alt"></i> Tổng quan > Nhân viên > Danh sách nhân viên</small>
    </div>

    <div class="content-body">
        <asp:MultiView ID="mvNhanVien" runat="server" ActiveViewIndex="0">
            
            <asp:View ID="vDanhSach" runat="server">
                <div class="box">
                    <div class="box-header bg-white border-bottom p-3 d-flex justify-content-between align-items-center">
                        <asp:LinkButton ID="btnShowThem" runat="server" CssClass="btn btn-primary btn-sm fw-bold" OnClick="btnShowThem_Click">
                            <i class="fas fa-plus-circle"></i> Thêm nhân viên
                        </asp:LinkButton>
                        
                        <div class="d-flex align-items-center">
                            <label class="me-2 fw-bold text-secondary">Search:</label>
                            <div class="input-group" style="width: 250px;">
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control form-control-sm" Placeholder="Nhập tên nhân viên..."></asp:TextBox>
                                <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-sm btn-secondary" OnClick="btnSearch_Click">
                                    <i class="fas fa-search"></i>
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>

                    <div class="box-body table-responsive p-3 bg-white">
                        <asp:GridView ID="gvNhanVien" runat="server" CssClass="table table-hover align-middle" AutoGenerateColumns="False" GridLines="Horizontal" BorderWidth="0" OnRowCommand="gvNhanVien_RowCommand" DataKeyNames="MaNV">
                            <HeaderStyle BackColor="#ffffff" ForeColor="#333" Font-Bold="true" BorderColor="#dee2e6" />
                            <Columns>
                                <asp:TemplateField HeaderText="STT">
                                    <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                </asp:TemplateField>
                                
                                <asp:TemplateField HeaderText="Mã NV">
                                    <ItemTemplate>MNV<%# Eval("MaNV") %></ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Ảnh">
                                    <ItemTemplate>
                                        <img src='<%# string.IsNullOrEmpty(Eval("AnhThe").ToString()) ? "https://ui-avatars.com/api/?name=" + Eval("HoTen") + "&background=random" : ResolveUrl(Eval("AnhThe").ToString()) %>' 
                                             alt="Ảnh" style="width: 40px; height: 50px; object-fit: cover; border-radius: 4px;" />
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:BoundField DataField="HoTen" HeaderText="Tên nhân viên" />
                                <asp:BoundField DataField="GioiTinh" HeaderText="Giới tính" />
                                <asp:BoundField DataField="NgaySinh" HeaderText="Ngày sinh" DataFormatString="{0:dd-MM-yyyy}" />
                                <asp:BoundField DataField="DiaChi" HeaderText="Nơi sinh" />
                                <asp:BoundField DataField="CCCD" HeaderText="Số CMND" />

                                <asp:TemplateField HeaderText="Tình trạng">
                                    <ItemTemplate>
                                        <span class='badge rounded-pill px-3 py-2 <%# Eval("TrangThai").ToString() == "Đã nghỉ việc" ? "bg-danger" : "bg-primary" %>'>
                                            <%# Eval("TrangThai") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Thao tác">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditNV" CommandArgument='<%# Eval("MaNV") %>' CssClass="btn btn-sm btn-outline-primary me-1" ToolTip="Sửa">
                                            <i class="fas fa-edit"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteNV" CommandArgument='<%# Eval("MaNV") %>' CssClass="btn btn-sm btn-outline-danger" ToolTip="Xóa" OnClientClick="return confirm('Toàn bộ dữ liệu lương, chấm công, tài khoản của nhân viên này sẽ bị xóa. Bạn có chắc chắn?');">
                                            <i class="fas fa-trash-alt"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </asp:View>

            <asp:View ID="vThaoTac" runat="server">
                <div class="box border-primary" style="border-top: 3px solid #0d6efd;">
                    <div class="box-header bg-white border-bottom p-3">
                        <h5 class="mb-0 fw-bold text-primary"><asp:Label ID="lblFormTitle" runat="server" Text="Thêm nhân viên mới"></asp:Label></h5>
                        <asp:HiddenField ID="hdfMaNV" runat="server" />
                    </div>
                    <div class="box-body p-4 bg-white">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtHoTen" runat="server" CssClass="form-control" required="true"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Ngày sinh</label>
                                <asp:TextBox ID="txtNgaySinh" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Giới tính</label>
                                <asp:DropDownList ID="ddlGioiTinh" runat="server" CssClass="form-select">
                                    <asp:ListItem>Nam</asp:ListItem>
                                    <asp:ListItem>Nữ</asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Số CMND/CCCD</label>
                                <asp:TextBox ID="txtCCCD" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Số điện thoại (Sẽ dùng làm Tài khoản)</label>
                                <asp:TextBox ID="txtSDT" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Email</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                            </div>

                            <div class="col-md-12">
                                <label class="form-label">Nơi sinh (Địa chỉ)</label>
                                <asp:TextBox ID="txtDiaChi" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Phòng ban</label>
                                <asp:DropDownList ID="ddlPhongBan" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Chức vụ</label>
                                <asp:DropDownList ID="ddlChucVu" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Lương cơ bản (VNĐ)</label>
                                <asp:TextBox ID="txtLuong" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Trạng thái</label>
                                <asp:DropDownList ID="ddlTrangThai" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="Đang làm">Đang làm việc</asp:ListItem>
                                    <asp:ListItem Value="Đã nghỉ việc">Đã nghỉ việc</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="mt-4 text-end">
                            <asp:Button ID="btnHuy" runat="server" Text="Hủy bỏ" CssClass="btn btn-secondary me-2" OnClick="btnHuy_Click" formnovalidate="formnovalidate" />
                            <asp:Button ID="btnLuu" runat="server" Text="Lưu thông tin" CssClass="btn btn-primary px-4" OnClick="btnLuu_Click" />
                        </div>
                    </div>
                </div>
            </asp:View>

        </asp:MultiView>
    </div>
</asp:Content>