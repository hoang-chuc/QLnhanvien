import { test, expect } from '@playwright/test';

const BASE_URL = 'http://localhost:8080';

test.describe('TEST 03: QUAN LY NHAN VIEN - CRUD + TIM KIEM', () => {

    test.beforeEach(async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#txtLoginPassword').fill('123456');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);
        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachNhanVien.aspx`);
    });

    // ==================== PHAN 1: XEM DANH SACH ====================

    test('TC01: Hien thi danh sach nhan vien', async ({ page }) => {
        await expect(page.getByRole('heading', { name: 'Quản lý nhân viên' })).toBeVisible();
        await expect(page.locator('#MainContent_btnShowThem')).toBeVisible();
        await expect(page.locator('#MainContent_txtSearch')).toBeVisible();
    });

    test('TC02: Bang nhan vien co du lieu', async ({ page }) => {
        const rows = page.locator('#MainContent_gvNhanVien tr');
        const count = await rows.count();
        expect(count).toBeGreaterThan(1); // > 1 vi dong dau la header
    });

    // ==================== PHAN 2: TIM KIEM ====================

    test('TC03: Tim kiem nhan vien theo ten', async ({ page }) => {
        await page.locator('#MainContent_txtSearch').fill('Nguyễn');
        await page.locator('#MainContent_btnSearch').click();
        await page.waitForTimeout(1000);
        const rows = page.locator('#MainContent_gvNhanVien tr');
        const count = await rows.count();
        expect(count).toBeGreaterThanOrEqual(1);
    });

    test('TC04: Tim kiem khong co ket qua', async ({ page }) => {
        await page.locator('#MainContent_txtSearch').fill('ZZZZZZZZZZZZZ');
        await page.locator('#MainContent_btnSearch').click();
        await page.waitForTimeout(1000);
        // Khong co dong nao hoac chi co header
        const rows = page.locator('#MainContent_gvNhanVien tr');
        const count = await rows.count();
        expect(count).toBeLessThanOrEqual(1);
    });

    // ==================== PHAN 3: THEM NHAN VIEN ====================

    test('TC05: Hien form them nhan vien', async ({ page }) => {
        await page.locator('#MainContent_btnShowThem').click();
        await expect(page.locator('text=Thêm nhân viên mới').first()).toBeVisible();
        await expect(page.locator('#MainContent_txtHoTen')).toBeVisible();
        await expect(page.locator('#MainContent_txtNgaySinh')).toBeVisible();
        await expect(page.locator('#MainContent_txtCCCD')).toBeVisible();
        await expect(page.locator('#MainContent_txtSDT')).toBeVisible();
        await expect(page.locator('#MainContent_txtLuong')).toBeVisible();
    });

    test('TC06: Them nhan vien moi thanh cong', async ({ page }) => {
        await page.locator('#MainContent_btnShowThem').click();

        const ts = Date.now();
        const sdt = `0900${ts.toString().slice(-6)}`;

        await page.locator('#MainContent_txtHoTen').fill('Test Employee Playwright');
        await page.locator('#MainContent_txtNgaySinh').fill('2000-01-15');
        await page.locator('#MainContent_ddlGioiTinh').selectOption('Nam');
        await page.locator('#MainContent_txtCCCD').fill('123456789012');
        await page.locator('#MainContent_txtSDT').fill(sdt);
        await page.locator('#MainContent_txtEmail').fill('test@playwright.com');
        await page.locator('#MainContent_txtDiaChi').fill('Ha Noi');
        await page.locator('#MainContent_ddlPhongBan').selectOption({ index: 1 });
        await page.locator('#MainContent_ddlChucVu').selectOption({ index: 1 });
        await page.locator('#MainContent_txtLuong').fill('7000000');
        await page.locator('#MainContent_ddlTrangThai').selectOption('Đang làm');
        await page.locator('#MainContent_btnLuu').click();

        page.on('dialog', dialog => dialog.accept());
        await page.waitForTimeout(2000);

        // Quay lai danh sach, kiem tra co nhan vien moi
        await page.locator('#MainContent_txtSearch').fill('Test Employee Playwright');
        await page.locator('#MainContent_btnSearch').click();
        await page.waitForTimeout(1000);
        await expect(page.locator('text=Test Employee Playwright').first()).toBeVisible();
    });

    test('TC07: Huy them nhan vien', async ({ page }) => {
        await page.locator('#MainContent_btnShowThem').click();
        await expect(page.locator('#MainContent_txtHoTen')).toBeVisible();
        await page.locator('#MainContent_btnHuy').click();
        await expect(page.locator('#MainContent_btnShowThem')).toBeVisible();
    });

    // ==================== PHAN 4: SUA NHAN VIEN ====================

    test('TC08: Sua nhan vien - hien form', async ({ page }) => {
        const editBtn = page.locator('#MainContent_gvNhanVien_btnEdit_0');
        if (await editBtn.isVisible()) {
            await editBtn.click();
            await expect(page.locator('#MainContent_txtHoTen')).toBeVisible();
            const hoTenValue = await page.locator('#MainContent_txtHoTen').inputValue();
            expect(hoTenValue).toBeTruthy();
        }
    });

    // ==================== PHAN 5: XOA NHAN VIEN ====================

    test('TC09: Xoa nhan vien - thong bao thanh cong', async ({ page }) => {
        let dialogMessage = '';
        page.on('dialog', async dialog => {
            dialogMessage = dialog.message();
            await dialog.accept();
        });

        const deleteBtn = page.locator('#MainContent_gvNhanVien_btnDelete_0');
        if (await deleteBtn.isVisible()) {
            await deleteBtn.click();
            await page.waitForTimeout(1000);
            expect(dialogMessage).toContain('Xóa');
        }
    });

    // ==================== PHAN 6: PHAN QUYEN ====================

    test('TC10: Nhan vien khong vao duoc trang quan ly', async ({ page }) => {
        // Xoa session admin cu truoc khi login tai khoan khac
        await page.context().clearCookies();
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('nvvan');
        await page.locator('#txtLoginPassword').fill('nvvan');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);

        // Thu truy cap trang quan ly
        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachNhanVien.aspx`);
        await expect(page).toHaveURL(/.*Default|.*Login(\.aspx)?/, { timeout: 5000 });
    });
});
