@echo off
chcp 65001 > nul
title He Thong Quan Ly Nhan Vien - Chay Kiem Tra Tu Dong

echo.
echo ============================================================
echo         HE THONG QUAN LY NHAN VIEN - IPLUS
echo            CHAY KIEM TRA TU DONG (PLAYWRIGHT)
echo ============================================================
echo.

set TESTER_DIR=d:\Downloads_Moi\QLNhanVien\QLNhanVien\Tester

:: ---------------------------------------------------------
:: BUOC 1: Kiem tra server co chay khong
:: ---------------------------------------------------------
echo [1/3] Kiem tra he thong tren http://localhost:8080 ...
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:8080/Pages/Auth/Login.aspx' -TimeoutSec 5; if ($r.StatusCode -eq 200) { exit 0 } else { exit 1 } } catch { exit 1 }" > nul 2>&1
if %errorlevel%==0 (
    echo       [OK]  Server dang chay. Tien hanh kiem tra...
) else (
    echo       [LOI] Khong ket noi duoc toi http://localhost:8080
    echo             Hay chay file KHOI_DONG_HE_THONG.bat truoc!
    echo.
    pause
    exit /b 1
)

:: ---------------------------------------------------------
:: BUOC 2: Kiem tra node_modules
:: ---------------------------------------------------------
echo.
echo [2/3] Kiem tra thu vien Playwright...
if not exist "%TESTER_DIR%\node_modules" (
    echo       [..] Chua co thu vien. Dang cai dat (lan dau chay mat ~2 phut)...
    pushd "%TESTER_DIR%"
    npm install > nul 2>&1
    npx playwright install chromium > nul 2>&1
    popd
    echo       [OK]  Cai dat xong!
) else (
    echo       [OK]  Thu vien da san sang.
)

:: ---------------------------------------------------------
:: BUOC 3: Chay tat ca test
:: ---------------------------------------------------------
echo.
echo [3/3] Bat dau chay kiem tra...
echo       (Ket qua se hien thi ben duoi)
echo.
echo ---------------------------------------------------------

pushd "%TESTER_DIR%"

:: Cho phep nguoi dung chon che do
set /p CHE_DO="  Chay che do nao? (1=Tat ca nhanh, 2=Co hien thi trinh duyet, 3=Chi 1 file): "

if "%CHE_DO%"=="1" (
    echo.
    echo  Dang chay TAT CA test (an trinh duyet)...
    npx playwright test --reporter=list
) else if "%CHE_DO%"=="2" (
    echo.
    echo  Dang chay TAT CA test (hien thi trinh duyet)...
    npx playwright test --headed --reporter=list
) else if "%CHE_DO%"=="3" (
    echo.
    echo  Cac file test hien co:
    echo  ---------------------------------------------------------
    echo   01 - Kiem tra dang nhap va dang ky
    echo   02 - Kiem tra trang tong quan (Dashboard)
    echo   03 - Kiem tra quan ly danh sach nhan vien
    echo   04 - Kiem tra quan ly luong
    echo   05 - Kiem tra quan ly cong tac / nghi phep (Admin)
    echo   06 - Kiem tra hop thu nghi phep (nhan vien)
    echo   07 - Kiem tra trang thong ke
    echo   08 - Kiem tra trang phong ban va chuc vu
    echo   09 - Kiem tra trang tai khoan he thong
    echo   10 - Kiem tra ho so ca nhan (nhan vien)
    echo   11 - Kiem tra bang luong ca nhan (nhan vien)
    echo   12 - Kiem tra thanh dieu huong (Site Master)
    echo  ---------------------------------------------------------
    set /p SO_FILE="  Nhap so file muon chay (01-12): "
    set FILE_TEN=0%SO_FILE%
    if "%SO_FILE%"=="1"  set FILE_TEN=01
    if "%SO_FILE%"=="2"  set FILE_TEN=02
    if "%SO_FILE%"=="3"  set FILE_TEN=03
    if "%SO_FILE%"=="4"  set FILE_TEN=04
    if "%SO_FILE%"=="5"  set FILE_TEN=05
    if "%SO_FILE%"=="6"  set FILE_TEN=06
    if "%SO_FILE%"=="7"  set FILE_TEN=07
    if "%SO_FILE%"=="8"  set FILE_TEN=08
    if "%SO_FILE%"=="9"  set FILE_TEN=09
    if "%SO_FILE%"=="10" set FILE_TEN=10
    if "%SO_FILE%"=="11" set FILE_TEN=11
    if "%SO_FILE%"=="12" set FILE_TEN=12
    echo.
    echo  Dang chay file %FILE_TEN%_*.spec.ts --headed...
    npx playwright test %FILE_TEN%_ --headed --reporter=list
) else (
    echo.
    echo  Dang chay TAT CA test (mac dinh)...
    npx playwright test --reporter=list
)

popd

echo.
echo ---------------------------------------------------------
echo.
if %errorlevel%==0 (
    echo ============================================================
    echo  [OK]  TAT CA KIEM TRA DEU THANH CONG!
    echo ============================================================
) else (
    echo ============================================================
    echo  [LOI] CO MOT SO KIEM TRA THAT BAI.
    echo  Xem chi tiet o thu muc: Tester\test-results\
    echo ============================================================
)
echo.
echo  Nhan phim bat ky de dong...
pause > nul
