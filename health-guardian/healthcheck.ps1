# Name: System Health Guardian
# Description: Automated DISM, SFC, and Chkdsk integrity check after power failure or crashes.
# License: MIT
$ErrorActionPreference = "Stop"

# 0. Check for Administrative Privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Pause ; exit
}

Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "                   SYSTEM HEALTH GUARDIAN                 " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. DISM - Deployment Image Servicing and Management
Write-Host "`n[1/3] Checking System Image Integrity (DISM)..." -ForegroundColor Yellow
# Fast check for corruption
$dismCheck = dism /online /cleanup-image /checkhealth
if ($dismCheck -match "corrupt") {
    Write-Host "Corruption detected! Starting deep repair..." -ForegroundColor Magenta
    dism /online /cleanup-image /restorehealth
} else {
    Write-Host "SUCCESS: System image is healthy. Deep repair skipped." -ForegroundColor Green
}

# 2. SFC - System File Checker
Write-Host "`n[2/3] Verifying System Files (SFC)..." -ForegroundColor Yellow
sfc /scannow

# 3. Chkdsk - Disk Structure Repair
$SystemDrive = $env:SystemDrive
Write-Host "`n[3/3] Scheduling Disk Check on $SystemDrive..." -ForegroundColor Yellow

try {
    # Using fsutil to set the dirty bit is a more performance-oriented way to trigger boot-time repair
    # Alternatively, using the standard chkdsk schedule command
    $chkdskCommand = "echo Y | chkdsk $SystemDrive /f"
    Start-Process cmd.exe -ArgumentList "/c $chkdskCommand" -WindowStyle Hidden
    Write-Host "SUCCESS: Disk repair scheduled for the next reboot." -ForegroundColor Green
} catch {
    Write-Host "FAILURE: Could not schedule Chkdsk. Please run 'chkdsk /f' manually." -ForegroundColor Red
}

Write-Host "`n" + "-"*30 -ForegroundColor Green
Write-Host "MAINTENANCE PROCESS COMPLETED!" -ForegroundColor Green
Write-Host "Windows will verify your drive during the next boot sequence." -ForegroundColor White

$selection = Read-Host "`nWould you like to restart your computer now? (Y/N)"
if ($selection -match "Y|y") {
    Write-Host "Restarting in 5 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    Restart-Computer -Force
} else {
    Write-Host "Restart cancelled. Remember to reboot manually to apply disk repairs." -ForegroundColor Cyan
}