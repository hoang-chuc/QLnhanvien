import { test, expect } from '@playwright/test';

const BASE_URL = 'http://localhost:8080';

test.describe('TEST 06: HOP THU NGHI PHEP', () => {

    test.describe('Vai tro Nhan vien - Gui don', () => {

        test.beforeEach(async ({ page }) => {
            await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
            await page.locator('#txtLoginUsername').fill('nvvan');
            await page.locator('#txtLoginPassword').fill('nvvan');
            await page.locator('#btnLogin').click();
            await page.waitForTimeout(1000);
            await page.goto(`${BASE_URL}/Pages/Common/HopThuNghiPhep.aspx`);
        });

        test('TC01: Hien thi form gui don nghi phep', async ({ page }) => {
            await expect(page.locator('text=Gửi đơn xin nghỉ phép').first()).toBeVisible();
            await expect(page.locator('#MainContent_txtTuNgay')).toBeVisible();
            await expect(page.locator('#MainContent_txtDenNgay')).toBeVisible();
            await expect(page.locator('#MainContent_txtLyDo')).toBeVisible();
            await expect(page.locator('#MainContent_btnGuiDon')).toBeVisible();
        });

        test('TC02: Gui don nghi phep thanh cong', async ({ page }) => {
            const today = new Date();
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);

            const tuNgay = today.toISOString().split('T')[0];
            const denNgay = tomorrow.toISOString().split('T')[0];

            await page.locator('#MainContent_txtTuNgay').fill(tuNgay);
            await page.locator('#MainContent_txtDenNgay').fill(denNgay);
            await page.locator('#MainContent_txtLyDo').fill('Test gui don nghi phep tu Playwright');

            page.on('dialog', dialog => dialog.accept());
            await page.locator('#MainContent_btnGuiDon').click();
            await page.waitForTimeout(2000);
        });

        test('TC03: Gui don that bai - den ngay nho hon tu ngay', async ({ page }) => {
            await page.locator('#MainContent_txtTuNgay').fill('2026-12-31');
            await page.locator('#MainContent_txtDenNgay').fill('2026-01-01');
            await page.locator('#MainContent_txtLyDo').fill('Test loi ngay');

            page.on('dialog', async dialog => {
                expect(dialog.message()).toContain('ngày kết thúc');
                await dialog.accept();
            });
            await page.locator('#MainContent_btnGuiDon').click();
            await page.waitForTimeout(1000);
        });
    });

    test.describe('Vai tro Admin - Duyet don', () => {

        test.beforeEach(async ({ page }) => {
            await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
            await page.locator('#txtLoginUsername').fill('admin');
            await page.locator('#txtLoginPassword').fill('123456');
            await page.locator('#btnLogin').click();
            await expect(page).toHaveURL(/.*Default/, { timeout: 10000 });
            await page.goto(`${BASE_URL}/Pages/Common/HopThuNghiPhep.aspx`);
        });

        test('TC04: Hien thi danh sach don den', async ({ page }) => {
            await expect(page.locator('text=Hộp thư đến').first()).toBeVisible();
            const gridVisible = await page.locator('#MainContent_gvDonNghi').isVisible();
            expect(gridVisible).toBeTruthy();
        });

        test('TC05: Xem chi tiet don', async ({ page }) => {
            const xemBtn = page.locator('#MainContent_gvDonNghi_btnXem_0');
            if (await xemBtn.isVisible()) {
                await xemBtn.click();
                await expect(page.locator('text=Chi tiết đơn nghỉ phép').first()).toBeVisible();
                await expect(page.locator('#MainContent_lblChiTietNguoiGui')).toBeVisible();
                await expect(page.locator('#MainContent_lblChiTietThoiGian')).toBeVisible();
                await expect(page.locator('#MainContent_btnChapNhan')).toBeVisible();
                await expect(page.locator('#MainContent_btnTuChoi')).toBeVisible();
            }
        });

        test('TC06: Quay lai danh sach tu chi tiet', async ({ page }) => {
            const xemBtn = page.locator('#MainContent_gvDonNghi_btnXem_0');
            if (await xemBtn.isVisible()) {
                await xemBtn.click();
                await expect(page.locator('text=Chi tiết đơn nghỉ phép').first()).toBeVisible();
                await page.locator('#MainContent_btnBack').click();
                await expect(page.locator('text=Hộp thư đến').first()).toBeVisible();
            }
        });

        test('TC07: Duyet don - thay doi trang thai', async ({ page }) => {
            const xemBtn = page.locator('#MainContent_gvDonNghi_btnXem_0');
            if (await xemBtn.isVisible()) {
                await xemBtn.click();
                await page.locator('#MainContent_btnChapNhan').click();
                await page.waitForTimeout(1500);
                await expect(page.locator('text=Hộp thư đến').first()).toBeVisible();
            }
        });
    });
});
