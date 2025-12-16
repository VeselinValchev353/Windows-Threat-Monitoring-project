Write-Host "Checking for suspicious failed logons..." -ForegroundColor Cyan

# Event ID 4625 = Failed logon attempt
$events = Get-WinEvent -LogName "Security" | Where-Object { $_.Id -eq 4625 }

if ($events.Count -eq 0) {
    Write-Host "No failed logons found." -ForegroundColor Green
    exit
}

Write-Host "`nFound $($events.Count) failed logon attempts:" -ForegroundColor Yellow

foreach ($ev in $events) {

    $message = $ev.Message

    # Extract important fields (best effort parsing)
    $account = ($message -split "Account Name:")[1].Split()[0]
    $source  = ($message -split "Source Network Address:")[1].Split()[0]
    $logonType = ($message -split "Logon Type:")[1].Split()[0]

    Write-Host "`n---- FAILED LOGON ----" -ForegroundColor Red
    Write-Host "Time: $($ev.TimeCreated)"
    Write-Host "Account: $account"
    Write-Host "Source IP: $source"
    Write-Host "Logon Type: $logonType"

    # Highlight RDP brute-force attempts
    if ($logonType -eq "10") {
        Write-Host "⚠ RDP-related failed logon (Type 10)!" -ForegroundColor Magenta
    }

    # Highlight possible brute-force
    if ($events.Count -gt 10) {
        Write-Host "⚠ Possible brute-force attempt (more than 10 failures)!" -ForegroundColor DarkYellow
    }

    Write-Host "-----------------------"
}
