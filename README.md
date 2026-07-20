# QLNhanVien - Hệ thống Quản lý Nhân sự

> Đề tài thực tập: Quản lý nhân sự tại công ty  
> Công nghệ: ASP.NET Web Forms + SQL Server + Chart.js

---

## 📋 Tổng quan

Hệ thống quản lý nhân sự (HRMS) xây dựng bằng **ASP.NET Web Forms** trên nền **.NET Framework 4.7.2**, sử dụng **SQL Server** làm cơ sở dữ liệu và **Chart.js** cho biểu đồ thống kê.

### Chức năng chính

| Vai trò | Chức năng |
|---------|-----------|
| **Admin** | Quản lý nhân viên (CRUD), quản lý lương, quản lý công tác, thống kê, quản lý phòng ban & chức vụ, quản lý tài khoản |
| **Quản lý** | Xem danh sách nhân viên phòng ban, xem lương, duyệt nghỉ phép |
| **Nhân viên** | Xem hồ sơ cá nhân, xem bảng lương cá nhân, gửi đơn nghỉ phép |

---

## 🛠 Công nghệ

| Thành phần | Công nghệ |
|------------|-----------|
| **Backend** | ASP.NET Web Forms (.NET Framework 4.7.2) |
| **Frontend** | Bootstrap 5, jQuery, Chart.js |
| **Database** | SQL Server Express (Windows Authentication) |
| **Bảo mật** | SHA256 Password Hashing, Session-based Auth |
| **Testing** | Playwright (E2E Testing) |
| **IDE** | Visual Studio 2022 |

---

## 📁 Cấu trúc thư mục

```
QLNhanVien/
├── App_Code/                ← Mã nguồn chung
│   ├── DataAccess/
│   │   ├── DBAccess.cs      ← Kết nối database
│   │   └── PasswordHelper.cs ← Mã hóa mật khẩu SHA256
│   └── Models/
│       ├── NhanVien.cs      ← Model nhân viên
│       └── TaiKhoan.cs      ← Model tài khoản
├── App_Start/               ← Cấu hình khởi động
│   ├── BundleConfig.cs      ← Gộp CSS/JS
│   └── RouteConfig.cs       ← Cấu hình URL
├── Assets/
│   ├── CSS/style.css        ← Stylesheet chính
│   └── Images/favicon.ico   ← Biểu tượng
├── MasterPages/
│   └── Site.Master          ← Layout chung (sidebar, header, footer)
├── Pages/
│   ├── Auth/
│   │   └── Login.aspx       ← Đăng nhập / Đăng ký / Quên mật khẩu
│   ├── Admin/
│   │   ├── DanhSachNhanVien.aspx    ← Quản lý nhân viên (CRUD + Tìm kiếm)
│   │   ├── DanhSachPhongBan.aspx    ← Quản lý phòng ban & chức vụ
│   │   ├── DanhSachTaiKhoan.aspx    ← Quản lý tài khoản hệ thống
│   │   ├── QuanLyCongTac.aspx       ← Lịch sử nghỉ phép
│   │   ├── QuanLyLuong.aspx         ← Quản lý bảng lương
│   │   └── ThongKe.aspx             ← Thống kê biểu đồ
│   ├── Common/
│   │   ├── Default.aspx             ← Dashboard tổng quan
│   │   └── HopThuNghiPhep.aspx      ← Hộp thư nghỉ phép
│   └── NhanVien/
│       ├── HoSoCaNhan.aspx          ← Hồ sơ cá nhân
│       └── BangLuongCaNhan.aspx     ← Bảng lương cá nhân
├── Tester/                  ← Test E2E (Playwright)
│   ├── 01-12_*.spec.ts      ← 12 file test
│   ├── playwright.config.ts ← Cấu hình test
│   └── package.json         ← Dependencies test
├── Web.config               ← Cấu hình ứng dụng
├── QLNhanVien.sln           ← Solution file
└── QLNhanVien.csproj        ← Project file
```

---

## 🚀 Hướng dẫn cài đặt

### Yêu cầu

- **Visual Studio 2022** (có role ASP.NET và Web Development)
- **SQL Server Express** (hoặc SQL Server Developer)
- **IIS Express** (tích hợp sẵn trong Visual Studio)
- **Node.js** (để chạy test Playwright)

### Bước 1: Clone dự án

```bash
git clone https://github.com/hoang-chuc/QLnhanvien.git
cd QLNhanvien/QLNhanVien
```

### Bước 2: Cấu hình Database

1. Mở **SQL Server Management Studio (SSMS)**
2. Kết nối SQL Server Express (`.\SQLEXPRESS`)
3. Tạo database mới tên `QLNhanVien`

