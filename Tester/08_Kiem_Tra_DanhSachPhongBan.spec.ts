import { test, expect } from '@playwright/test';

const BASE_URL = 'https://localhost:44335';

test.describe('TEST 08: DANH SACH PHONG BAN', () => {

    test.beforeEach(async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#txtLoginPassword').fill('admin123');
        await page.locator('#btnLogin').click();
        await expect(page).toHaveURL(/.*Default\.aspx/, { timeout: 10000 });
        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachPhongBan.aspx`);
    });

    test('TC01: Hien thi trang phong ban va chuc vu', async ({ page }) => {
        await expect(page.locator('text=Phòng ban & Chức vụ')).toBeVisible();
    });

    test('TC02: Hien thi danh sach phong ban', async ({ page }) => {
        await expect(page.locator('text=Danh sách phòng ban')).toBeVisible();
        const gridPB = page.locator('#MainContent_gvPhongBan');
        expect(await gridPB.isVisible()).toBeTruthy();
    });

    test('TC03: Hien thi danh sach chuc vu', async ({ page }) => {
        await expect(page.locator('text=Danh sách chức vụ')).toBeVisible();
        const gridCV = page.locator('#MainContent_gvChucVu');
        expect(await gridCV.isVisible()).toBeTruthy();
    });

    test('TC04: Phong ban co du lieu', async ({ page }) => {
        const rows = page.locator('#MainContent_gvPhongBan tr');
        const count = await rows.count();
        expect(count).toBeGreaterThan(1);
    });

    test('TC05: Chuc vu co du lieu', async ({ page }) => {
        const rows = page.locator('#MainContent_gvChucVu tr');
        const count = await rows.count();
        expect(count).toBeGreaterThan(1);
    });

    test('TC06: Phan quyen NhanVien khong vao duoc', async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('testuser');
        await page.locator('#txtLoginPassword').fill('test123');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);

        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachPhongBan.aspx`);
        await expect(page).toHaveURL(/.*Login\.aspx|.*Default\.aspx/, { timeout: 5000 });
    });

    test('TC07: Phan quyen QuanLy khong vao duoc', async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('quanly');
        await page.locator('#txtLoginPassword').fill('quanly123');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);

        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachPhongBan.aspx`);
        await expect(page).toHaveURL(/.*Login\.aspx|.*Default\.aspx/, { timeout: 5000 });
    });
});
