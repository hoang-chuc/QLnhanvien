import { test, expect } from '@playwright/test';

const BASE_URL = 'https://localhost:44335';

test.describe('TEST 02: DASHBOARD - TRANG TONG QUAN', () => {

    test.beforeEach(async ({ page }) => {
        // Dang nhap Admin truoc
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#txtLoginPassword').fill('admin123');
        await page.locator('#btnLogin').click();
        await expect(page).toHaveURL(/.*Default\.aspx/, { timeout: 10000 });
    });

    test('TC01: Hien thi 4 o thong ke tong quan', async ({ page }) => {
        await expect(page.locator('text=Nhân viên')).toBeVisible();
        await expect(page.locator('text=Phòng ban')).toBeVisible();
        await expect(page.locator('text=Tài khoản người dùng')).toBeVisible();
        await expect(page.locator('text=Nhân viên nghỉ việc')).toBeVisible();
    });

    test('TC02: So nhan vien dang lam > 0', async ({ page }) => {
        const soNV = await page.locator('#MainContent_lblTongNhanVien').textContent();
        expect(Number(soNV)).toBeGreaterThan(0);
    });

    test('TC03: So phong ban > 0', async ({ page }) => {
        const soPB = await page.locator('#MainContent_lblTongPhongBan').textContent();
        expect(Number(soPB)).toBeGreaterThan(0);
    });

    test('TC04: So tai khoan > 0', async ({ page }) => {
        const soTK = await page.locator('#MainContent_lblTongTaiKhoan').textContent();
        expect(Number(soTK)).toBeGreaterThan(0);
    });

    test('TC05: Co nut xuat Excel', async ({ page }) => {
        await expect(page.locator('text=Danh sách nhân viên')).toBeVisible();
        await expect(page.locator('text=Lương nhân viên')).toBeVisible();
    });

    test('TC06: Link "Danh sach nhan vien" chuyen dung trang', async ({ page }) => {
        await page.locator('text=Danh sách nhân viên').first().click();
        await expect(page).toHaveURL(/.*DanhSachNhanVien\.aspx/, { timeout: 5000 });
    });

    test('TC07: Link "Danh sach phong ban" chuyen dung trang', async ({ page }) => {
        await page.locator('text=Danh sách phòng ban').click();
        await expect(page).toHaveURL(/.*DanhSachPhongBan\.aspx/, { timeout: 5000 });
    });

    test('TC08: Link "Danh sach tai khoan" chuyen dung trang', async ({ page }) => {
        await page.locator('text=Danh sách tài khoản').click();
        await expect(page).toHaveURL(/.*DanhSachTaiKhoan\.aspx/, { timeout: 5000 });
    });
});
