import { test, expect } from '@playwright/test';

const BASE_URL = 'http://localhost:8080';

test.describe('TEST 05: QUAN LY NGHI PHEP - DUYET/TU CHOI DON', () => {

    test.beforeEach(async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#txtLoginPassword').fill('admin123');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);
        await page.goto(`${BASE_URL}/Pages/Admin/QuanLyCongTac.aspx`);
    });

    // ──────── HIỂN THỊ ────────

    test('TC01: Hien thi trang lich su nghi phep', async ({ page }) => {
        await expect(page.locator('text=Lịch sử nghỉ phép').first()).toBeVisible();
        await expect(page.locator('#MainContent_ddlFilterTrangThai')).toBeVisible();
    });

    test('TC02: Hien thi GridView don nghi phep', async ({ page }) => {
        await expect(page.locator('#MainContent_gvNghiPhep')).toBeVisible();
    });

    test('TC03: Hien thi cot Thao tac co nut Duyet va Tu choi', async ({ page }) => {
        await expect(page.locator('th:has-text("Thao tác")')).toBeVisible();
    });

    // ──────── LỌC TRẠNG THÁI ────────

    test('TC04: Loc theo trang thai "Cho duyet"', async ({ page }) => {
        await page.locator('#MainContent_ddlFilterTrangThai').selectOption('Chờ duyệt');
        await page.waitForTimeout(1500);
        await expect(page.locator('#MainContent_gvNghiPhep')).toBeVisible();
        // Tất cả hàng hiển thị phải có badge "Chờ duyệt"
        const rows = page.locator('#MainContent_gvNghiPhep tbody tr');
        const count = await rows.count();
        if (count > 0) {
            const firstBadge = rows.first().locator('.badge');
            await expect(firstBadge).toContainText('Chờ duyệt');
        }
    });

    test('TC05: Loc theo trang thai "Da duyet"', async ({ page }) => {
        await page.locator('#MainContent_ddlFilterTrangThai').selectOption('Đã duyệt');
        await page.waitForTimeout(1500);
        await expect(page.locator('#MainContent_gvNghiPhep')).toBeVisible();
    });

    test('TC06: Loc theo trang thai "Tu choi"', async ({ page }) => {
        await page.locator('#MainContent_ddlFilterTrangThai').selectOption('Từ chối');
        await page.waitForTimeout(1500);
        await expect(page.locator('#MainContent_gvNghiPhep')).toBeVisible();
    });

    test('TC07: Loc "Tat ca" hien thi day du', async ({ page }) => {
        await page.locator('#MainContent_ddlFilterTrangThai').selectOption('Tất cả');
        await page.waitForTimeout(1500);
        await expect(page.locator('#MainContent_gvNghiPhep')).toBeVisible();
    });

    // ──────── DUYỆT ĐƠN ────────

    test('TC08: Nut Duyet hien thi cho don "Cho duyet"', async ({ page }) => {
        await page.locator('#MainContent_ddlFilterTrangThai').selectOption('Chờ duyệt');
        await page.waitForTimeout(1500);
        const rows = page.locator('#MainContent_gvNghiPhep tbody tr');
        const count = await rows.count();
        if (count > 0) {
            const nutDuyet = rows.first().locator('a:has-text("Duyệt")');
            await expect(nutDuyet).toBeVisible();
        } else {
            console.log('Khong co don cho duyet de kiem tra.');
        }
    });

    test('TC09: Nut Tu choi hien thi cho don "Cho duyet"', async ({ page }) => {
        await page.locator('#MainContent_ddlFilterTrangThai').selectOption('Chờ duyệt');
        await page.waitForTimeout(1500);
        const rows = page.locator('#MainContent_gvNghiPhep tbody tr');
        const count = await rows.count();
        if (count > 0) {
            const nutTuChoi = rows.first().locator('a:has-text("Từ chối")');
            await expect(nutTuChoi).toBeVisible();
        }
    });

    test('TC10: Thuc hien duyet don va hien thong bao thanh cong', async ({ page }) => {
        await page.locator('#MainContent_ddlFilterTrangThai').selectOption('Chờ duyệt');
        await page.waitForTimeout(1500);
        const rows = page.locator('#MainContent_gvNghiPhep tbody tr');
        const count = await rows.count();
        if (count === 0) {
            console.log('Khong co don cho duyet. Bo qua TC10.');
            return;
        }
        page.once('dialog', dialog => dialog.accept());
        await rows.first().locator('a:has-text("Duyệt")').click();
        await page.waitForTimeout(2000);
        // Sau khi duyệt phải hiện thông báo xanh
        await expect(page.locator('.alert-success')).toBeVisible({ timeout: 5000 });
    });

    // ──────── PHÂN QUYỀN ────────

    test('TC11: NhanVien khong vao duoc trang quan ly nghi phep', async ({ page }) => {
        await page.context().clearCookies();
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('nvvan');
        await page.locator('#txtLoginPassword').fill('nvvan');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);
        await page.goto(`${BASE_URL}/Pages/Admin/QuanLyCongTac.aspx`);
        await expect(page).toHaveURL(/.*Login(\\.aspx)?|.*Default/, { timeout: 5000 });
    });
});
