import { test, expect } from '@playwright/test';

const BASE_URL = 'http://localhost:8080';

test.describe('TEST 02: DASHBOARD - TRANG TONG QUAN', () => {

    test.beforeEach(async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#txtLoginPassword').fill('123456');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);
        await page.goto(`${BASE_URL}/Pages/Common/Default.aspx`);
        await page.waitForTimeout(1000);
    });

    test('TC01: Hien thi 4 o thong ke tong quan', async ({ page }) => {
        await expect(page.locator('#MainContent_lblTongNhanVien')).toBeVisible();
        await expect(page.locator('#MainContent_lblTongPhongBan')).toBeVisible();
        await expect(page.locator('#MainContent_lblTongTaiKhoan')).toBeVisible();
        await expect(page.locator('#MainContent_lblNVNghiViec')).toBeVisible();
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
        await expect(page.locator('#MainContent_btnXuatExcelNhanVien')).toBeVisible();
        await expect(page.locator('#MainContent_btnXuatExcelLuong')).toBeVisible();
    });

    test('TC06: Link "Danh sach nhan vien" chuyen dung trang', async ({ page }) => {
        await page.locator('a:has-text("Danh sách nhân viên")').first().click();
        await expect(page).toHaveURL(/.*DanhSachNhanVien/, { timeout: 5000 });
    });

    test('TC07: Link "Danh sach phong ban" chuyen dung trang', async ({ page }) => {
        await page.locator('a:has-text("Danh sách phòng ban")').first().click();
        await expect(page).toHaveURL(/.*DanhSachPhongBan/, { timeout: 5000 });
    });

    test('TC08: Link "Danh sach tai khoan" chuyen dung trang', async ({ page }) => {
        await page.locator('a:has-text("Danh sách tài khoản")').first().click();
        await expect(page).toHaveURL(/.*DanhSachTaiKhoan/, { timeout: 5000 });
    });
});
