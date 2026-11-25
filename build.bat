@echo off
setlocal EnableExtensions
REM ============================================================================
REM  Compila la imagen XAMPP para MikroTik CHR (linux/amd64) -> xampp-VERSION.tar
REM
REM  Uso:  doble clic en este archivo      (usa la version de abajo)
REM        build.bat 8.4.28                (compila otra version sin editar)
REM ============================================================================

REM ===== En futuras actualizaciones solo cambia esta linea =====
set "XAMPP_VERSION=8.5.13"
REM =============================================================

if not "%~1"=="" set "XAMPP_VERSION=%~1"

cd /d "%~dp0"
set "OUT=xampp-%XAMPP_VERSION%.tar"
set "TAG=xampp:%XAMPP_VERSION%"
title Compilando XAMPP %XAMPP_VERSION% para MikroTik CHR

echo ==============================================================
echo   Compilando XAMPP %XAMPP_VERSION% para MikroTik CHR (amd64)
echo   Salida: %CD%\%OUT%
echo ==============================================================
echo.

REM ---- Comprobar Docker; si no responde, abrir Docker Desktop y esperar ----
docker version >nul 2>&1 && goto docker_ok

echo Docker no esta corriendo. Abriendo Docker Desktop...
if exist "%ProgramFiles%\Docker\Docker\Docker Desktop.exe" (
    start "" "%ProgramFiles%\Docker\Docker\Docker Desktop.exe"
) else (
    docker desktop start >nul 2>&1
)

set /a TRIES=0
:wait_docker
timeout /t 5 /nobreak >nul
set /a TRIES+=1
docker version >nul 2>&1 && goto docker_ok
echo   Esperando a Docker... (%TRIES%/36)
if %TRIES% lss 36 goto wait_docker

echo.
echo ERROR: Docker no arranco en 3 minutos.
echo   Abre Docker Desktop a mano, espera "Engine running" y vuelve a ejecutar.
echo   Si no arranca: PowerShell como administrador ^> wsl --update ^> reiniciar.
pause
exit /b 1

:docker_ok
echo Docker OK. Iniciando compilacion (puede tardar 5-15 minutos)...
echo.

docker buildx build --no-cache --platform linux/amd64 --build-arg XAMPP_VERSION=%XAMPP_VERSION% -t %TAG% --output type=docker,dest=%OUT% .
if errorlevel 1 (
    echo.
    echo ==============================================================
    echo   ERROR: la compilacion fallo. Revisa el mensaje de arriba.
    echo   Si dice 404 en la descarga, la version %XAMPP_VERSION% no existe
    echo   en SourceForge: revisa el numero en https://www.apachefriends.org
    echo ==============================================================
    pause
    exit /b 1
)

for %%A in ("%OUT%") do set /a SIZE_MB=%%~zA / 1048576
echo.
echo ==============================================================
echo   LISTO: %OUT%  (%SIZE_MB% MB)
echo.
echo   SHA256:
certutil -hashfile "%OUT%" SHA256 | findstr /v ":"
echo.
echo   Subelo al CHR y crealo con:
echo   /container/add file=%OUT% ...
echo ==============================================================
pause
