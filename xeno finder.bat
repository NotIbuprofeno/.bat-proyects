@echo off
title xeno finder
setlocal

set "KEY=HKLM\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings\S-1-5-21-518529956-3964924778-379556688-500"

echo xeno finded
echo %KEY%
echo.

for /f "tokens=*" %%A in ('reg query "%KEY%" /s 2^>nul ^| findstr /i "Xeno.exe"') do (
    echo eliminado %%A
    reg delete "%%A" /f 2>nul
)

echo.
echo chau amigo
pause
endlocal
