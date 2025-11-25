@echo off
setlocal

echo pone el directorio del archivo .exe
set /p archivo=Ruta: 

if not exist "%archivo%" (
    echo El archivo no existe :"V
    pause
    exit /b
)

echo Copiando archivo a C:\Windows
copy "%archivo%" "C:\Windows" >nul

if %errorlevel%==0 (
    echo Archivo copiado
    echo ya puedes ejecutarlo desde el Windows + R
) else (
    echo Error: No se pudo copiar. Ejecuta este .bat como Administrador.
)

pause
