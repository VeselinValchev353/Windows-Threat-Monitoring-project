 Write-Host "Checking for suspicious network connections (Sysmon Event ID 3)..." -ForegroundColor Cyan

# Define "suspicious" IPs and ports (simulated threat intel)
$suspiciousIPs   = @("1.1.1.1", "8.8.8.8")      # example external IPs
$suspiciousPorts = @(4444, 1337, 5555, 6666)    # common C2-style ports

# Get recent Sysmon network events (Event ID 3)
$events = Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" |
          Where-Object { $_.Id -eq 3 } |
          Select-Object -First 100  # limit for readability

if (-not $events) {
    Write-Host "No Sysmon network events found." -ForegroundColor Yellow
    exit
}

$suspiciousFound = @()

foreach ($event in $events) {
    # Parse XML to get structured fields
    $xml  = [xml]$event.ToXml()
    $data = @{}
    foreach ($d in $xml.Event.EventData.Data) {
        $data[$d.Name] = $d.'#text'
    }

    $destIp   = $data["DestinationIp"]
    $destPort = [int]$data["DestinationPort"]
    $image    = $data["Image"]

    if ($suspiciousIPs -contains $destIp -or $suspiciousPorts -contains $destPort) {
        $suspiciousFound += [PSCustomObject]@{
            Time       = $event.TimeCreated
            Image      = $image
            DestIP     = $destIp
            DestPort   = $destPort
            Protocol   = $data["Protocol"]
        }
    }
}

if ($suspiciousFound.Count -gt 0) {
    Write-Host "`n[ALERT] Suspicious network connections detected!" -ForegroundColor Red
    foreach ($conn in $suspiciousFound) {
        Write-Host "Time:      $($conn.Time)"
        Write-Host "Process:   $($conn.Image)"
        Write-Host "Dest IP:   $($conn.DestIP)"
        Write-Host "Dest Port: $($conn.DestPort)"
        Write-Host "Protocol:  $($conn.Protocol)"
        Write-Host "-----------------------------------"
    }
} else {
    Write-Host "No suspicious connections to configured IPs/ports found." -ForegroundColor Green
}
