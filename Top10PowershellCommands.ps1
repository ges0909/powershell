<#
Top 10 PowerShell Commands for Beginners | Realistic Examples with Explanations!
#>

# 1. Get-Content

Get-Content hosts.txt

$hosts = Get-Content -Path ./hosts.txt

# 2. ForEach-Object

$hosts | ForEach-Object {
    # Write-Host Hostname: $_ -BackgroundColor White -ForegroundColor Black
    Write-Host "Hostname: $($_)" -BackgroundColor White -ForegroundColor Black
}

# 3. Out-File

"My name ist Gerrit" | Out-file "test.txt" -Append
"Your name ist Heike" | Out-file "test.txt" -Append

$hosts | ForEach-Object {
    # Write-Host Hostname: $_ -BackgroundColor White -ForegroundColor Black
    $_ | Out-File hostnames.txt -Append
}

# 4. Test-Connection

$hosts | ForEach-Object {
    $status = Test-Connection -ComputerName $_ -Count 1 | Select-Object Status
    Write-Host "$(Get-Date) Testing Host $($_): $($status.Status)"
}

# 5. ConvertTo-Json

$hosts | ConvertTo-Json

$hosts | ForEach-Object {
    Test-Connection -ComputerName $_ -Count 1
} | ConvertTo-Json  # -Depth 9

# 6. Get-Date

Get-Date

(Get-Date).Date

(Get-Date).DayOfWeek

# 7. Write-Host

Write-Host -BackgroundColor DarkGray -ForegroundColor Red "Write anything colorized!"

# 8. Get-Command

Get-Command *

Get-Command *write*

Get-Command *disk*

# 9. Get-Help

Get-Help Get-Process -Online
