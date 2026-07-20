import { test, expect } from '@playwright/test';

const BASE_URL = 'http://localhost:8080';

test.describe('TEST 08: PHONG BAN & CHUC VU - THEM/SUA/XOA', () => {

    test.beforeEach(async ({ page }) => {
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('admin');
        await page.locator('#txtLoginPassword').fill('admin123');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);
        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachPhongBan.aspx`);
    });

    // ──────── HIỂN THỊ ────────

    test('TC01: Hien thi trang phong ban va chuc vu', async ({ page }) => {
        await expect(page.locator('text=Phòng ban & Chức vụ').first()).toBeVisible();
    });

    test('TC02: Hien thi danh sach phong ban co du lieu', async ({ page }) => {
        const gridPB = page.locator('#MainContent_gvPhongBan');
        await expect(gridPB).toBeVisible();
        const rows = gridPB.locator('tbody tr');
        expect(await rows.count()).toBeGreaterThan(0);
    });

    test('TC03: Hien thi danh sach chuc vu co du lieu', async ({ page }) => {
        const gridCV = page.locator('#MainContent_gvChucVu');
        await expect(gridCV).toBeVisible();
        const rows = gridCV.locator('tbody tr');
        expect(await rows.count()).toBeGreaterThan(0);
    });

    test('TC04: Hien thi nut "Them phong ban" va "Them chuc vu"', async ({ page }) => {
        await expect(page.locator('#MainContent_btnShowAddPB')).toBeVisible();
        await expect(page.locator('#MainContent_btnShowAddCV')).toBeVisible();
    });

    test('TC05: Hien thi cot Thao tac trong bang phong ban', async ({ page }) => {
        await expect(page.locator('#MainContent_gvPhongBan th:has-text("Thao tác")')).toBeVisible();
    });

    // ──────── THÊM PHÒNG BAN ────────

    test('TC06: Mo form them phong ban khi bam nut', async ({ page }) => {
        await page.locator('#MainContent_btnShowAddPB').click();
        await page.waitForTimeout(500);
        await expect(page.locator('#MainContent_pnlFormPB')).toBeVisible();
        await expect(page.locator('#MainContent_txtTenPB')).toBeVisible();
        await expect(page.locator('#MainContent_txtMoTaPB')).toBeVisible();
    });

    test('TC07: Them phong ban moi thanh cong', async ({ page }) => {
        await page.locator('#MainContent_btnShowAddPB').click();
        await page.waitForTimeout(500);
        const tenPB = `Phong Test ${Date.now()}`;
        await page.locator('#MainContent_txtTenPB').fill(tenPB);
        await page.locator('#MainContent_txtMoTaPB').fill('Phong ban kiem tra tu dong');
        await page.locator('#MainContent_btnLuuPB').click();
        await page.waitForTimeout(1500);
        await expect(page.locator('.alert-success')).toBeVisible({ timeout: 5000 });
        // Dữ liệu mới phải hiện trong bảng
        await expect(page.locator(`text=${tenPB}`)).toBeVisible();
    });

    test('TC08: Them phong ban that bai - ten trong', async ({ page }) => {
        await page.locator('#MainContent_btnShowAddPB').click();
        await page.waitForTimeout(500);
        await page.locator('#MainContent_txtTenPB').fill('');
        await page.locator('#MainContent_btnLuuPB').click();
        await page.waitForTimeout(1000);
        await expect(page.locator('.alert-danger')).toBeVisible({ timeout: 5000 });
    });

    test('TC09: Huy form them phong ban', async ({ page }) => {
        await page.locator('#MainContent_btnShowAddPB').click();
        await page.waitForTimeout(500);
        await expect(page.locator('#MainContent_pnlFormPB')).toBeVisible();
        await page.locator('#MainContent_btnHuyPB').click();
        await page.waitForTimeout(500);
        await expect(page.locator('#MainContent_pnlFormPB')).toBeHidden();
    });

    // ──────── THÊM CHỨC VỤ ────────

    test('TC10: Mo form them chuc vu khi bam nut', async ({ page }) => {
        await page.locator('#MainContent_btnShowAddCV').click();
        await page.waitForTimeout(500);
        await expect(page.locator('#MainContent_pnlFormCV')).toBeVisible();
        await expect(page.locator('#MainContent_txtTenCV')).toBeVisible();
        await expect(page.locator('#MainContent_txtHeSoLuong')).toBeVisible();
    });

    test('TC11: Them chuc vu moi thanh cong', async ({ page }) => {
        await page.locator('#MainContent_btnShowAddCV').click();
        await page.waitForTimeout(500);
        const tenCV = `Chuc Vu Test ${Date.now()}`;
        await page.locator('#MainContent_txtTenCV').fill(tenCV);
        await page.locator('#MainContent_txtHeSoLuong').fill('1.5');
        await page.locator('#MainContent_btnLuuCV').click();
        await page.waitForTimeout(1500);
        await expect(page.locator('.alert-success')).toBeVisible({ timeout: 5000 });
        await expect(page.locator(`text=${tenCV}`)).toBeVisible();
    });

    test('TC12: Them chuc vu that bai - he so luong khong hop le', async ({ page }) => {
        await page.locator('#MainContent_btnShowAddCV').click();
        await page.waitForTimeout(500);
        await page.locator('#MainContent_txtTenCV').fill('Chuc Vu Loi');
        await page.locator('#MainContent_txtHeSoLuong').fill('abc');
        await page.locator('#MainContent_btnLuuCV').click();
        await page.waitForTimeout(1000);
        await expect(page.locator('.alert-danger')).toBeVisible({ timeout: 5000 });
    });

    // ──────── PHÂN QUYỀN ────────

    test('TC13: NhanVien khong vao duoc trang phong ban', async ({ page }) => {
        await page.context().clearCookies();
        await page.goto(`${BASE_URL}/Pages/Auth/Login.aspx`);
        await page.locator('#txtLoginUsername').fill('nvvan');
        await page.locator('#txtLoginPassword').fill('nvvan');
        await page.locator('#btnLogin').click();
        await page.waitForTimeout(1000);
        await page.goto(`${BASE_URL}/Pages/Admin/DanhSachPhongBan.aspx`);
        await expect(page).toHaveURL(/.*Login(\.aspx)?|.*Default/, { timeout: 5000 });
    });

    test('TC14: QuanLy khong vao duoc trang phong ban (chi Admin)', async ({ page }) => {
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
