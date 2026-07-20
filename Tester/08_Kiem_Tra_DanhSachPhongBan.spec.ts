import { test, expect } from '@playwright/test';

const BASE_URL = 'http://localhost:8080';

test.describe('TEST 08: DANH SACH PHONG BAN', () => {

    test.beforeEach(async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#txtLoginPassword').fill('123456');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);
        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachPhongBan.aspx`);
    });

    test('TC01: Hien thi trang phong ban va chuc vu', async ({ page }) => {
        await expect(page.locator('text=Phòng ban & Chức vụ').first()).toBeVisible();
    });

    test('TC02: Hien thi danh sach phong ban', async ({ page }) => {
        await expect(page.locator('text=Danh sách phòng ban').first()).toBeVisible();
        const gridPB = page.locator('#MainContent_gvPhongBan');
        expect(await gridPB.isVisible()).toBeTruthy();
    });

    test('TC03: Hien thi danh sach chuc vu', async ({ page }) => {
        await expect(page.locator('text=Danh sách chức vụ').first()).toBeVisible();
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
        await page.context().clearCookies();
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('nvvan');
        await page.locator('#txtLoginPassword').fill('nvvan');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);

        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachPhongBan.aspx`);
        await expect(page).toHaveURL(/.*Login(\.aspx)?|.*Default/, { timeout: 5000 });
    });

    test('TC07: Phan quyen QuanLy khong vao duoc', async ({ page }) => {
        await page.context().clearCookies();
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('qlquang');
        await page.locator('#txtLoginPassword').fill('qlquang');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);

        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachPhongBan.aspx`);
        await expect(page).toHaveURL(/.*Login(\.aspx)?|.*Default/, { timeout: 5000 });
    });
});
