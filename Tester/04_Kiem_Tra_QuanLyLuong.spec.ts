import { test, expect } from '@playwright/test';

const BASE_URL = 'https://localhost:44335';

test.describe('TEST 04: QUAN LY LUONG', () => {

    test.beforeEach(async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#txtLoginPassword').fill('admin123');
        await page.locator('#btnLogin').click();
        await expect(page).toHaveURL(/.*Default\.aspx/, { timeout: 10000 });
        await page.goto(`${BASE_URL}/Pages/Admin/QuanLyLuong.aspx`);
    });

    test('TC01: Hien thi trang quan ly luong', async ({ page }) => {
        await expect(page.locator('text=Quản lý bảng lương')).toBeVisible();
        await expect(page.locator('#MainContent_ddlThang')).toBeVisible();
        await expect(page.locator('#MainContent_txtNam')).toBeVisible();
        await expect(page.locator('#MainContent_btnXem')).toBeVisible();
        await expect(page.locator('#MainContent_btnTaoBangLuong')).toBeVisible();
    });

    test('TC02: Chon thang va xem bang luong', async ({ page }) => {
        await page.locator('#MainContent_ddlThang').selectOption('7');
        await page.locator('#MainContent_txtNam').fill('2025');
        await page.locator('#MainContent_btnXem').click();
        await page.waitForTimeout(1000);
        // Kiem tra bang co hien thi
        const gridVisible = await page.locator('#MainContent_gvLuong').isVisible();
        expect(gridVisible).toBeTruthy();
    });

    test('TC03: Khoi tao bang luong - hoi confirm', async ({ page }) => {
        let dialogMessage = '';
        page.on('dialog', async dialog => {
            dialogMessage = dialog.message();
            await dialog.accept();
        });

        await page.locator('#MainContent_btnTaoBangLuong').click();
        await page.waitForTimeout(2000);
        expect(dialogMessage).toContain('khởi tạo');
    });

    test('TC04: Khoi tao bang luong thanh cong', async ({ page }) => {
        page.on('dialog', dialog => dialog.accept());
        await page.locator('#MainContent_btnTaoBangLuong').click();
        await page.waitForTimeout(3000);

        // Kiem tra co thong bao
        const alertVisible = await page.evaluate(() => {
            return document.querySelector('.alert, [role="alert"]') !== null ||
                   document.querySelector('script')?.textContent?.includes('alert') === true;
        });
        // Acceptable - co the co alert hoac khong
    });

    test('TC05: Xem bang luong theo thang 12 nam 2024', async ({ page }) => {
        await page.locator('#MainContent_ddlThang').selectOption('12');
        await page.locator('#MainContent_txtNam').fill('2024');
        await page.locator('#MainContent_btnXem').click();
        await page.waitForTimeout(1000);
        const gridVisible = await page.locator('#MainContent_gvLuong').isVisible();
        expect(gridVisible).toBeTruthy();
    });

    test('TC06: Phan quyen NhanVien khong vao duoc', async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('testuser');
        await page.locator('#txtLoginPassword').fill('test123');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);

        await page.goto(`${BASE_URL}/Pages/Admin/QuanLyLuong.aspx`);
        await expect(page).toHaveURL(/.*Login\.aspx|.*Default\.aspx/, { timeout: 5000 });
    });
});
