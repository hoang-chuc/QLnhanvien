<%@ Page Title="Phòng ban & Chức vụ" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="DanhSachPhongBan.aspx.cs" Inherits="QLNhanVien.DanhSachPhongBan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-header d-flex justify-content-between align-items-center mb-3 bg-light p-2 border-bottom">
        <h3 class="fs-4 mb-0 fw-normal">Phòng ban & Chức vụ</h3>
        <small class="text-muted"><i class="fas fa-tachometer-alt"></i> Hệ thống > Phòng ban & Chức vụ</small>
        <div class="d-flex align-items-center">
            <label class="me-2 fw-bold text-secondary">Search:</label>
            <div class="input-group" style="width: 250px;">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control form-control-sm" Placeholder="Nhập tên phòng ban/chức vụ..." onkeyup="debounceSearch()"></asp:TextBox>
                <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-sm btn-secondary" OnClick="btnSearch_Click">
                    <i class="fas fa-search"></i>
                </asp:LinkButton>
            </div>
        </div>
    </div>

    <div class="content-body">
        <div class="row">
            <div class="col-md-6 mb-4">
                <div class="box border-warning" style="border-top: 3px solid #ffc107;">
                    <div class="box-header bg-white border-bottom p-3">
                        <h5 class="mb-0 fw-bold text-warning"><i class="fas fa-university"></i> Danh sách phòng ban</h5>
                    </div>
                    <div class="box-body table-responsive p-3 bg-white">
                        <asp:GridView ID="gvPhongBan" runat="server" CssClass="table table-hover table-bordered text-center align-middle" AutoGenerateColumns="False">
                            <HeaderStyle BackColor="#f8f9fa" />
                            <Columns>
                                <asp:BoundField DataField="MaPB" HeaderText="Mã PB" />
                                <asp:BoundField DataField="TenPhongBan" HeaderText="Tên phòng" />
                                <asp:BoundField DataField="MoTa" HeaderText="Mô tả" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="box border-info" style="border-top: 3px solid #17a2b8;">
                    <div class="box-header bg-white border-bottom p-3">
                        <h5 class="mb-0 fw-bold text-info"><i class="fas fa-briefcase"></i> Danh sách chức vụ</h5>
                    </div>
                    <div class="box-body table-responsive p-3 bg-white">
                        <asp:GridView ID="gvChucVu" runat="server" CssClass="table table-hover table-bordered text-center align-middle" AutoGenerateColumns="False">
                            <HeaderStyle BackColor="#f8f9fa" />
                            <Columns>
                                <asp:BoundField DataField="MaCV" HeaderText="Mã CV" />
                                <asp:BoundField DataField="TenChucVu" HeaderText="Tên chức vụ" />
                                <asp:BoundField DataField="HeSoLuong" HeaderText="Hệ số lương" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
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