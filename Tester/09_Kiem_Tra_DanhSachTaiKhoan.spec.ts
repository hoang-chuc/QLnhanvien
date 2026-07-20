import { test, expect } from '@playwright/test';

const BASE_URL = 'http://localhost:8080';

test.describe('TEST 09: TAI KHOAN HE THONG - KHOA/MO KHOA', () => {

    test.beforeEach(async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#txtLoginPassword').fill('admin123');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);
        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachTaiKhoan.aspx`);
    });

    // ──────── HIỂN THỊ ────────

    test('TC01: Hien thi trang tai khoan he thong', async ({ page }) => {
        await expect(page.locator('text=Tài khoản hệ thống').first()).toBeVisible();
        await expect(page.locator('text=Khu vực bảo mật').first()).toBeVisible();
    });

    test('TC02: Hien thi GridView tai khoan', async ({ page }) => {
        await expect(page.locator('#MainContent_gvTaiKhoan')).toBeVisible();
    });

    test('TC03: Tai khoan co du lieu', async ({ page }) => {
        const rows = page.locator('#MainContent_gvTaiKhoan tbody tr');
        expect(await rows.count()).toBeGreaterThan(0);
    });

    test('TC04: Hien thi dung cac cot', async ({ page }) => {
        await expect(page.locator('th:has-text("Tên đăng nhập")')).toBeVisible();
        await expect(page.locator('th:has-text("Chủ sở hữu")')).toBeVisible();
        await expect(page.locator('th:has-text("Quyền hạn")')).toBeVisible();
        await expect(page.locator('th:has-text("Trạng thái")')).toBeVisible();
        await expect(page.locator('th:has-text("Thao tác")')).toBeVisible();
    });

    test('TC05: Khong hien thi mat khau plain text (da bo cot mat khau)', async ({ page }) => {
        // Cột mật khẩu đã bị xóa khỏi giao diện - không được phép hiển thị hash
        await expect(page.locator('th:has-text("Mật khẩu")')).toBeHidden();
    });

    // ──────── NÚT KHÓA / MỞ KHÓA ────────

    test('TC06: Tai khoan NhanVien co nut Khoa', async ({ page }) => {
        // Tìm hàng có Role = NhanVien
        const nhanVienRow = page.locator('#MainContent_gvTaiKhoan tbody tr').filter({ hasText: 'NhanVien' }).first();
        const count = await nhanVienRow.count();
        if (count > 0) {
            const nutKhoa = nhanVienRow.locator('a.btn-warning, a.btn-success');
            await expect(nutKhoa).toBeVisible();
        } else {
            console.log('Khong co tai khoan NhanVien trong danh sach.');
        }
    });

    test('TC07: Tai khoan Admin KHONG co nut Khoa (duoc bao ve)', async ({ page }) => {
        // Hàng admin phải có icon shield, không có nút khóa
        const adminRow = page.locator('#MainContent_gvTaiKhoan tbody tr').filter({ hasText: 'admin' }).first();
        const count = await adminRow.count();
        if (count > 0) {
            const nutKhoa = adminRow.locator('a.btn-warning, a.btn-success');
            // Nút khóa không được hiển thị cho Admin
            expect(await nutKhoa.count()).toBe(0);
        }
    });

    test('TC08: Khoa tai khoan NhanVien va hien thong bao', async ({ page }) => {
        // Tìm tài khoản NhanVien đang hoạt động
        const activeRow = page.locator('#MainContent_gvTaiKhoan tbody tr')
            .filter({ hasText: 'NhanVien' })
            .filter({ hasText: 'Đang hoạt động' })
            .first();
        const count = await activeRow.count();
        if (count === 0) {
            console.log('Khong co tai khoan NhanVien dang hoat dong. Bo qua TC08.');
            return;
        }
        // Click nút Khóa (màu vàng)
        page.once('dialog', dialog => dialog.accept());
        await activeRow.locator('a.btn-warning').click();
        await page.waitForTimeout(2000);
        await expect(page.locator('.alert')).toBeVisible({ timeout: 5000 });
    });

    // ──────── TÌM KIẾM ────────

    test('TC09: Tim kiem tai khoan theo ten dang nhap', async ({ page }) => {
        await page.locator('#MainContent_txtSearch').fill('admin');
        await page.locator('#MainContent_btnSearch').click();
        await page.waitForTimeout(1500);
        const rows = page.locator('#MainContent_gvTaiKhoan tbody tr');
        expect(await rows.count()).toBeGreaterThan(0);
        // Phải có hàng chứa chữ "admin"
        await expect(rows.first()).toContainText('admin');
    });

    test('TC10: Tim kiem khong co ket qua', async ({ page }) => {
        await page.locator('#MainContent_txtSearch').fill('xxxxxxxxxkhongtontai');
        await page.locator('#MainContent_btnSearch').click();
        await page.waitForTimeout(1500);
        const rows = page.locator('#MainContent_gvTaiKhoan tbody tr');
        // Khi không có kết quả, GridView hiện EmptyDataTemplate
        const emptyMsg = page.locator('#MainContent_gvTaiKhoan .text-muted');
        if (await emptyMsg.isVisible()) {
            await expect(emptyMsg).toBeVisible();
        } else {
            expect(await rows.count()).toBe(0);
        }
    });

    // ──────── PHÂN QUYỀN ────────

    test('TC11: NhanVien khong vao duoc trang tai khoan', async ({ page }) => {
        await page.context().clearCookies();
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('nvvan');
        await page.locator('#txtLoginPassword').fill('nvvan');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);
        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachTaiKhoan.aspx`);
        await expect(page).toHaveURL(/.*Login(\.aspx)?|.*Default/, { timeout: 5000 });
    });

    test('TC12: QuanLy khong vao duoc trang tai khoan (chi Admin)', async ({ page }) => {
        await page.context().clearCookies();
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('qlquang');
        await page.locator('#txtLoginPassword').fill('qlquang');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);
        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachTaiKhoan.aspx`);
        await expect(page).toHaveURL(/.*Login(\.aspx)?|.*Default/, { timeout: 5000 });
    });
});
