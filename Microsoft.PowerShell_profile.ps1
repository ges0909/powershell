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

# find file
function find-file($name)
{
    Get-ChildItem -Recurse -Filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output "${_}"
    }
}

Set-Alias -Name ff -Value find-file

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
function set-location-project-dir
{
    Set-Location $HOME/Projekte
}

Set-Alias -Name p -Value set-location-project-dir

# Terminal Icons
# Install-Module -Name Terminal-Icons -Repository PSGallery
Import-Module -Name Terminal-Icons

# Oh My Posh
# oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config  "$HOME/oh-my-posh.json" | Invoke-Expression
