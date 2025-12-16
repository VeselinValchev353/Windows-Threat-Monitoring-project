Write-Host "Checking for persistence via Run registry keys..." -ForegroundColor Cyan

# Registry paths to check
$runPaths = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
)

foreach ($path in $runPaths) {
    Write-Host "`nChecking: $path" -ForegroundColor Yellow

    try {
        $values = Get-ItemProperty -Path $path -ErrorAction Stop
        $props = $values.PSObject.Properties |
                 Where-Object { $_.Name -notmatch "PSPath|PSParentPath|PSChildName|PSDrive|PSProvider" }

        if ($props.Count -gt 0) {
            Write-Host "[ALERT] Persistence entries found!" -ForegroundColor Red
            foreach ($prop in $props) {
                Write-Host "Name : $($prop.Name)"
                Write-Host "Value: $($prop.Value)"
                Write-Host "-----------------------------------"
            }
        }
        else {
            Write-Host "No persistence entries found." -ForegroundColor Green
        }
    }
    catch {
        Write-Host "Cannot read $path (insufficient permissions or path missing)." -ForegroundColor DarkGray
    }
}
