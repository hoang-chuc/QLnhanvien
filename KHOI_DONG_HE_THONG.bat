@echo off
chcp 65001 > nul
title He Thong Quan Ly Nhan Vien - Khoi Dong

echo.
echo ============================================================
echo         HE THONG QUAN LY NHAN VIEN - IPLUS
echo              DANG KHOI DONG HE THONG...
echo ============================================================
echo.

:: ---------------------------------------------------------
:: BUOC 1: Kiem tra SQL Server
:: ---------------------------------------------------------
echo [1/4] Kiem tra SQL Server...
sc query MSSQL$SQLEXPRESS | find "RUNNING" > nul 2>&1
if %errorlevel%==0 (
    echo       [OK]  SQL Server (SQLEXPRESS) dang chay.
) else (
    echo       [..] SQL Server chua chay. Dang khoi dong...
    net start MSSQL$SQLEXPRESS > nul 2>&1
    timeout /t 3 /nobreak > nul
    sc query MSSQL$SQLEXPRESS | find "RUNNING" > nul 2>&1
    if %errorlevel%==0 (
        echo       [OK] SQL Server da khoi dong thanh cong!
    ) else (
        echo       [LOI] Khong the khoi dong SQL Server!
        echo             Hay mo Services va khoi dong MSSQL$SQLEXPRESS thu cong.
        pause
        exit /b 1
    )
)

:: ---------------------------------------------------------
:: BUOC 2: Build project (bien dich code moi nhat)
:: ---------------------------------------------------------
echo.
echo [2/4] Bien dich ma nguon (Build)...
set MSBUILD="C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
if not exist %MSBUILD% (
    set MSBUILD="C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
)
if not exist %MSBUILD% (
    set MSBUILD="C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
)
if not exist %MSBUILD% (
    set MSBUILD="C:\Program Files\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
)

%MSBUILD% "d:\Downloads_Moi\QLNhanVien\QLNhanVien\QLNhanVien.csproj" /t:Build /p:Configuration=Debug /v:minimal > build_log.txt 2>&1
if %errorlevel%==0 (
    echo       [OK]  Build thanh cong!
) else (
    echo       [LOI] Build that bai! Xem file build_log.txt de biet chi tiet.
    type build_log.txt
    pause
    exit /b 1
)

:: ---------------------------------------------------------
:: BUOC 3: Kiem tra IIS dang chay
:: ---------------------------------------------------------
echo.
echo [3/4] Kiem tra Web Server (IIS) tren cong 8080...

powershell -Command "(New-Object Net.Sockets.TcpClient).Connect('localhost', 8080)" > nul 2>&1
if %errorlevel%==0 (
    echo       [OK]  IIS dang chay tren http://localhost:8080
) else (
    echo       [..] IIS chua chay. Dang khoi dong...
    net start W3SVC > nul 2>&1
    timeout /t 3 /nobreak > nul
    powershell -Command "(New-Object Net.Sockets.TcpClient).Connect('localhost', 8080)" > nul 2>&1
    if %errorlevel%==0 (
        echo       [OK] IIS da khoi dong. He thong san sang!
    ) else (
        echo       [CANH BAO] Cong 8080 chua phan hoi.
        echo             Hay vao IIS Manager va dam bao website QLNhanVien dang chay.
    )
)

:: ---------------------------------------------------------
:: BUOC 4: Mo trinh duyet
:: ---------------------------------------------------------
echo.
echo [4/4] Mo trinh duyet...
timeout /t 2 /nobreak > nul
start "" "http://localhost:8080/Pages/Auth/Login.aspx"
echo       [OK]  Da mo trinh duyet tai http://localhost:8080/Pages/Auth/Login.aspx

echo.
echo ============================================================
echo  [OK]  HE THONG DA SAN SANG!
echo.
echo  Dia chi:  http://localhost:8080
echo  Admin:    admin / admin123
echo  NV mau:   nhanvien1 / 123456
echo ============================================================
echo.
echo  Nhan phim bat ky de dong cua so nay...
pause > nul
