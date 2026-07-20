<%@ Page Title="Thống kê báo cáo" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="ThongKe.aspx.cs" Inherits="QLNhanVien.ThongKe" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <div class="content-header d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
        <h3 class="fs-4 mb-0 fw-bold text-primary">Biểu đồ thống kê</h3>
    </div>

    <div class="row g-4">
        <div class="col-md-6">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-header bg-white border-bottom-0 pt-3 pb-0">
                    <h5 class="fw-bold text-dark"><i class="fas fa-users me-2 text-info"></i>Phân bổ lao động theo phòng ban</h5>
                </div>
                <div class="card-body d-flex justify-content-center">
                    <div style="position: relative; width: 100%; max-width: 400px; height: 320px;">
                        <canvas id="chartNhanVien"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-header bg-white border-bottom-0 pt-3 pb-0">
                    <h5 class="fw-bold text-dark"><i class="fas fa-envelope-open-text me-2 text-warning"></i>Trạng thái duyệt nghỉ phép</h5>
                </div>
                <div class="card-body d-flex justify-content-center">
                    <div style="position: relative; width: 100%; max-width: 400px; height: 320px;">
                        <canvas id="chartNghiPhep"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-12">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-header bg-white border-bottom-0 pt-3 pb-0 d-flex justify-content-between align-items-center">
                    <h5 class="fw-bold text-dark"><i class="fas fa-money-bill-wave me-2 text-success"></i>Phân tích quỹ lương theo phòng ban (Tháng hiện tại)</h5>
                </div>
                <div class="card-body">
                    <div style="width: 100%; height: 350px;">
                        <canvas id="chartQuyLuong"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            
            // 1. Biểu đồ Phân bổ nhân viên (Pie)
            const ctxNV = document.getElementById('chartNhanVien').getContext('2d');
            new Chart(ctxNV, {
                type: 'pie',
                data: {
                    labels: <%= LabelsPhongBan %>,
                    datasets: [{
                        data: <%= DataNhanVien %>,
                        backgroundColor: ['#3498db', '#2ecc71', '#f1c40f', '#e74c3c', '#9b59b6', '#34495e'],
                        borderWidth: 1
                    }]
                },
                options: { responsive: true, maintainAspectRatio: false }
            });

            // 2. Biểu đồ Trạng thái nghỉ phép (Doughnut)
            const ctxNP = document.getElementById('chartNghiPhep').getContext('2d');
            new Chart(ctxNP, {
                type: 'doughnut',
                data: {
                    labels: <%= LabelsNghiPhep %>,
                    datasets: [{
                        data: <%= DataNghiPhep %>,
                        backgroundColor: ['#f39c12', '#27ae60', '#e74c3c'], // Vàng (Chờ), Xanh (Duyệt), Đỏ (Từ chối)
                        borderWidth: 1
                    }]
                },
                options: { responsive: true, maintainAspectRatio: false }
            });

            // 3. Biểu đồ Quỹ lương (Bar)
            const ctxLuong = document.getElementById('chartQuyLuong').getContext('2d');
            new Chart(ctxLuong, {
                type: 'bar',
                data: {
                    labels: <%= LabelsPhongBan %>,
                    datasets: [{
                        label: 'Tổng quỹ lương (VNĐ)',
                        data: <%= DataQuyLuong %>,
                        backgroundColor: '#27ae60',
                        borderRadius: 4
                    }]
                },
                options: {
                    responsive: true, 
                    maintainAspectRatio: false,
                    scales: {
                        y: { beginAtZero: true }
                    }
                }
            });
        });
    </script>
</asp:Content>