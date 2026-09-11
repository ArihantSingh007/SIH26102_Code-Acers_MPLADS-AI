<#
.SYNOPSIS
    One-click local startup script for Scheme Guard 2.0 (FastAPI Backend + Vite Frontend)
.DESCRIPTION
    Launches Backend on port 8000 and Frontend on port 5173, and opens browser automatically.
#>

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

Write-Host "===============================================================================" -ForegroundColor Cyan
Write-Host "         SCHEME GUARD 2.0 - MoSPI NATIONAL AI VIGILANCE PLATFORM" -ForegroundColor Cyan
Write-Host "                    ONE-CLICK POWERSHELL LAUNCHER" -ForegroundColor Cyan
Write-Host "===============================================================================" -ForegroundColor Cyan
Write-Host ""

# Check Python
try {
    $pyVer = python --version 2>&1
    Write-Host "[OK] $pyVer detected." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Python is not found in PATH. Please install Python 3.10+." -ForegroundColor Red
    exit 1
}

# Check Node / npm
try {
    $nodeVer = node --version 2>&1
    Write-Host "[OK] Node.js $nodeVer detected." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Node.js is not found in PATH. Please install Node.js 18+." -ForegroundColor Red
    exit 1
}

# Check Frontend node_modules
if (-not (Test-Path "$ScriptDir\Frontend\node_modules")) {
    Write-Host "[*] Installing Frontend packages (first-time setup)..." -ForegroundColor Yellow
    Set-Location "$ScriptDir\Frontend"
    npm install
    Set-Location $ScriptDir
}

Write-Host "[*] Launching Backend on http://127.0.0.1:8000 ..." -ForegroundColor Yellow
Start-Process cmd.exe -ArgumentList "/k cd /d `"$ScriptDir\Backend`" && title Scheme Guard - Backend API (Port 8000) && color 0A && echo [Scheme Guard Backend Engine - Live] && python -m uvicorn app.main:app --host 127.0.0.1 --port 8000"

Write-Host "[*] Launching Frontend on http://localhost:5173 ..." -ForegroundColor Yellow
Start-Process cmd.exe -ArgumentList "/k cd /d `"$ScriptDir\Frontend`" && title Scheme Guard - Frontend UI (Port 5173) && color 09 && echo [Scheme Guard Frontend Portal - Live] && npm run dev"

Write-Host "[*] Waiting 3 seconds before opening browser..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

Write-Host "[*] Opening http://localhost:5173 in browser..." -ForegroundColor Green
Start-Process "http://localhost:5173"

Write-Host ""
Write-Host "===============================================================================" -ForegroundColor Green
Write-Host " [SUCCESS] Scheme Guard is now live!" -ForegroundColor Green
Write-Host "  - Frontend Portal:  http://localhost:5173" -ForegroundColor White
Write-Host "  - Backend Swagger:  http://127.0.0.1:8000/docs" -ForegroundColor White
Write-Host "  - Health Check:     http://127.0.0.1:8000/api/v1/health" -ForegroundColor White
Write-Host ""
Write-Host "  To stop all services, run: .\stop_project.bat" -ForegroundColor White
Write-Host "===============================================================================" -ForegroundColor Green
