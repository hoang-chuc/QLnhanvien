# QLNhanVien - Hệ thống Quản lý Nhân sự

> Đề tài thực tập: Quản lý nhân sự tại công ty

## Công nghệ

- ASP.NET Web Forms (.NET Framework 4.7.2)
- SQL Server (Windows Authentication)
- Bootstrap 5.3.2 + Font Awesome 6.4.2
- Chart.js

## Cấu trúc thư mục

```
QLNhanVien/
├── App_Code/          ← Model + DataAccess
├── App_Start/         ← BundleConfig, RouteConfig
├── Assets/            ← CSS, Images
├── MasterPages/       ← Site.Master (layout)
├── Pages/
│   ├── Auth/          ← Login.aspx
│   ├── Admin/         ← DanhSachNhanVien, QuanLyLuong, ThongKe...
│   ├── NhanVien/      ← HoSoCaNhan, BangLuongCaNhan
│   └── Common/        ← Default.aspx, HopThuNghiPhep
└── Web.config
```

## Chạy dự án

1. Mở `QLNhanVien.sln` bằng Visual Studio
2. Tạo database `QLNhanVien` trên SQL Server
3. Chỉnh `Data Source` trong `Web.config` cho đúng SQL Server
4. F5 chạy
