@echo off
setlocal EnableExtensions EnableDelayedExpansion

echo.
echo ======================================
echo   Portable environment configuration
echo ======================================
echo.

set "BASE=%~dp0"
if "%BASE:~-1%"=="\" set "BASE=%BASE:~0,-1%"

echo [INFO] Portable root - "%BASE%"

setx PORTABLE_ROOT "%BASE%" >nul
set "PORTABLE_ROOT=%BASE%"

echo.
echo [SECTION] Paths
powershell -ExecutionPolicy Bypass -File "%BASE%\_tools\core\add_path.ps1" "%BASE%\_tools\config\paths.list"

echo [SECTION] Environment vars
powershell -ExecutionPolicy Bypass -File "%BASE%\_tools\core\add_env.ps1" "%BASE%\_tools\config\env.list"

echo [SECTION] File associations
powershell -ExecutionPolicy Bypass -File "%BASE%\_tools\core\add_assoc.ps1" "%BASE%\_tools\config\assoc.list"

echo [SECTION] Start menu
powershell -ExecutionPolicy Bypass -File "%BASE%\_tools\core\add_shortcuts.ps1" ^
    "%BASE%\_tools\config\startmenu.list" ^
    "%APPDATA%\Microsoft\Windows\Start Menu\Programs\PortableTools"

echo [SECTION] Startup
powershell -ExecutionPolicy Bypass -File "%BASE%\_tools\core\add_shortcuts.ps1" ^
    "%BASE%\_tools\config\startup.list" ^
    "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

echo.
echo ========================================
echo   CONFIGURATION COMPLETE
echo ========================================
pause
