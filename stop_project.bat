@echo off
title Scheme Guard 2.0 - Stop All Services
color 0E
cd /d "%~dp0"

echo ===============================================================================
echo                SCHEME GUARD 2.0 - CLEAN PROCESS SHUTDOWN
echo ===============================================================================
echo.

echo [*] Stopping services listening on port 8000 (Backend API)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8000" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a >nul 2>&1
    echo [OK] Stopped process %%a on port 8000
)

echo [*] Stopping services listening on port 5173 (Frontend Dev Server)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":5173" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a >nul 2>&1
    echo [OK] Stopped process %%a on port 5173
)

echo.
echo ===============================================================================
echo [DONE] All Scheme Guard local services have been stopped.
echo ===============================================================================
echo.
pause
