@echo off
title Scheme Guard 2.0 - One-Click Launcher
color 0B
cd /d "%~dp0"

echo ===============================================================================
echo                SCHEME GUARD 2.0 - MoSPI NATIONAL AI VIGILANCE PLATFORM
echo                           ONE-CLICK LOCAL LAUNCHER
echo ===============================================================================
echo.

:: 1. Verify Python availability
python --version >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR] Python is not found in your system PATH!
    echo Please install Python 3.10+ from https://python.org and add it to PATH.
    echo.
    pause
    exit /b 1
)
echo [OK] Python detected.

:: 2. Verify Node / npm availability
call npm --version >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR] Node.js / npm is not found in your system PATH!
    echo Please install Node.js 18+ from https://nodejs.org and add it to PATH.
    echo.
    pause
    exit /b 1
)
echo [OK] Node.js and npm detected.

:: 3. Check Frontend node_modules
if not exist "Frontend\node_modules" (
    echo.
    echo [*] Frontend dependencies not found. Installing node packages (first-time setup)...
    cd /d "%~dp0Frontend"
    call npm install
    cd /d "%~dp0"
    echo [OK] Frontend packages installed.
)

:: 4. Launch Backend API Server in a dedicated terminal window
echo.
echo [*] Starting Backend Intelligence Engine on http://127.0.0.1:8000 ...
start "Scheme Guard - Backend API (Port 8000)" cmd /k "cd /d \"%~dp0Backend\" && title Scheme Guard - Backend API (Port 8000) && color 0A && echo [Scheme Guard Backend Engine - Live] && python -m uvicorn app.main:app --host 127.0.0.1 --port 8000"

:: 5. Launch Frontend Dev Server in a dedicated terminal window
echo [*] Starting Frontend UI Portal on http://localhost:5173 ...
start "Scheme Guard - Frontend UI (Port 5173)" cmd /k "cd /d \"%~dp0Frontend\" && title Scheme Guard - Frontend UI (Port 5173) && color 09 && echo [Scheme Guard Frontend Portal - Live] && npm run dev"

:: 6. Wait a few seconds for services to initialize, then launch default web browser
echo [*] Waiting 3 seconds for microservices to initialize...
timeout /t 3 /nobreak >nul

echo [*] Opening Scheme Guard in your default web browser...
start http://localhost:5173

echo.
echo ===============================================================================
echo [SUCCESS] Scheme Guard is now running locally!
echo.
echo  - Frontend Portal:    http://localhost:5173
echo  - Backend API Docs:   http://127.0.0.1:8000/docs
echo  - Health Endpoint:    http://127.0.0.1:8000/api/v1/health
echo.
echo  To stop all services anytime, run: stop_project.bat
echo ===============================================================================
echo.
echo Press any key to close this launcher window (services will stay running)...
pause >nul
