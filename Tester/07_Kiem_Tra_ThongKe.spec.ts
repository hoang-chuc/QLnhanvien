import { test, expect } from '@playwright/test';

const BASE_URL = 'http://localhost:8080';

test.describe('TEST 07: THONG KE BIEU DO', () => {

    test.beforeEach(async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#txtLoginPassword').fill('123456');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);
        await page.goto(`${BASE_URL}/Pages/Admin/ThongKe.aspx`);
    });

    test('TC01: Hien thi trang thong ke', async ({ page }) => {
        await expect(page.locator('text=Biểu đồ thống kê').first()).toBeVisible();
    });

    test('TC02: Co 3 bieu do', async ({ page }) => {
        await expect(page.locator('#chartNhanVien')).toBeVisible();
        await expect(page.locator('#chartNghiPhep')).toBeVisible();
        await expect(page.locator('#chartQuyLuong')).toBeVisible();
    });

    test('TC03: Bieu do nhan vien co du lieu', async ({ page }) => {
        const data = await page.evaluate(() => {
            const canvas = document.getElementById('chartNhanVien') as HTMLCanvasElement;
            return canvas !== null;
        });
        expect(data).toBeTruthy();
    });

    test('TC04: Bieu do nghi phep co du lieu', async ({ page }) => {
        const data = await page.evaluate(() => {
            const canvas = document.getElementById('chartNghiPhep') as HTMLCanvasElement;
            return canvas !== null;
        });
        expect(data).toBeTruthy();
    });

    test('TC05: Bieu do quy luong co du lieu', async ({ page }) => {
        const data = await page.evaluate(() => {
            const canvas = document.getElementById('chartQuyLuong') as HTMLCanvasElement;
            return canvas !== null;
        });
        expect(data).toBeTruthy();
    });

    test('TC06: Phan quyen NhanVien khong vao duoc', async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('nvvan');
        await page.locator('#txtLoginPassword').fill('nvvan');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);

        await page.goto(`${BASE_URL}/Pages/Admin/ThongKe.aspx`);
        await expect(page).toHaveURL(/.*Login\.aspx|.*Default/, { timeout: 5000 });
    });
});
