@echo off
"%windir%\System32\inetsrv\appcmd.exe" list site
"%windir%\System32\inetsrv\appcmd.exe" add site /name:"QLNhanVien" /physicalPath:"D:\Downloads_Moi\QLNhanVien\QLNhanVien" /bindings:http/*:8080:
"%windir%\System32\inetsrv\appcmd.exe" start site /site.name:"QLNhanVien"
echo DONE > D:\Downloads_Moi\QLNhanVien\QLNhanVien\iis_result.txt
