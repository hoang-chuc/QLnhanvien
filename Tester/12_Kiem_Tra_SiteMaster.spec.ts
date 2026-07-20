import { test, expect } from '@playwright/test';

const BASE_URL = 'http://localhost:8080';

test.describe('TEST 12: SITE.MASTER - MENU & NAVIGATION', () => {

    test.describe('Dang nhap voi vai tro Admin', () => {
        test.beforeEach(async ({ page }) => {
            await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
            await page.locator('#txtLoginUsername').fill('admin');
            await page.locator('#txtLoginPassword').fill('123456');
            await page.locator('#btnLogin').click();
            await page.waitForTimeout(1000);
            await page.goto(`${BASE_URL}/Pages/Common/Default.aspx`);
            await page.waitForTimeout(1000);
        });

        test('TC01: Hien thi sidebar voi ten nguoi dung', async ({ page }) => {
            await expect(page.locator('.sidebar-user')).toBeVisible();
            await expect(page.locator('text=admin').first()).toBeVisible();
        });

        test('TC02: Admin thay day du menu', async ({ page }) => {
            await expect(page.locator('text=Tổng quan').first()).toBeVisible();
            await expect(page.locator('text=Thống kê').first()).toBeVisible();
            await expect(page.locator('text=Quản lý nhân viên').first()).toBeVisible();
            await expect(page.locator('text=Quản lý lương').first()).toBeVisible();
            await expect(page.locator('text=Nghỉ phép').first()).toBeVisible();
            await expect(page.locator('text=Phòng ban & Chức vụ').first()).toBeVisible();
            await expect(page.locator('text=Tài khoản hệ thống').first()).toBeVisible();
        });

        test('TC03: Menu "Tong quan" chuyen trang', async ({ page }) => {
            await page.locator('.sidebar-menu >> text=Tổng quan').click();
            await expect(page).toHaveURL(/.*Default/, { timeout: 5000 });
        });

        test('TC04: Menu "Thong ke" chuyen trang', async ({ page }) => {
            await page.locator('.sidebar-menu >> text=Thống kê').click();
            await expect(page).toHaveURL(/.*ThongKe/, { timeout: 5000 });
        });

        test('TC05: Menu "Quan ly nhan vien" chuyen trang', async ({ page }) => {
            await page.locator('.sidebar-menu >> text=Quản lý nhân viên').click();
            await expect(page).toHaveURL(/.*DanhSachNhanVien/, { timeout: 5000 });
        });

        test('TC06: Menu "Quan ly luong" chuyen trang', async ({ page }) => {
            await page.locator('.sidebar-menu >> text=Quản lý lương').click();
            await expect(page).toHaveURL(/.*QuanLyLuong/, { timeout: 5000 });
        });

        test('TC07: Menu "Nghi phep" chuyen trang', async ({ page }) => {
            await page.locator('.sidebar-menu >> text=Nghỉ phép').click();
            await expect(page).toHaveURL(/.*QuanLyCongTac/, { timeout: 5000 });
        });

        test('TC08: Menu "Phong ban" chuyen trang', async ({ page }) => {
            await page.locator('.sidebar-menu >> text=Phòng ban & Chức vụ').click();
            await expect(page).toHaveURL(/.*DanhSachPhongBan/, { timeout: 5000 });
        });

        test('TC09: Menu "Tai khoan" chuyen trang', async ({ page }) => {
            await page.locator('.sidebar-menu >> text=Tài khoản hệ thống').click();
            await expect(page).toHaveURL(/.*DanhSachTaiKhoan/, { timeout: 5000 });
        });

        test('TC10: Nut dang xuat hoat dong', async ({ page }) => {
            await page.locator('#btnLogout').click();
            await expect(page).toHaveURL(/.*Login(\.aspx)?/, { timeout: 5000 });
        });

        test('TC11: Icon hop thu nghi phep hien thi', async ({ page }) => {
            await expect(page.locator('a[title="Hộp thư xin nghỉ"]')).toBeVisible();
        });
    });

    test.describe('Dang nhap voi vai tro Nhan vien', () => {
        test.beforeEach(async ({ page }) => {
            await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
            await page.locator('#txtLoginUsername').fill('nvvan');
            await page.locator('#txtLoginPassword').fill('nvvan');
            await page.locator('#btnLogin').click();
            await page.waitForTimeout(1000);
        });

        test('TC12: Nhan vien thay menu phu hop', async ({ page }) => {
            await expect(page.locator('text=Tổng quan').first()).toBeVisible();
            await expect(page.locator('text=Thông tin cá nhân').first()).toBeVisible();
            await expect(page.locator('text=Bảng lương của tôi').first()).toBeVisible();
        });

        test('TC13: Nhan vien KHONG thay menu Admin', async ({ page }) => {
            await expect(page.locator('.sidebar-menu >> text=Thống kê')).toHaveCount(0);
            await expect(page.locator('.sidebar-menu >> text=Quản lý nhân viên')).toHaveCount(0);
            await expect(page.locator('.sidebar-menu >> text=Tài khoản hệ thống')).toHaveCount(0);
        });

        test('TC14: Menu "Ho so ca nhan" chuyen trang', async ({ page }) => {
            await page.locator('.sidebar-menu >> text=Thông tin cá nhân').click();
            await expect(page).toHaveURL(/.*HoSoCaNhan(\.aspx)?/, { timeout: 5000 });
        });

        test('TC15: Menu "Bang luong" chuyen trang', async ({ page }) => {
            await page.locator('.sidebar-menu >> text=Bảng lương của tôi').click();
            await expect(page).toHaveURL(/.*BangLuongCaNhan(\.aspx)?/, { timeout: 5000 });
        });
    });

    test.describe('Chua dang nhap', () => {
        test('TC16: Chua dang nhap bi chuyen ve Login', async ({ page }) => {
            await page.goto(`${BASE_URL}/Pages/Common/Default.aspx`);
            await expect(page).toHaveURL(/.*Login(\.aspx)?/, { timeout: 5000 });
        });

        test('TC17: Chua dang nhap khong vao duoc Admin page', async ({ page }) => {
            await page.goto(`${BASE_URL}/Pages/Admin/DanhSachNhanVien.aspx`);
            await expect(page).toHaveURL(/.*Login(\.aspx)?|.*Default/, { timeout: 5000 });
        });
    });
});
