# ==========================================================
#   Dump BAM Registry Keys as SYSTEM
# ==========================================================

# Check if running as SYSTEM
$currentUser = (whoami)
if ($currentUser -ne "nt authority\system") {

    Write-Host "[*] No estás ejecutando como SYSTEM."
    Write-Host "[*] Creando tarea temporal para elevar a SYSTEM..."

    $taskName = "DumpBAM_SYSTEM"

    schtasks /Create /TN $taskName /SC ONCE /ST 00:00 `
        /RL HIGHEST /RU "SYSTEM" `
        /TR "powershell.exe -ExecutionPolicy Bypass -File `"$PSCommandPath`"" > $null 2>&1

    Write-Host "[*] Ejecutando tarea..."
    schtasks /Run /TN $taskName > $null 2>&1

    Write-Host "[*] Eliminando tarea temporal..."
    schtasks /Delete /TN $taskName /F > $null 2>&1

    exit
}

Write-Host "[+] Ejecutando como SYSTEM. Procediendo con el dump..."

$out = "$PSScriptRoot\bam_dump.txt"

"========== DUMP BAM ==========" | Out-File $out

# Listado de claves BAM
$bamPaths = @(
    "HKLM:\SYSTEM\CurrentControlSet\Services\bam\UserSettings",
    "HKLM:\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings"
)

foreach ($path in $bamPaths) {

    "`n===============================" | Out-File $out -Append
    "CLAVE: $path" | Out-File $out -Append

    try {
        $item = Get-Item $path
        "Última modificación: $($item.LastWriteTime)" | Out-File $out -Append
    }
    catch {
        "Error leyendo la fecha: $_" | Out-File $out -Append
    }

    "`n-- Dump completo --" | Out-File $out -Append

    Get-ChildItem $path -Recurse | ForEach-Object {
        try {
            "`nRuta: $($_.Name)" | Out-File $out -Append
            (Get-ItemProperty $_.PsPath) | Out-File $out -Append
        }
        catch {
            "Error: $_" | Out-File $out -Append
        }
    }
}

"`n[+] COMPLETADO. Archivo guardado en:" | Out-File $out -Append
$out | Out-File $out -Append

Write-Host "`n[✓] Dump finalizado."
Write-Host "[✓] Archivo generado: $out"
