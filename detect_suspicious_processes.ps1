Write-Host "Checking for suspicious process creation (Sysmon Event ID 1)..." -ForegroundColor Cyan

# List of suspicious processes often used by attackers
$suspicious = @(
    "powershell.exe",
    "pwsh.exe",
    "cmd.exe",
    "mshta.exe",
    "wscript.exe",
    "cscript.exe",
    "rundll32.exe",
    "regsvr32.exe",
    "wmic.exe",
    "psexec.exe"
)

# Query Sysmon ProcessCreate events (Event ID 1)
$events = Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" `
    | Where-Object { $_.Id -eq 1 }

if (!$events) {
    Write-Host "No Sysmon process creation events found." -ForegroundColor Yellow
    exit
}

$found = $false

foreach ($event in $events) {
    $msg = $event.Message.ToLower()

    foreach ($proc in $suspicious) {
        if ($msg -match $proc.ToLower()) {
            if (!$found) {
                Write-Host "`n[ALERT] Suspicious process activity detected!" -ForegroundColor Red
                $found = $true
            }

            Write-Host "`n---- Suspicious Process ----"
            Write-Host "Time: $($event.TimeCreated)"
            Write-Host "Process: $proc"
            Write-Host "Event Data (truncated):"
            Write-Host $msg.Substring(0, [Math]::Min(250, $msg.Length))
            Write-Host "------------------------------------"
        }
    }
}

if (!$found) {
    Write-Host "`nNo suspicious process launches found." -ForegroundColor Green
}
