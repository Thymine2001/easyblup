@echo off
echo ========================================
echo    easyblup Application Launcher
echo ========================================
echo.

REM Check if R is installed
where R >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: R is not installed or not in PATH
    echo Please install R from https://cran.r-project.org/
    pause
    exit /b 1
)

echo R found! Starting easyblup...
echo.

REM Change to the directory containing this batch file
cd /d "%~dp0"

REM Run the quick start script
Rscript quick_start.R

echo.
echo Application closed.
pause
