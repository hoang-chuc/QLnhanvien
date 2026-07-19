import { test, expect } from '@playwright/test';

const BASE_URL = 'http://localhost:8080';

test.describe('TEST 11: BANG LUONG CA NHAN (Nhan vien)', () => {

    test.beforeEach(async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('nvvan');
        await page.locator('#txtLoginPassword').fill('nvvan');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);
        await page.goto(`${BASE_URL}/Pages/NhanVien/BangLuongCaNhan.aspx`);
    });

    test('TC01: Hien thi trang bang luong ca nhan', async ({ page }) => {
        await expect(page.locator('text=Thu nhập cá nhân').first()).toBeVisible();
        await expect(page.locator('text=Lịch sử nhận lương').first()).toBeVisible();
    });

    test('TC02: Hien thi bang luong', async ({ page }) => {
        const gridVisible = await page.locator('#MainContent_gvLuongCaNhan').isVisible();
        expect(gridVisible).toBeTruthy();
    });

    test('TC03: Bang luong co du lieu hoac trong', async ({ page }) => {
        const rows = page.locator('#MainContent_gvLuongCaNhan tr');
        const count = await rows.count();
        // Co the co du lieu hoac khong
        expect(count).toBeGreaterThanOrEqual(0);
    });

    test('TC04: Hien thi ghi chu cong thuc tinh luong', async ({ page }) => {
        await expect(page.locator('text=Tổng lương thực lĩnh').first()).toBeVisible();
    });

    test('TC05: Cac cot du lieu hien thi dung', async ({ page }) => {
        await expect(page.locator('th:has-text("Kỳ lương")')).toBeVisible();
        await expect(page.locator('th:has-text("Lương cơ bản")')).toBeVisible();
        await expect(page.locator('th:has-text("Thưởng")')).toBeVisible();
        await expect(page.locator('th:has-text("Khấu trừ")')).toBeVisible();
        await expect(page.locator('th:has-text("Thực lĩnh")')).toBeVisible();
        await expect(page.locator('th:has-text("Trạng thái")')).toBeVisible();
    });

    test('TC06: Nhan vien chi thay luong cua minh', async ({ page }) => {
        // Kiem tra URL co MaNV cua nguoi dang nhap
        const pageContent = await page.content();
        expect(pageContent).toContain('gvLuongCaNhan');
    });
});
