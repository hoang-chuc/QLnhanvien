import { test, expect } from '@playwright/test';

const BASE_URL = 'http://localhost:8080';

test.describe('TEST 05: LICH SU NGHI PHEP (QuanLyCongTac)', () => {

    test.beforeEach(async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#txtLoginPassword').fill('123456');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);
        await page.goto(`${BASE_URL}/Pages/Admin/QuanLyCongTac.aspx`);
    });

    test('TC01: Hien thi trang lich su nghi phep', async ({ page }) => {
        await expect(page.locator('text=Lịch sử nghỉ phép').first()).toBeVisible();
        await expect(page.locator('#MainContent_ddlFilterTrangThai')).toBeVisible();
    });

    test('TC02: Hien thi danh sach don nghi', async ({ page }) => {
        const gridVisible = await page.locator('#MainContent_gvNghiPhep').isVisible();
        expect(gridVisible).toBeTruthy();
    });

    test('TC03: Loc theo trang thai "Cho duyet"', async ({ page }) => {
        await page.locator('#MainContent_ddlFilterTrangThai').selectOption('Chờ duyệt');
        await page.waitForTimeout(1500);
        const gridVisible = await page.locator('#MainContent_gvNghiPhep').isVisible();
        expect(gridVisible).toBeTruthy();
    });

    test('TC04: Loc theo trang thai "Da duyet"', async ({ page }) => {
        await page.locator('#MainContent_ddlFilterTrangThai').selectOption('Đã duyệt');
        await page.waitForTimeout(1500);
        const gridVisible = await page.locator('#MainContent_gvNghiPhep').isVisible();
        expect(gridVisible).toBeTruthy();
    });

    test('TC05: Loc theo trang thai "Tu choi"', async ({ page }) => {
        await page.locator('#MainContent_ddlFilterTrangThai').selectOption('Từ chối');
        await page.waitForTimeout(1500);
        const gridVisible = await page.locator('#MainContent_gvNghiPhep').isVisible();
        expect(gridVisible).toBeTruthy();
    });

    test('TC06: Loc "Tat ca" hien thi du lieu day du', async ({ page }) => {
        await page.locator('#MainContent_ddlFilterTrangThai').selectOption('Tất cả');
        await page.waitForTimeout(1500);
        const gridVisible = await page.locator('#MainContent_gvNghiPhep').isVisible();
        expect(gridVisible).toBeTruthy();
    });

    test('TC07: Phan quyen NhanVien khong vao duoc', async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('nvvan');
        await page.locator('#txtLoginPassword').fill('nvvan');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);

        await page.goto(`${BASE_URL}/Pages/Admin/QuanLyCongTac.aspx`);
        await expect(page).toHaveURL(/.*Login\.aspx|.*Default/, { timeout: 5000 });
    });
});
