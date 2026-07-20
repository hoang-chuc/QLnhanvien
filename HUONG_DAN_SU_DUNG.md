# 📘 HƯỚNG DẪN SỬ DỤNG HỆ THỐNG QUẢN LÝ NHÂN SỰ (QLNhanVien)

> **IPLUS HRM** – Phần mềm quản lý nhân sự hiện đại, gọn gàng, dễ dùng.
> Công nghệ: ASP.NET Web Forms · SQL Server · Bootstrap 5 · Chart.js

---

## 🎯 Hệ thống dành cho ai?

| Vai trò | Bạn là ai? | Quyền lực của bạn |
|---------|-----------|-------------------|
| 👑 **Admin** | Quản trị viên | Toàn quyền: nhân viên, lương, phòng ban, tài khoản, thống kê |
| 🧑‍💼 **Quản lý** | Trưởng phòng | Xem & duyệt nhân viên **thuộc phòng mình**, duyệt nghỉ phép |
| 👤 **Nhân viên** | Người dùng bình thường | Xem hồ sơ, bảng lương, gửi đơn xin nghỉ |

---

## 🚀 Bắt đầu nhanh

### 1. Khởi động hệ thống (1 click)
Chạy file **`KHOI_DONG_HE_THONG.bat`** ở thư mục gốc. Script sẽ tự động:
1. 🔌 Kiểm tra / khởi động **SQL Server**
2. 🔨 Build dự án bằng **MSBuild**
3. 🌐 Kiểm tra / khởi động **IIS** (cổng `8080`)
4. 🪟 Mở trình duyệt tại `http://localhost:8080/Pages/Auth/Login.aspx`

> 💡 Nếu bước 2 báo lỗi, hãy mở **Visual Studio 2022** và build thủ công 1 lần.

### 2. Tài khoản mẫu để trải nghiệm
| Tên đăng nhập | Mật khẩu | Vai trò |
|---------------|----------|---------|
| `admin` | `admin123` | Admin |
| `nhanvien1` | `123456` | Nhân viên |

---

## 🔐 Đăng nhập & Tài khoản

### Đăng nhập
Tại màn hình Login, nhập **tên đăng nhập** và **mật khẩu** → **Đăng nhập**.
- Mật khẩu được mã hóa **SHA256**, an toàn tuyệt đối.
- Tài khoản bị khóa sẽ báo *"Tài khoản đã bị khóa!"*.

### Đăng ký tài khoản mới
Nhấn **"Tạo tài khoản"** → điền họ tên, tên đăng nhập, mật khẩu.
- Hệ thống tự tạo hồ sơ nhân viên + cấp quyền **Nhân viên** tự động.

### Quên mật khẩu
Nhấn **"Quên mật khẩu?"** → xác thực bằng **CCCD** và **SĐT** đã đăng ký → đặt mật khẩu mới.

---

## 🧭 Giao diện chính – Bạn nên biết những "mẹo" này

Sau khi đăng nhập, bạn sẽ thấy **thanh menu trái (Sidebar)** và **thanh trên (Navbar)**.

### 🔎 Tìm kiếm menu cực nhanh
Gõ tên chức năng vào ô **"Tìm kiếm menu..."** ở đầu sidebar → menu tự lọc realtime.
> Ví dụ: gõ `"lương"` sẽ chỉ còn hiển thị các mục liên quan đến lương.

### 🍔 Thu gọn / mở rộng menu
Nhấn biểu tượng **☰ (hamburger)** góc trái navbar để thu gọn sidebar khi cần không gian rộng.

### 🌙 Chế độ sáng / tối (Dark Mode)
Nhấn biểu tượng **🌙/☀️** góc phải navbar. Lựa chọn được **ghi nhớ** lần sau mở lại.

### 🔔 Hộp thư & thông báo
Biểu tượng **✉️ envelope** trên navbar hiện **badge đỏ** = số đơn nghỉ phép đang chờ duyệt. Nhấn vào để vào Hộp thư.

### 🚪 Đăng xuất
Nhấn **Đăng xuất** góc phải bất cứ lúc nào.

---

## 👤 Dành cho NHÂN VIÊN

### 1. Hồ sơ cá nhân (`HoSoCaNhan.aspx`)
Xem đầy đủ: mã NV, họ tên, ngày sinh, giới tính, CCCD, SĐT, email, địa chỉ, phòng ban, chức vụ.
- Ảnh đại diện tự động sinh từ tên nếu chưa có.

### 2. Bảng lương của tôi (`BangLuongCaNhan.aspx`)
Xem lịch sử lương theo tháng/năm: lương cơ bản, thưởng, phạt, **thực lĩnh**.

### 3. Gửi đơn xin nghỉ phép – 📮 Hộp thư (`HopThuNghiPhep.aspx`)
**Bước 1:** Chọn **Từ ngày** và **Đến ngày** (số ngày tự tính).
**Bước 2:** Nhập **Lý do**.
**Bước 3:** Nhấn **"Gửi cho Quản lý"**.

