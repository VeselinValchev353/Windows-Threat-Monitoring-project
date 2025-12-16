Write-Host "Checking for encoded PowerShell commands..." -ForegroundColor Cyan

# Get PowerShell Script Block logs (Event ID 4104)
$events = Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" `
    | Where-Object { $_.Id -eq 4104 -and $_.Message -match "-enc" }

if ($events.Count -gt 0) {
    Write-Host "`n[ALERT] Encoded PowerShell activity detected!" -ForegroundColor Red
    foreach ($event in $events) {
        Write-Host "Time: $($event.TimeCreated)"
        Write-Host "Command (truncated):"
        $event.Message.Substring(0, [Math]::Min(200, $event.Message.Length))
        Write-Host "`n-----------------------------------`n"
    }
} else {
    Write-Host "No encoded PowerShell commands found." -ForegroundColor Green
}
