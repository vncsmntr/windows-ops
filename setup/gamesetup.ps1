<#
.SYNOPSIS
    Game Library Setup Tool.
.DESCRIPTION
    Dynamically creates game library folders based on user input and selection.
#>

$ErrorActionPreference = "Stop"

# 1. Store Definitions
$CommonStores = @("Steam", "Epic", "GOG", "EA", "Ubisoft")
$ExtraStores  = @("Battlenet", "Microsoft", "Amazon", "Rockstar")
$AllStores    = $CommonStores + $ExtraStores

Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "             GAME LIBRARY SETUP AUTOMATION               " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 2. Get Target Path
Write-Host "`n[1/2] TARGET LOCATION" -ForegroundColor Yellow
Write-Host "Example: D:\Games or E:\Libraries"
$InputPath = Read-Host "Enter the path where folders should be created"

if ([string]::IsNullOrWhiteSpace($InputPath)) { 
    $InputPath = "D:\Games" 
    Write-Host "No path entered. Using default: $InputPath" -ForegroundColor Gray
}

# 3. Selection Mode
Write-Host "`n[2/2] STORE SELECTION" -ForegroundColor Yellow
Write-Host "1. Common Stores Only (Steam, Epic, GOG, EA, Ubisoft)"
Write-Host "2. All Stores (Adds Battlenet, Microsoft, Amazon, Rockstar)"
$Choice = Read-Host "Select an option (1 or 2)"

$SelectedStores = if ($Choice -eq "1") { $CommonStores } else { $AllStores }

# 4. Execution
Write-Host "`n--- Running Setup ---" -ForegroundColor White

# Ensure the base directory exists
if (-not (Test-Path $InputPath)) {
    try {
        New-Item -Path $InputPath -ItemType Directory -Force | Out-Null
        Write-Host "Created base directory: $InputPath" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Could not create or access $InputPath. Check drive permissions." -ForegroundColor Red
        Pause ; exit
    }
}

foreach ($Store in $SelectedStores) {
    $TargetFolder = Join-Path -Path $InputPath -ChildPath $Store
    
    if (-not (Test-Path $TargetFolder)) {
        New-Item -Path $TargetFolder -ItemType Directory -Force | Out-Null
        Write-Host " [+] Created: $Store" -ForegroundColor Green
    } else {
        Write-Host " [-] Already exists: $Store" -ForegroundColor Yellow
    }
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "   DONE! Game libraries are ready at $InputPath" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

Pause