#Requires -Modules PSFramework

# if (-not (Get-Module PSFramework -ListAvailable)){
#    Install-Module PSFramework -Scope CurrentUser -Force
# }

Remove-Variable log*

# Setting up logging
$script:logRoot = "$env:USERPROFILE\Desktop"
$script:logFile = Join-Path -path $logRoot -ChildPath "startup-$(Get-Date -f 'yyyy-MM-dd-HH-mm-ss').log"
$script:logFileTranscript = Join-Path -path $logRoot -ChildPath "startup-transcript-$(Get-Date -f 'yyyy-MM-dd-HH-mm-ss').log"
$script:logFileRotate = Join-Path -path $logRoot -ChildPath "startup-*.log"

$script:logPSFrameworkLoggingProvider = @{
    Name          = 'logfile'
    InstanceName  = '<taskname>'
    FilePath      = $logFile
    # FileType      = 'CMTrace'
    Enabled       = $true
    Wait          = $true
    LogRotatePath = $logFileRotate
}
Set-PSFLoggingProvider @logPSFrameworkLoggingProvider

Start-Transcript -Path $logFileTranscript

# Start logging
Write-PSFMessage "Starting Script"

# Add script code here, using Write-PSFMessage wherever you want to log
# ...

Write-PSFMessage "Script Completed"

# Wait for logging to complete
Wait-PSFMessage

Stop-Transcript

# see: https://psframework.org/documentation/documents/psframework/logging/loggingto/logfile.html
