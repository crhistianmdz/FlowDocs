@echo off
REM Script de doble click para pasar HU de docs/tasks a GitHub Issues
REM Solo ejecutar este archivo - no requiere terminal

echo.
echo ========================================
echo   HU a GitHub Issues - Doble Click
echo ========================================
echo.

REM Verificar que gh está instalado
where gh >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: GitHub CLI (gh) no está instalado
    echo    Descarga desde: https://cli.github.com/
    echo.
    pause
    exit /b 1
)

REM Verificar que está en un repo de git
gh repo view >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: No estás en un repositorio Git
    echo.
    pause
    exit /b 1
)

REM Ejecutar el script de PowerShell silenciosamente
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -Command "& { ./scripts/hu-to-issues.ps1 }"

echo.
echo ========================================
echo   Proceso completado
echo ========================================
echo.
pause