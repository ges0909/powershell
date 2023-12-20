# Powershell

- [PowerShell Kurs](https://yewtu.be/playlist?list=PL4psuuBzr38450N4fTXNzM9sNZdhBs4sN)

## [Profile](https://yewtu.be/latest_version?id=LuAipOW8BNQ&itag=22&hmac_key=51258bc4616982d072fa8c17092ccaf2948aca8d)

Variable `$PROFILE` enthält Dateipfad zur Profile-Datei.

```ps
$PROFILE
C:\Users\gerri\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

[Oh My Posh](https://ohmyposh.dev/docs/migrating)

```ps
winget install JanDeDobbeleer.OhMyPosh -s winget   # install
```

Profile-Datei:

```ps
oh-my-posh init pwsh --config  "$HOME/.oh-my-posh.json" | Invoke-Expression
```

## [Cmdlets verwenden](https://yewtu.be/watch?v=Xa-xIhZ0bFQ&list=PL4psuuBzr38450N4fTXNzM9sNZdhBs4sN&index=2)

- basieren auf `.NET`-Klassen
- Ein-/Ausgabe besteht aus Objekten, kein Text
- folgen dem Schema \<Verb\>-\<Noun\>
- Groß-/Kleinschreibung ohne Bedeutung
- Parametertypen
    - Name + Wert
    - positionsorientiert
    - Schalter

```ps
Get-Process
Get-Process -Name msedge
Get-Process -Name ms*
Get-Process -Name *s*
Get-Process -Name msedge -FileVersionInfo
```

## [Die PowerShell Hilfe](https://yewtu.be/watch?v=nls1STymEYo&list=PL4psuuBzr38450N4fTXNzM9sNZdhBs4sN&index=3)

```ps
Get-Help
Get-Help Get-Process
Get-Help Get-Process -Full
Get-Help Get-Process -Online # Online-Hilfe im Browser
```

```ps
Get-Help New-ScriptFileInfo
Get-Help New-ScriptFileInfo -Full
Get-Help New-ScriptFileInfo -Online
```

Hilfe aktualisieren (als Admin)

```ps
Update-Help
```

## [PowerShell PIPE](https://yewtu.be/watch?v=3NQoZKq3_yI&list=PL4psuuBzr38450N4fTXNzM9sNZdhBs4sN&index=4)

Übergabe von Objekten zwischen Cmdlets

```ps
Get-Process | Where-Object -Property mainWindowTitle
Get-Process | Where-Object -Property mainWindowTitle | Format-Table -Property name,main # Ergebnis ist kein Objekt mehr
Get-Process | Where-Object -Property Name -EQ -Value msegde
```

Performance

```ps
Get-Process -name msedge # schneller
Get-Process | Where-Object -Property Name -EQ -Value msegde # langsamer
```

## [Objekte in PowerShell](https://yewtu.be/watch?v=e5NrsnHC2W0&list=PL4psuuBzr38450N4fTXNzM9sNZdhBs4sN&index=5)

```ps
Get-Service | Get-Member
Get-Service wuauserv | Select-Object -Property *
```

| MemberType    |                  |
|---------------|------------------|
| Property      | get,set          |
| AliasProperty | Name=ServiceName |
| Method        | void Start()     |
| ScriptMethod  |                  |
| Event         |                  |

Propertywerte abfragen

```ps
Get-Service wuauserv | Select-Object -Property *
(Get-Service wuauserv).DisplayName # Window's Update Service
```

Methoden aufrufen

```ps
(Get-Service wuauserv).Stop()
(Get-Service wuauserv).Start()
# Alternativen
Start-Service wuauserv
Stop-Service wuauserv
Restart-Service wuauserv
```

## [Mit der PowerShell navigieren](https://yewtu.be/watch?v=rQ-R2UAN-r4&list=PL4psuuBzr38450N4fTXNzM9sNZdhBs4sN&index=6)

Dateisystem

```ps
dir
cd
Move Datei1.txt test  # Umbenennen auf `test`
Move Datei1.txt test\ # Verschieben in Ordner `test`; Backslash ist wichtig
```

Registry

```ps
cd HKCU:\
dir
```

## [Variablen in PowerShell verwenden](https://yewtu.be/watch?v=I8phsCSui6Y&list=PL4psuuBzr38450N4fTXNzM9sNZdhBs4sN&index=7)

Variables are represented by text strings that begin with a `$`, such as  `$my_var`.

Variable names **aren't** case-sensitive, and can include spaces and special chars.

The default value of all variables is `$null`.

To get a list of all the variables in your PowerShell session, type `Get-Variable`.

You can store any type of object in a variable, including integers, strings, arrays, and hash tables.

```ps
$var = "Hallo Welt"
$var
Hallo Welt
Write-Host "Der Wert lautet: $var"
Der Wert lautet: Hallo Welt
```

```ps
$name = Read-Host "Wie lautet dein Name?"
Wie lautet dein Name?: Gerrit
$name
Gerrit
```

Variable haben Typen. Automatische implizite Typ-Deklaration:

```ps
$test = "Hallo"
$test | Get-Member

   TypeName: System.String

$test = 1234
$test | Get-Member

   TypeName: System.Int32

$test = 1234.56
$test | Get-Member

   TypeName: System.Double

$test = $false
$test | Get-Member

   TypeName: System.Boolean
```

Explizite Typ-Deklaration:

```ps
[int]$test = 1234
$test | Get-Member

   TypeName: System.Int32

[int]$test = "1234" # automatische Konvertierung zu Integer
$test | Get-Member

   TypeName: System.Int32

[int]$test = Read-Host "Bitte gib eine Zahl ein" # erzwinge Eingabe von Integer
Bitte gib eine Zahl ein: 123
```
### Arrays

```pwsh
$a = @()
$a = @("1", "2", "3")
$a += "4"
$a.Add('5')
#
$a[0]           # "1" 
$a[0,2]         # "1", "3"
$a[1..2]        # "2", "3"
$a[-1]          # "3"
#
$a[2] = '9'
$a | ForEach-Object { "Item: [$_]" }
foreach ($e in $a) { Write-Host $e }
```

### Hash tables

```pwsh
$h = @{}
$h = @{"Key1" = "1"; "Key2" = "2"; "Key3" = "3"}
$h.Key3 = "9"
$h.Remove("Key3")
```

## New-ScriptFileInfo

```ps
New-ScriptFileInfo -Version 1.0 -Author 'Sebastian.Hartte@deutschebahn.com (Gerrit.Schrader@deutschebahn.com)' -CompanyName 'DB Netz AG' -Description 'Skript zum Starten des iSBPN-Launchers' startup.ps1
```

## Execution Policy

```pwsh
Get-ExecutionPolicy
Get-ExecutionPolicy -List
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass # set
Set-ExecutionPolicy -Scope CurrentUser Unrestricted
```

## ErrorAction in PowerShell

> Error behavior can also be set per command using the `-ErrorAction`
> common parameter, which is available to **every** PowerShell command.

see: [Error handling with PowerShell](https://www.pdq.com/blog/error-handling-with-powershell/)

The error action `Stop` displays the error and stops executing the command.
This option also generates an `ActionPreferenceStopException` object to the error stream.

## Using Statement

> You can ... load assemblies with the using statement. This loads the assemblies at
> parse time rather than execution time and is used when defining PowerShell classes.

see: [Loading .NET Assemblies in PowerShell](https://blog.ironmansoftware.com/daily-powershell-2/)

## Script Block

## Install/Uninstall modules

```pwsh
Install-Module -Name ActiveDirectoryTools
Uninstall-Module -Name ActiveDirectoryTools
```

## Add .NET class to a PowerShell session

```pwsh
Add-Type -AssemblyName System.Windows.Forms
```

## Logging

Install `PSFramework`:

```pwsh
Install-Module PSFramework
```

Configure log file:

```pwsh
$logFile = Join-Path -path "$env:USERPROFILE\Desktop" -ChildPath "log-$(Get-date -f 'yyyyMMddHHmmss').txt";
Set-PSFLoggingProvider -Name logfile -FilePath $logFile -Enabled $true;
```

Use logging:

```pwsh
$sum = 9
Write-PSFMessage -Level Verbose -Message "Intermediate result: $($sum)" -Debug
Write-PSFMessage -Level Host -Message "Intermediate result: $($sum)"
Write-PSFMessage -Level Warning -Message "Intermediate result: $($sum)"
Write-PSFMessage -Level Error -Message "Intermediate result: $($sum)"
```

see: [Installing PSFramework](https://www.dataset.com/blog/getting-started-quickly-powershell-logging/)

## Cmdlets

| Cmdlet / Function      | Description                                                                       |
|------------------------|-----------------------------------------------------------------------------------|
| Add-Type               |                                                                                   |
| ConvertFrom-Json       |                                                                                   |
| ConvertFrom-StringData | converts a string that contains one or more key and value pairs into a hash table |
| ForEach-Object         | (see `Where-Object`)                                                              |
| Get-ChildItem          |                                                                                   |
| Get-Content            |                                                                                   |
| Invoke-WebRequest      |                                                                                   |
| Join-Path              | path concatenation                                                                |
| Receive-Job            |                                                                                   |
| Start-Job              | run script block in background (see `Wait-Job`)                                   |
| Test-Path              |                                                                                   |
| Remove-Variable        |                                                                                   |
| Start-Process          |                                                                                   |
| Wait-Job               | will cause the script to wait until the task is completed (see `Start-Job`)       |
| WaitForExit            | makes current thread wait until the associated process terminates                 |
| Where-Object           | selects objects from a collection based on their property values                  |
