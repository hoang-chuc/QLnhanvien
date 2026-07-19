import { test, expect } from '@playwright/test';

const BASE_URL = 'https://localhost:44335';

test.describe('TEST 10: HO SO CA NHAN (Nhan vien)', () => {

    test.beforeEach(async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('testuser');
        await page.locator('#txtLoginPassword').fill('test123');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);
        await page.goto(`${BASE_URL}/Pages/NhanVien/HoSoCaNhan.aspx`);
    });

    test('TC01: Hien thi trang ho so ca nhan', async ({ page }) => {
        await expect(page.locator('text=Thông tin tài khoản')).toBeVisible();
        await expect(page.locator('text=Thông tin chi tiết')).toBeVisible();
    });

    test('TC02: Hien thi anh dai dien', async ({ page }) => {
        const avatar = page.locator('#MainContent_imgAvatar');
        expect(await avatar.isVisible()).toBeTruthy();
        const src = await avatar.getAttribute('src');
        expect(src).toBeTruthy();
    });

    test('TC03: Hien thi Ma nhan vien', async ({ page }) => {
        const maNV = await page.locator('#MainContent_lblMaNV').textContent();
        expect(maNV).toBeTruthy();
    });

    test('TC04: Hien thi Ho ten', async ({ page }) => {
        const hoTen = await page.locator('#MainContent_lblHoTen').textContent();
        expect(hoTen).toBeTruthy();
    });

    test('TC05: Hien thi Phong ban', async ({ page }) => {
        const phongBan = await page.locator('#MainContent_lblPhongBan').textContent();
        expect(phongBan).toBeTruthy();
    });

    test('TC06: Hien thi Chuc vu', async ({ page }) => {
        const chucVu = await page.locator('#MainContent_lblChucVu').textContent();
        expect(chucVu).toBeTruthy();
    });

    test('TC07: Hien thi CCCD', async ({ page }) => {
        const cccd = await page.locator('#MainContent_lblCCCD').textContent();
        expect(cccd).toBeTruthy();
    });

    test('TC08: Hien thi SDT', async ({ page }) => {
        const sdt = await page.locator('#MainContent_lblSDT').textContent();
        expect(sdt).toBeTruthy();
    });

    test('TC09: Hien thi Email', async ({ page }) => {
        const email = await page.locator('#MainContent_lblEmail').textContent();
        expect(email).toBeTruthy();
    });

    test('TC10: Hien thi nut doi anh', async ({ page }) => {
        await expect(page.locator('text=Đổi ảnh đại diện')).toBeVisible();
    });

    test('TC11: Chuc vu hien thi o ca 2 cho (title va detail)', async ({ page }) => {
        const chucVuTitle = await page.locator('#MainContent_lblChucVuTitle').textContent();
        const chucVuDetail = await page.locator('#MainContent_lblChucVu').textContent();
        expect(chucVuTitle).toBe(chucVuDetail);
    });
});
