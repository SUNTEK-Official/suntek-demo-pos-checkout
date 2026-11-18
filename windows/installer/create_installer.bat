@chcp 65001 >nul
@echo off
set IFW_PATH="C:\Qt\QtIFW-4.8.0\bin"
set INSTALLER_NAME=SuntekCheckout_1.0_Setup.exe

echo 正在生成安装包...
%IFW_PATH%\binarycreator.exe ^
    --offline-only ^
    -c config\config.xml ^
    -p packages ^
    --include com.suntek.checkout ^   <!-- ✅ 关键修复 -->
    %INSTALLER_NAME%

if %ERRORLEVEL% == 0 (
    echo.
    echo ✅ 安装包已生成：%CD%\%INSTALLER_NAME%
    echo 双击即可安装 SuntekCheckout！
) else (
    echo ❌ 打包失败，请检查路径和文件。
)
pause