### Bước 3: Tạo bảng và dữ liệu mẫu

Chạy script SQL trong SSMS để tạo cấu trúc bảng và dữ liệu mẫu.

### Bước 4: Cấu hình kết nối Database

Mở file `Web.config`, chỉnh sửa chuỗi kết nối:

```xml
<connectionStrings>
    <add name="QLNhanVienConn" 
         connectionString="Data Source=.\SQLEXPRESS;Initial Catalog=QLNhanVien;Integrated Security=True" 
         providerName="System.Data.SqlClient" />
</connectionStrings>
```

### Bước 5: Chạy dự án

1. Mở `QLNhanVien.sln` bằng Visual Studio 2022
2. Nhấn **F5** hoặc **Ctrl+F5** để chạy
3. Truy cập `http://localhost:8080`

### Tài khoản mặc định

| Tên đăng nhập | Mật khẩu | Vai trò |
|---------------|-----------|---------|
| `admin` | `123456` | Admin |

---

## 🧪 Chạy Test

### Cài đặt

```bash
cd Tester
npm install
npx playwright install chromium
```

### Chạy tất cả test

```bash
npx playwright test --reporter=list
```

Kết quả: ✅ **105/105 tests passed**

### Chạy test cụ thể

```bash
# Test login
npx playwright test 01_Kiem_Tra_Dang_Nhap.spec.ts

# Test quản lý nhân viên
npx playwright test 03_Kiem_Tra_DanhSachNhanVien.spec.ts

# Test có giao diện
npx playwright test --headed
```

---

## 📊 Tổng quan Chức năng

### 1. Xác thực & Phân quyền
- Đăng nhập / Đăng ký / Quên mật khẩu
- Mật khẩu mã hóa SHA256
- 3 vai trò: Admin, Quản lý, Nhân viên

### 2. Dashboard (Trang chủ)
- Tổng quan 4 chỉ số: Nhân viên, Phòng ban, Tài khoản, Nghỉ việc
- Biểu đồ nhân viên theo phòng ban
- Biểu đồ nghỉ phép theo tháng
- Biểu đồ quỹ lương theo quý

### 3. Quản lý Nhân viên (Admin)
- Danh sách nhân viên với **live search**
- Thêm / Sửa / Xóa nhân viên
- Form validation đầy đủ (Họ tên, CCCD, SĐT, Email)
- Tự động tạo tài khoản khi thêm nhân viên mới

### 4. Quản lý Lương (Admin)
- Xem bảng lương theo tháng/năm
- Khởi tạo bảng lương tự động
- Công thức: `TongLuong = LuongCoBan × HeSoLuong + Thuong - Phat`

### 5. Quản lý Công tác (Admin/Quản lý)
- Lịch sử nghỉ phép
- Lọc theo trạng thái: Chờ duyệt, Đã duyệt, Từ chối

### 6. Hộp thư Nghỉ phép
- Nhân viên: Gửi đơn xin nghỉ phép
- Admin: Duyệt / Từ chối đơn

### 7. Quản lý Phòng ban & Chức vụ
- Danh sách phòng ban với live search
- Danh sách chức vụ với hệ số lương

### 8. Quản lý Tài khoản
- Danh sách tài khoản với live search
- Hiển thị tên đăng nhập, quyền hạn, trạng thái

### 9. Hồ sơ Cá nhân
- Xem thông tin cá nhân, ảnh đại diện
- Chức năng đổi ảnh

### 10. Bảng lương Cá nhân
- Xem lương chi tiết theo tháng/năm
- Ghi chú công thức tính lương

### 11. Thống kê (Admin)
- 3 biểu đồ Chart.js: Nhân viên, Nghỉ phép, Quỹ lương

### 12. Site.Master - Menu & Navigation
- Sidebar menu phân quyền theo vai trò
- Nút đăng xuất
- Icon hộp thư nghỉ phép

---

## 🔐 Bảo mật

- **Password Hashing**: SHA256
- **Session-based Auth**: Kiểm tra Session ở mỗi trang
- **Phân quyền**: Admin > Quản lý > Nhân viên
- **SQL Injection Protection**: Parameterized queries
- **Input Validation**: Regex validate cả client và server

---

## 📦 Dependencies

### Backend
- ASP.NET Web Forms (.NET Framework 4.7.2)
- Microsoft.AspNet.Web.Optimization
- Bootstrap 5, jQuery, Chart.js

### Testing
- @playwright/test ^1.60.0
- playwright ^1.60.0

---

## 📝 License

MIT License
