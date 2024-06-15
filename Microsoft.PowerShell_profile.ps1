### PowerShell profile

# Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

#
# ls -l
#
function ll {
    Get-ChildItem -Path $pwd
}

function llr {
    if ($args.Count -gt 0) {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    }
    else {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

#
# OneDrive
#
function od {
    Set-Location $env:OneDrive
}

function odb {
    Set-Location $env:OneDriveBusiness
}

function odc {
    Set-Location $env:OneDriveConsumer
}

#
# find file
#
function Find-File($name) {
    Get-ChildItem -Recurse -Filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output "${_}"
    }
}

#
# grep
#
function grep($regex, $dir) {
    if ($dir) {
        Get-ChildItem $dir | Select-String $regex
        return
    }
    $input | Select-String $regex
}

#
# touch
#
function touch($file) {
    "" | Out-File $file -Encoding ASCII
}

#
# set location to project dir
#
function Set-LocationProjectDir {
    Set-Location $HOME/Projekte
}

#
# set location to QCAD config dir
#
function Set-LocationQcadConfigDir {
    Set-Location $env:AppData/QCAD
}

#
# local database setup
#
function Set-LocalTestDatabase {
    $ErrorActionPreference = "Stop"

    $cwd = Get-Location

    $Dir = "$HOME/Projekte/server"
    Set-Location $Dir
    ./gradlew createSchema
    ./gradlew flywayMigrate

    $Dir = "$HOME/Projekte/tagesmappe"
    Set-Location $Dir
    ./gradlew createSchema
    ./gradlew flywayMigrate

    $Dir = "$HOME/Projekte/betriebliches-protokoll"
    Set-Location $Dir
    ./gradlew flywayMigrate

    $Dir = "$HOME/Projekte/server"
    Set-Location $Dir
    ./gradlew bereichsimport:bootRun --args='bereichsimport --spring.profiles.active=import'
    ./gradlew isbpnserver:importStammdaten

    Set-Location $cwd
}

#
# Generate a Global Unique Identifier
#
function Get-GUID {
    [guid]::NewGuid()
}

#
# Aliases
#
Set-Alias -Name ff  -Value Find-File
Set-Alias -Name p   -Value Set-LocationProjectDir
Set-Alias -Name q   -Value Set-LocationQcadConfigDir
Set-Alias -Name db  -Value Set-LocalTestDatabase
Set-Alias -Name uid -Value Get-GUID

#
# Terminal Icons
#
# Install-Module -Name Terminal-Icons -Repository PSGallery
Import-Module -Name Terminal-Icons

#
# Oh My Posh
#
# oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config  "$HOME/.oh-my-posh.json" | Invoke-Expression

#
# Winfetch
#
# Install-Script -Name pwshfetch-test-1
Set-Alias winfetch pwshfetch-test-1
