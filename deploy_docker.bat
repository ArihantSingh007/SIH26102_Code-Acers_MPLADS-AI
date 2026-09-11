@echo off
title Scheme Guard 2.0 - One-Click Docker Deployment
color 0B
cd /d "%~dp0"

echo ===============================================================================
echo            SCHEME GUARD 2.0 - ONE-CLICK LOCAL DOCKER DEPLOYMENT
echo ===============================================================================
echo.

:: Check Docker CLI
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERROR] Docker is not installed or not in your PATH!
    echo Please install Docker Desktop from https://www.docker.com/products/docker-desktop/
    echo.
    pause
    exit /b 1
)

echo [OK] Docker detected.
echo [*] Building and starting containers (MongoDB, Backend FastAPI, Frontend Nginx)...
docker compose up --build -d

if %errorlevel% neq 0 (
    color 0C
    echo.
    echo [ERROR] Docker compose failed to start containers. Please verify Docker Desktop is running.
    echo.
    pause
    exit /b 1
)

echo.
echo [*] Waiting 4 seconds for production container health checks...
timeout /t 4 /nobreak >nul

echo [*] Opening deployed portal in browser...
start http://localhost:3000

echo.
echo ===============================================================================
echo [SUCCESS] Scheme Guard is now deployed locally in Docker!
echo.
echo  - Production Frontend:  http://localhost:3000
echo  - Backend API:          http://localhost:8000
echo  - Interactive Swagger:  http://localhost:8000/docs
echo  - MongoDB Service:      localhost:27017
echo.
echo  To view container logs: docker compose logs -f
echo  To tear down:           docker compose down
echo ===============================================================================
echo.
pause
