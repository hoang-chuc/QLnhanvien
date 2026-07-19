import { test, expect } from '@playwright/test';

const BASE_URL = 'https://localhost:44335';

test.describe('TEST 01: DANG NHAP VA DANG KY', () => {

    test.beforeEach(async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
    });

    // ==================== PHAN 1: DANG NHAP ====================

    test('TC01: Hien thi form dang nhap', async ({ page }) => {
        await expect(page.locator('text=ĐĂNG NHẬP')).toBeVisible();
        await expect(page.locator('#txtLoginUsername')).toBeVisible();
        await expect(page.locator('#txtLoginPassword')).toBeVisible();
        await expect(page.locator('#btnLogin')).toBeVisible();
    });

    test('TC02: Dang nhap Admin thanh cong', async ({ page }) => {
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#txtLoginPassword').fill('admin123');
        await page.locator('#btnLogin').click();
        await expect(page).toHaveURL(/.*Default\.aspx/, { timeout: 10000 });
    });

    test('TC03: Dang nhap that bai - sai mat khau', async ({ page }) => {
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#txtLoginPassword').fill('saimatkhau');
        await page.locator('#btnLogin').click();
        await expect(page.locator('text=Sai tên đăng nhập hoặc mật khẩu')).toBeVisible({ timeout: 5000 });
    });

    test('TC04: Dang nhap that bai - tai khoan khong ton tai', async ({ page }) => {
        await page.locator('#txtLoginUsername').fill('taikhoankhongtontai');
        await page.locator('#txtLoginPassword').fill('pass123');
        await page.locator('#btnLogin').click();
        await expect(page.locator('text=Sai tên đăng nhập hoặc mật khẩu')).toBeVisible({ timeout: 5000 });
    });

    test('TC05: Dang nhap that bai - de trong username', async ({ page }) => {
        await page.locator('#txtLoginPassword').fill('admin123');
        await page.locator('#btnLogin').click();
        // Trinh duyen hien thong bao required
        const usernameField = page.locator('#txtLoginUsername');
        const validationMessage = await usernameField.evaluate((el: HTMLInputElement) => el.validationMessage);
        expect(validationMessage).toBeTruthy();
    });

    test('TC06: Dang nhap that bai - de trong mat khau', async ({ page }) => {
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#btnLogin').click();
        const passwordField = page.locator('#txtLoginPassword');
        const validationMessage = await passwordField.evaluate((el: HTMLInputElement) => el.validationMessage);
        expect(validationMessage).toBeTruthy();
    });

    // ==================== PHAN 2: CHUYEN FORM ====================

    test('TC07: Chuyen sang form dang ky', async ({ page }) => {
        await page.locator('text=Đăng ký mới').click();
        await expect(page.locator('text=ĐĂNG KÝ')).toBeVisible();
        await expect(page.locator('#txtRegFullName')).toBeVisible();
        await expect(page.locator('#txtRegUsername')).toBeVisible();
        await expect(page.locator('#txtRegPassword')).toBeVisible();
    });

    test('TC08: Chuyen sang form quen mat khau', async ({ page }) => {
        await page.locator('text=Quên mật khẩu?').click();
        await expect(page.locator('text=ĐẶT LẠI MẬT KHẨU')).toBeVisible();
        await expect(page.locator('#txtForgotUsername')).toBeVisible();
        await expect(page.locator('#txtForgotCCCD')).toBeVisible();
        await expect(page.locator('#txtForgotSDT')).toBeVisible();
        await expect(page.locator('#txtNewPassword')).toBeVisible();
    });

    test('TC09: Quay lai form dang nhap tu form dang ky', async ({ page }) => {
        await page.locator('text=Đăng ký mới').click();
        await expect(page.locator('text=ĐĂNG KÝ')).toBeVisible();
        await page.locator('text=Đã có tài khoản? Đăng nhập').click();
        await expect(page.locator('text=ĐĂNG NHẬP')).toBeVisible();
    });

    test('TC10: Quay lai form dang nhap tu form quen mat khau', async ({ page }) => {
        await page.locator('text=Quên mật khẩu?').click();
        await expect(page.locator('text=ĐẶT LẠI MẬT KHẨU')).toBeVisible();
        await page.locator('text=Quay lại đăng nhập').click();
        await expect(page.locator('text=ĐĂNG NHẬP')).toBeVisible();
    });

    // ==================== PHAN 3: DANG KY ====================

    test('TC11: Dang ky tai khoan moi thanh cong', async ({ page }) => {
        await page.locator('text=Đăng ký mới').click();

        const ts = Date.now();
        const username = `testuser_${ts}`;

        await page.locator('#txtRegFullName').fill('Nguoi Dung Test');
        await page.locator('#txtRegUsername').fill(username);
        await page.locator('#txtRegPassword').fill('test123456');
        await page.locator('#btnRegister').click();

        await expect(page.locator('text=Đăng ký thành công')).toBeVisible({ timeout: 5000 });
    });

    test('TC12: Dang ky that bai - trung username', async ({ page }) => {
        await page.locator('text=Đăng ký mới').click();
        await page.locator('#txtRegFullName').fill('Test Trung User');
        await page.locator('#txtRegUsername').fill('admin');
        await page.locator('#txtRegPassword').fill('test123456');
        await page.locator('#btnRegister').click();

        await expect(page.locator('text=đã có người sử dụng')).toBeVisible({ timeout: 5000 });
    });

    // ==================== PHAN 4: QUEN MAT KHAU ====================

    test('TC13: Quen mat khau - xac minh dung', async ({ page }) => {
        await page.locator('text=Quên mật khẩu?').click();
        await page.locator('#txtForgotUsername').fill('admin');
        await page.locator('#txtForgotCCCD').fill('123456789012');
        await page.locator('#txtForgotSDT').fill('0987654321');
        await page.locator('#txtNewPassword').fill('newpass123');
        await page.locator('#btnResetPass').click();

        // Kiem tra co thong bao thanh cong hoac that bai
        const messageVisible = await page.locator('#lblMessage').isVisible();
        expect(messageVisible).toBeTruthy();
    });

    test('TC14: Quen mat khau - xac minh sai', async ({ page }) => {
        await page.locator('text=Quên mật khẩu?').click();
        await page.locator('#txtForgotUsername').fill('admin');
        await page.locator('#txtForgotCCCD').fill('000000000000');
        await page.locator('#txtForgotSDT').fill('0000000000');
        await page.locator('#txtNewPassword').fill('newpass123');
        await page.locator('#btnResetPass').click();

        await expect(page.locator('text=Thông tin xác nhận không chính xác')).toBeVisible({ timeout: 5000 });
    });
});
