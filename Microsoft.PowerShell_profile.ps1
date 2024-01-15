### PowerShell profile

# Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# ls -l
function ll
{
    Get-ChildItem -Path $pwd
}

function llr
{
    if ($args.Count -gt 0)
    {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    }
    else
    {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

# OneDrive
function od
{
    Set-Location $env:OneDrive
}

function odb
{
    Set-Location $env:OneDriveBusiness
}

function odc
{
    Set-Location $env:OneDriveConsumer
}

# find file
function Find-File($name)
{
    Get-ChildItem -Recurse -Filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output "${_}"
    }
}

# grep
function grep($regex, $dir)
{
    if ($dir)
    {
        Get-ChildItem $dir | Select-String $regex
        return
    }
    $input | Select-String $regex
}

# touch
function touch($file)
{
    "" | Out-File $file -Encoding ASCII
}

# set location to project dir
function Set-LocationProjectDir
{
    Set-Location $HOME/Projekte
}

# set location to QCAD config dir
function Set-LocationQcadConfigDir
{
    Set-Location $env:AppData/QCAD
}

function Set-LocalTestDatabase
{
    $ErrorActionPreference = "Stop"

    $cwd = Get-Location

    $ServerDir = "$HOME/Projekte/server"
    $TagesmappeDir = "$HOME/Projekte/tagesmappe"
    $ProtocolServerDir = "$HOME/Projekte/betriebliches-protokoll"
    $Projects = @($ServerDir, $TagesmappeDir, $ProtocolServerDir)

    Set-Location $ServerDir
    docker compose down
    $ImageId = docker images --quiet "gvenzl/oracle-xe"
    docker image rm $ImageId
    docker compose up oracle -d
    Start-Sleep -Seconds 10
    ./gradlew createSchema

    foreach ($project in $Projects)
    {
        $name = Split-Path "$project" -Leaf
        Write-Host ">> migrate $($name.ToUpper())"
        Set-Location $project
        ./gradlew flywayMigrate
    }

    Set-Location $cwd
}

# Aliases
Set-Alias -Name ff -Value Find-File
Set-Alias -Name p  -Value Set-LocationProjectDir
Set-Alias -Name q  -Value Set-LocationQcadConfigDir
Set-Alias -Name db -Value Set-LocalTestDatabase

# Terminal Icons
# Install-Module -Name Terminal-Icons -Repository PSGallery
Import-Module -Name Terminal-Icons

# Oh My Posh
# oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config  "$HOME/oh-my-posh.json" | Invoke-Expression
