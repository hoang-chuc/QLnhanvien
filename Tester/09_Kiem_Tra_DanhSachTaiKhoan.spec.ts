import { test, expect } from '@playwright/test';

const BASE_URL = 'https://localhost:44335';

test.describe('TEST 09: DANH SACH TAI KHOAN', () => {

    test.beforeEach(async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#txtLoginPassword').fill('admin123');
        await page.locator('#btnLogin').click();
        await expect(page).toHaveURL(/.*Default\.aspx/, { timeout: 10000 });
        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachTaiKhoan.aspx`);
    });

    test('TC01: Hien thi trang tai khoan he thong', async ({ page }) => {
        await expect(page.locator('text=Tài khoản hệ thống')).toBeVisible();
        await expect(page.locator('text=Khu vực bảo mật')).toBeVisible();
    });

    test('TC02: Hien thi danh sach tai khoan', async ({ page }) => {
        const gridVisible = await page.locator('#MainContent_gvTaiKhoan').isVisible();
        expect(gridVisible).toBeTruthy();
    });

    test('TC03: Tai khoan co du lieu', async ({ page }) => {
        const rows = page.locator('#MainContent_gvTaiKhoan tr');
        const count = await rows.count();
        expect(count).toBeGreaterThan(1);
    });

    test('TC04: Hien thi dung cac cot', async ({ page }) => {
        await expect(page.locator('th:has-text("Tên đăng nhập")')).toBeVisible();
        await expect(page.locator('th:has-text("Mật khẩu")')).toBeVisible();
        await expect(page.locator('th:has-text("Chủ sở hữu")')).toBeVisible();
        await expect(page.locator('th:has-text("Quyền hạn")')).toBeVisible();
        await expect(page.locator('th:has-text("Trạng thái")')).toBeVisible();
    });

    test('TC05: Phan quyen NhanVien khong vao duoc', async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('testuser');
        await page.locator('#txtLoginPassword').fill('test123');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);

        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachTaiKhoan.aspx`);
        await expect(page).toHaveURL(/.*Login\.aspx|.*Default\.aspx/, { timeout: 5000 });
    });

    test('TC06: Phan quyen QuanLy khong vao duoc', async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('quanly');
        await page.locator('#txtLoginPassword').fill('quanly123');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);

        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachTaiKhoan.aspx`);
        await expect(page).toHaveURL(/.*Login\.aspx|.*Default\.aspx/, { timeout: 5000 });
    });
});
