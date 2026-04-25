@echo off
setlocal EnableExtensions EnableDelayedExpansion

echo ========================================
echo   Portable ENV CLEANUP (LIST-BASED)
echo ========================================
echo.

set "BASE=%~dp0"
if "%BASE:~-1%"=="\" set "BASE=%BASE:~0,-1%"

set "FTA=%BASE%\SetUserFTA\SetUserFTA.exe"
set "PROGID=%BASE%\ProgIDTool\ProgIDTool.exe"

echo [SECTION] Start menu

set "SM=%APPDATA%\Microsoft\Windows\Start Menu\Programs\PortableTools"

if exist "%SM%" (
    echo [DEL] %SM%
    rmdir /s /q "%SM%"
) else (
    echo [SKIP] Start Menu folder not found
)
echo.

echo [SECTION] File associations
powershell -ExecutionPolicy Bypass -File "%BASE%\_config\assoc_remove.ps1" "%BASE%\_config\assoc.list"
echo.

echo [SECTION] Paths
powershell -ExecutionPolicy Bypass -File "%BASE%\_config\remove_paths.ps1"
echo.

echo [SECTION] Environment vars
powershell -ExecutionPolicy Bypass -File "%BASE%\_config\remove_env.ps1" "%BASE%\_config\env.list"
echo.

echo.
echo ========================================
echo   CLEAN COMPLETE
echo ========================================
pause
