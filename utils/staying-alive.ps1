<#
.SYNOPSIS
    Stayin' Alive Mode.
.DESCRIPTION
    Prevents the system from idling or locking by simulating a subtle keystroke.
.REPOSITORY
    vncsmntr/windows-ops
#>

$wsh = New-Object -ComObject WScript.Shell
Clear-Host

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "                STAYIN' ALIVE MODE ACTIVE                " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the rhythm (and allow sleep)." -ForegroundColor Gray
Write-Host ""

try {
    while($true) {
        # Simulates Scroll Lock key (invisible to most apps)
        $wsh.SendKeys('{SCROLLLOCK}')
        
        $timestamp = Get-Date -Format "HH:mm:ss"
        Write-Host "[$timestamp] ♫ Ah, ha, ha, ha, stayin' alive, stayin' alive... ♫" -ForegroundColor Magenta
        
        # Wait 60 seconds (more efficient than 30s)
        Start-Sleep -Seconds 60
    }
}
catch {
    Write-Host "`nScript stopped. The PC can now rest in peace." -ForegroundColor Cyan
}