@echo off
title delete slinky
color 0A

set "KEY=HKLM\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings\S-1-5-21-518529956-3964924778-379556688-500"

set "OUT=%~dp0slinkyloader_results.txt"

echo Buscando "slinkyloader.exe" en:
echo %KEY%
echo.

reg query "%KEY%" /s 2>nul | findstr /i "slinkyloader.exe" > "%OUT%"

if %errorlevel% neq 0 (
    echo No se encontraron coincidencias o no se pudo acceder a la clave.
    echo.
    pause
    exit /b
)


choice /m "¿Deseas eliminar las entradas encontradas del Registro?"
if errorlevel 2 (
    echo Operacion cancelada por el usuario.
    pause
    exit /b
)

echo.
echo Eliminando entradas que contengan "slinkyloader.exe"...
echo (Esto requiere permisos de administrador)
echo.

for /f "tokens=*" %%A in ('reg query "%KEY%" /s ^| findstr /i "slinkyloader.exe"') do (
    echo Eliminando: %%A
    reg delete "%%A" /f >nul 2>&1
)

echo.
echo Proceso completado.
pause