✅ Sau khi gửi, bạn sẽ thấy thông báo xanh *"Gửi đơn xin nghỉ thành công!"* và đơn xuất hiện trong **Lịch sử xin nghỉ phép** bên dưới với trạng thái:
- 🟡 **Chờ duyệt** – đang chờ quản lý
- 🟢 **Đã duyệt** – được nghỉ
- 🔴 **Từ chối** – không được duyệt

---

## 🧑‍💼 Dành cho QUẢN LÝ

Ngoài các chức năng như Nhân viên, Quản lý có thêm:

### 1. Xem nhân viên & lương phòng mình
Tại **Dashboard** và các màn hình quản lý, bạn **chỉ thấy dữ liệu của phòng ban mình phụ trách** (tự động lọc theo `MaPB`).

### 2. Duyệt đơn nghỉ phép (`HopThuNghiPhep.aspx`)
- Xem danh sách đơn gửi đến từ nhân viên phòng mình.
- Nhấn **"Xem chi tiết"** → xem thời gian, số ngày, lý do.
- Chọn **✅ Chấp nhận** · **❌ Từ chối** · **⏳ Chờ duyệt sau**.

### 3. Lịch sử nghỉ phép (`QuanLyCongTac.aspx`)
Lọc theo trạng thái: Chờ duyệt / Đã duyệt / Từ chối.

---

## 👑 Dành cho ADMIN

### 1. Quản lý nhân viên (`DanhSachNhanVien.aspx`)
- 🔍 **Live search**: gõ để lọc danh sách tức thì.
- ➕ Thêm · ✏️ Sửa · 🗑️ Xóa nhân viên.
- Validation đầy đủ (Họ tên, CCCD, SĐT, Email).
- Tự động tạo tài khoản khi thêm nhân viên mới.

### 2. Quản lý lương (`QuanLyLuong.aspx`)
- Xem bảng lương theo tháng/năm.
- Khởi tạo bảng lương tự động.
- Công thức: **Thực lĩnh = Lương cơ bản × Hệ số + Thưởng − Phạt**.

### 3. Phòng ban & Chức vụ (`DanhSachPhongBan.aspx`)
- Quản lý danh sách phòng ban (có live search).
- Quản lý chức vụ kèm **hệ số lương**.

### 4. Tài khoản hệ thống (`DanhSachTaiKhoan.aspx`)
- Danh sách tài khoản (live search): tên đăng nhập, quyền hạn, trạng thái.

### 5. Thống kê & Biểu đồ (`ThongKe.aspx`) 📊
Trang này có **3 biểu đồ trực quan**:
- 🥧 **Pie** – Phân bổ lao động theo phòng ban.
- 🍩 **Doughnut** – Trạng thái duyệt nghỉ phép (Vàng=Chờ, Xanh=Đã duyệt, Đỏ=Từ chối).
- 📊 **Bar** – Quỹ lương theo từng phòng ban (tháng hiện tại).

### 6. Dashboard & Xuất Excel (`Default.aspx`)
4 thẻ thống kê: Tổng nhân viên · Phòng ban · Tài khoản · Nghỉ việc.
- 📤 **Xuất Excel danh sách nhân viên**
- 📤 **Xuất Excel bảng lương tháng hiện tại**

---

## 🧪 Chạy kiểm tra tự động (dành cho dev)

Chạy **`CHAY_KIEM_TRA_TU_DONG.bat`** rồi chọn:
- `1` – Chạy tất cả test (ẩn trình duyệt)
- `2` – Chạy tất cả test (hiện trình duyệt)
- `3` – Chạy 1 file cụ thể (01–12)

> ⚠️ Phải chạy `KHOI_DONG_HE_THONG.bat` trước để server hoạt động.
> Lần đầu sẽ tự cài Playwright (~2 phút).

---

## ❓ Xử lý sự cố thường gặp

| Triệu chứng | Nguyên nhân & Cách xử lý |
|------------|--------------------------|
| Không mở được trang | SQL/IIS chưa chạy → chạy `KHOI_DONG_HE_THONG.bat` |
| Build thất bại | Thiếu Visual Studio → mở VS build thủ công |
| Đăng nhập sai hoài | Kiểm tra lại tài khoản, hoặc dùng *Quên mật khẩu* |
| Biểu đồ trắng | Kiểm tra kết nối mạng (Chart.js load từ CDN) |
| Badge hộp thư không hiện | Bình thường nếu không có đơn chờ duyệt |

---

## 🔐 Về bảo mật
- 🔒 Mật khẩu **SHA256**, không lưu plaintext.
- 🛡️ Xác thực bằng **Session** ở mọi trang.
- 👮 Phân quyền nghiêm ngặt: Admin > Quản lý > Nhân viên.
- 💉 Toàn bộ truy vấn dùng **tham số hóa** (chống SQL Injection).

---

> 💡 **Mẹo hay**: Dùng tổ hợp **Tìm kiếm menu** + **Dark Mode** để thao tác nhanh và nhàn hơn mỗi khi làm việc khuya! 

*Chúc bạn quản lý nhân sự thật hiệu quả với IPLUS HRM! 🚀*
