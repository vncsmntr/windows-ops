<#
.SYNOPSIS
    System Health Guardian.
.DESCRIPTION
    Automated tool to check and repair Windows image, system files, and disk integrity.
#>

$ErrorActionPreference = "Stop"

# 0. Admin Check
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Admin privileges required!" -ForegroundColor Red
    Pause ; exit
}

Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "                  SYSTEM HEALTH GUARDIAN                  " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Quick Health Check (DISM)
Write-Host "`n[1/3] Checking System Image Status..." -ForegroundColor Yellow
$check = dism /online /cleanup-image /checkhealth

if ($check -match "No component store corruption detected") {
    Write-Host "SUCCESS: No corruption found. System is healthy!" -ForegroundColor Green
    Write-Host ("-" * 58) -ForegroundColor Green
    Write-Host "Exiting process..." -ForegroundColor Gray
    Start-Sleep -Seconds 2
    exit
}

# 2. If corruption is found, proceed with Repair
Write-Host "Corruption detected! Starting repair process..." -ForegroundColor Magenta

Write-Host " -> Cleaning component store..." -ForegroundColor Gray
dism /online /cleanup-image /startcomponentcleanup

Write-Host " -> Restoring health..." -ForegroundColor Gray
dism /online /cleanup-image /restorehealth

# 3. SFC Phase
Write-Host "`n[2/3] Verifying System Files (SFC)..." -ForegroundColor Yellow
sfc /scannow

# 4. Chkdsk Phase
$SystemDrive = $env:SystemDrive
Write-Host "`n[3/3] Scheduling Disk Repair on $SystemDrive..." -ForegroundColor Yellow

try {
    $null = echo y | chkdsk $SystemDrive /f
    Write-Host "SUCCESS: Disk repair scheduled for the next reboot." -ForegroundColor Green
} catch {
    Write-Host "FAILURE: Could not schedule Chkdsk." -ForegroundColor Red
}

Write-Host ("-" * 58) -ForegroundColor Green
Write-Host "SYSTEM MAINTENANCE COMPLETED!" -ForegroundColor Green

$selection = Read-Host "`nWould you like to restart your computer now? (Y/N)"
if ($selection -match "Y|y") {
    Write-Host "Restarting in 5 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    Restart-Computer -Force
} else {
    Write-Host "Please reboot manually to finalize repairs." -ForegroundColor Cyan
}