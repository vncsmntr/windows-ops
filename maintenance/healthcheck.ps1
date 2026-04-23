<#
.SYNOPSIS
    Advanced System Health Guardian.
.DESCRIPTION
    Aggressive repair for persistent corruption. Fixes the "Corruption Loop" and visual bugs.
#>

$ErrorActionPreference = "Stop"

# 0. Admin Check
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Admin privileges required!" -ForegroundColor Red
    Pause ; exit
}

Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "         SYSTEM HEALTH GUARDIAN - ADVANCED REPAIR         " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Reset DISM Logs
if (Test-Path "C:\Windows\Logs\DISM\dism.log") {
    Remove-Item "C:\Windows\Logs\DISM\dism.log" -ErrorAction SilentlyContinue
}

# 2. DISM Phase (The loop breaker)
Write-Host "`n[1/3] Analyzing & Repairing System Image (DISM)..." -ForegroundColor Yellow

# Step A: Component Store Cleanup
Write-Host " -> Cleaning up component store (WinSxS)..." -ForegroundColor Gray
dism /online /cleanup-image /startcomponentcleanup

# Step B: Deep Scan and Repair
Write-Host " -> Performing deep scan..." -ForegroundColor Gray
$repair = dism /online /cleanup-image /restorehealth

if ($repair -match "successfully") {
    Write-Host "SUCCESS: Image repaired and component store cleaned." -ForegroundColor Green
}

# 3. SFC Phase
Write-Host "`n[2/3] Verifying System Files (SFC)..." -ForegroundColor Yellow
sfc /scannow

# 4. Chkdsk Phase
$SystemDrive = $env:SystemDrive
Write-Host "`n[3/3] Scheduling Disk Repair on $SystemDrive..." -ForegroundColor Yellow

# The most reliable way to schedule Chkdsk for next boot:
try {
    # Schedules a full chkdsk on next reboot
    $null = echo y | chkdsk $SystemDrive /f
    Write-Host "SUCCESS: Disk repair scheduled for the next reboot." -ForegroundColor Green
} catch {
    Write-Host "FAILURE: Could not schedule Chkdsk automatically." -ForegroundColor Red
}

# Corrected visual line syntax
Write-Host ("-" * 58) -ForegroundColor Green
Write-Host "SYSTEM MAINTENANCE COMPLETED!" -ForegroundColor Green
Write-Host "Windows will verify your drive during the next boot sequence." -ForegroundColor White

$selection = Read-Host "`nWould you like to restart your computer now? (Y/N)"
if ($selection -match "Y|y") {
    Write-Host "Restarting in 5 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    Restart-Computer -Force
} else {
    Write-Host "Please reboot manually to finalize disk repairs." -ForegroundColor Cyan
}