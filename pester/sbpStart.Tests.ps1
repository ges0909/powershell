BeforeAll {

    # import but avoid script execution
    $Env:UNITTEST = $true

    # sourcing of powershell module to test
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')

    $script:LESS = 1
    $script:EQUAL = 0
    $script:GREATER = -1

    $script:TEMP_DIR = [System.IO.Path]::GetTempPath()
    $script:LAUNCHER_ROOT_DIR = $null

    function New-LauncherDir
    {
        [OutputType([System.IO.Path])]
        param (
            [Parameter(Mandatory = $true)][string]$Version
        )
        $tempFilePath = [System.IO.Path]::Combine($LAUNCHER_ROOT_DIR, $Version)
        return New-Item -Path $tempFilePath -ItemType Directory -Force -ErrorAction Ignore
    }
}

Describe "Ergebnis 'less', 'greater' und 'equal' der 'Compare'-Funktion als Grundlage für Sortierung" {

    Context 'Einstellige Versionsnummnern' {
        BeforeAll {
            $launcherDir = New-Guid
            $script:LAUNCHER_ROOT_DIR = [System.IO.Path]::Combine($TEMP_DIR, $launcherDir)
            $script:comparer = New-Object VersionComparer
            $script:a = New-LauncherDir -Version '23'
            $script:b = New-LauncherDir -Version '24'
        }

        It "23 < 24" {
            $comparer.Compare($a, $b) | Should -Be $LESS
        }

        It "24 > 23" {
            $comparer.Compare($b, $a) | Should -Be $GREATER
        }

        It "23 = 23" {
            $comparer.Compare($a, $a) | Should -Be $EQUAL
        }

        AfterAll {
            Remove-Item -Path $script:LAUNCHER_ROOT_DIR -Force -Recurse
        }
    }

    Context 'Zweistellige Versionsnummnern' {
        BeforeAll {
            $launcherDir = New-Guid
            $script:LAUNCHER_ROOT_DIR = [System.IO.Path]::Combine($TEMP_DIR, $launcherDir)
            $script:comparer = New-Object VersionComparer
            $script:a = New-LauncherDir -Version '24.0'
            $script:b = New-LauncherDir -Version '24.1'
        }

        It "24.0 < 24.1" {
            $comparer.Compare($a, $b) | Should -Be $LESS
        }

        It "24.1 > 24.0" {
            $comparer.Compare($b, $a) | Should -Be $GREATER
        }

        It "24.0 = 24.0" {
            $comparer.Compare($a, $a) | Should -Be $EQUAL
        }

        AfterAll {
            Remove-Item -Path $script:LAUNCHER_ROOT_DIR -Force -Recurse
        }
    }

    Context 'Dreistellige Versionsnummnern' {
        BeforeAll {
            $launcherDir = New-Guid
            $script:LAUNCHER_ROOT_DIR = [System.IO.Path]::Combine($TEMP_DIR, $launcherDir)
            $script:comparer = New-Object VersionComparer
            $script:a = New-LauncherDir -Version '24.1.1'
            $script:b = New-LauncherDir -Version '24.1.2'
        }

        It "24.1.1 < 24.1.2" {
            $comparer.Compare($a, $b) | Should -Be $LESS
        }
        It "24.1.2 > 24.1.1" {
            $comparer.Compare($b, $a) | Should -Be $GREATER
        }
        It "24.1.1 = 24.1.1" {
            $comparer.Compare($a, $a) | Should -Be $EQUAL
        }

        AfterAll {
            Remove-Item -Path $script:LAUNCHER_ROOT_DIR -Force -Recurse
        }
    }

    Context 'Vierstellige Versionsnummnern' {
        BeforeAll {
            $launcherDir = New-Guid
            $script:LAUNCHER_ROOT_DIR = [System.IO.Path]::Combine($TEMP_DIR, $launcherDir)
            $script:comparer = New-Object VersionComparer
            $script:a = New-LauncherDir -Version '24.1.3.0'
            $script:b = New-LauncherDir -Version '24.1.6.1'
        }

        It "24.1.3.0 < 24.1.6.1" {
            $comparer.Compare($a, $b) | Should -Be $LESS
        }

        It "24.1.6.1 > 24.1.3.0" {
            $comparer.Compare($b, $a) | Should -Be $GREATER
        }

        It "24.1.3.0 = 24.1.3.0" {
            $comparer.Compare($a, $a) | Should -Be $EQUAL
        }

        AfterAll {
            Remove-Item -Path $script:LAUNCHER_ROOT_DIR -Force -Recurse
        }
    }

    Context 'Verschieden lange Versionsnummnern' {
        BeforeAll {
            $launcherDir = New-Guid
            $script:LAUNCHER_ROOT_DIR = [System.IO.Path]::Combine($TEMP_DIR, $launcherDir)
            $script:comparer = New-Object VersionComparer
            $script:a = New-LauncherDir -Version '24.1.3.0'
            $script:b = New-LauncherDir -Version '24.1.6.1'
        }

        It "24.1.3 < 24.1.6.1" {
            $a = New-LauncherDir -Version '24.1.3'
            $b = New-LauncherDir -Version '24.1.6.1'
            $comparer = New-Object VersionComparer
            $comparer.Compare($a, $b) | Should -Be $LESS
        }
        It "24.1.6.1 > 24.1.3" {
            $a = New-LauncherDir -Version '24.1.6.1'
            $b = New-LauncherDir -Version '24.1.3'
            $comparer = New-Object VersionComparer
            $comparer.Compare($a, $b) | Should -Be $GREATER
        }
        It "24.1.6 = 24.1.6.0" {
            $a = New-LauncherDir -Version '24.1.6'
            $b = New-LauncherDir -Version '24.1.6.0'
            $comparer = New-Object VersionComparer
            $comparer.Compare($a, $b) | Should -Be $EQUAL
        }

        AfterAll {
            Remove-Item -Path $script:LAUNCHER_ROOT_DIR -Force -Recurse
        }
    }

    Context 'Spezialfälle' {
        BeforeAll {
            $launcherDir = New-Guid
            $script:LAUNCHER_ROOT_DIR = [System.IO.Path]::Combine($TEMP_DIR, $launcherDir)
            $script:comparer = New-Object VersionComparer
        }

        It "24.1.03 = 24.1.3" {
            $a = New-LauncherDir -Version '24.1.03'
            $b = New-LauncherDir -Version '24.1.3'
            $comparer = New-Object VersionComparer
            $comparer.Compare($a, $b) | Should -Be $EQUAL
        }
        It "024.1.3 = 24.1.3" {
            $a = New-LauncherDir -Version '024.1.3'
            $b = New-LauncherDir -Version '24.1.3'
            $comparer = New-Object VersionComparer
            $comparer.Compare($a, $b) | Should -Be $EQUAL
        }

        AfterAll {
            Remove-Item -Path $script:LAUNCHER_ROOT_DIR -Force -Recurse
        }
    }

    Describe 'Sortierung Launcher-Verzeichnisse: Höchste Version zuerst, niedrigste Version zuletzt' {
        Context 'Nur 3-stellige Launcherversionen' {
            BeforeAll {
                $launcherDir = New-Guid
                $script:LAUNCHER_ROOT_DIR = [System.IO.Path]::Combine($TEMP_DIR, $launcherDir)
                $script:comparer = New-Object VersionComparer
                $script:a = New-LauncherDir -Version '10.0.3'
                $script:b = New-LauncherDir -Version '10.0.1'
                $script:c = New-LauncherDir -Version '10.0.2'
            }

            It '[10.0.3, 10.0.1, 10.0.2] -> [10.0.3, 10.0.2, 10.0.1]' {
                $launcherVersions = Get-LauncherDirectories -Path $script:LAUNCHER_ROOT_DIR
                $launcherVersions.Count | Should -Be 3
                $sortedLauncherVersions = New-Object Collections.Generic.List[System.IO.DirectoryInfo]
                foreach ($item in $launcherVersions)
                {
                    $sortedLauncherVersions.Add($item)
                }
                $sortedLauncherVersions.Sort($comparer)
                $expected = @($a, $c, $b).foreach({ $_.ToString() })
                $sortedLauncherVersions | Should -Be $expected
            }

            AfterAll {
                Remove-Item -Path $script:LAUNCHER_ROOT_DIR -Force -Recurse
            }
        }

        Context 'Nur 4-stellige Launcherversionen' {
            BeforeAll {
                $launcherDir = New-Guid
                $script:LAUNCHER_ROOT_DIR = [System.IO.Path]::Combine($TEMP_DIR, $launcherDir)
                $script:comparer = New-Object VersionComparer
                $script:a = New-LauncherDir -Version '10.0.1.1'
                $script:b = New-LauncherDir -Version '10.0.2.1'
                $script:c = New-LauncherDir -Version '10.0.3.1'
            }

            It '[10.0.1.1, 10.0.2.1, 10.0.3.1] -> [10.0.3.1, 10.0.2.1, 10.0.1.1]' {
                $launcherVersions = Get-LauncherDirectories -Path $script:LAUNCHER_ROOT_DIR
                $launcherVersions.Count | Should -Be 3
                $sortedLauncherVersions = New-Object Collections.Generic.List[System.IO.DirectoryInfo]
                foreach ($item in $launcherVersions)
                {
                    $sortedLauncherVersions.Add($item)
                }
                $sortedLauncherVersions.Sort($comparer)
                $expected = @($c, $b, $a).foreach({ $_.ToString() })
                $sortedLauncherVersions | Should -Be $expected
            }

            AfterAll {
                Remove-Item -Path $script:LAUNCHER_ROOT_DIR -Force -Recurse
            }
        }

        Context '3- und 4-stellige Launcherversionen' {
            BeforeAll {
                $launcherDir = New-Guid
                $script:LAUNCHER_ROOT_DIR = [System.IO.Path]::Combine($TEMP_DIR, $launcherDir)
                $script:comparer = New-Object VersionComparer
                $script:a = New-LauncherDir -Version '0.0.1'
                $script:b = New-LauncherDir -Version '0.1.0.1'
                $script:c = New-LauncherDir -Version '0.1.0'
                $script:d = New-LauncherDir -Version '1.2.3.4'
            }

            It '[0.0.1, 0.1.0.1 10.1.0, 1.2.3.4] -> [1.2.3.4, 0.1.0.1, 0.1.0, 0.0.1]' {
                $launcherVersions = Get-LauncherDirectories -Path $script:LAUNCHER_ROOT_DIR
                $launcherVersions.Count | Should -Be 4
                $sortedLauncherVersions = New-Object Collections.Generic.List[System.IO.DirectoryInfo]
                foreach ($item in $launcherVersions)
                {
                    $sortedLauncherVersions.Add($item)
                }
                $sortedLauncherVersions.Sort($comparer)
                $expected = @($d, $b, $c, $a).foreach({ $_.ToString() })
                $sortedLauncherVersions | Should -Be $expected
            }

            AfterAll {
                Remove-Item -Path $script:LAUNCHER_ROOT_DIR -Force -Recurse
            }
        }
    }

    Describe "Match für jede Launcherversion, wenn leere Liste für Serverversionen" {
        It "3-stellige Launcherversion" {
            # Version 1.2.3 ist unterstützt, weil SupportedVersions leer ist
            Test-SupportedVersion -Version '1.2.3' -SupportedVersions @() | Should -Be $true
        }
        It "4-stellige Launcherversion" {
            # Version 1.2.3.4 ist unterstützt, weil SupportedVersions leer ist
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @() | Should -Be $true
        }
    }

    Describe "Match für Launcherversion, wenn passendes Client-Release vom Server" {
        It "KEIN Match: 3-stellige Launcherversion mit 4-stelliger Serverversion (Version ist spezifischer)" {
            # Die Version 1.2.3.4 ist spezifischer als 1.2.3
            Test-SupportedVersion -Version '1.2.3' -SupportedVersions @('1.2.3.4') | Should -Be $false
        }
        It "3-stellige Launcherversion mit 3-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3' -SupportedVersions @('1.2.3') | Should -Be $true
        }
        It "3-stellige Launcherversion mit 2-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3' -SupportedVersions @('1.2') | Should -Be $true
        }
        It "3-stellige Launcherversion mit 1-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3' -SupportedVersions @('1') | Should -Be $true
        }
        It "4-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('1.2.3.4') | Should -Be $true
        }
        It "4-stellige Launcherversion mit 3-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('1.2.3') | Should -Be $true
        }
        It "4-stellige Launcherversion mit 2-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('1.2') | Should -Be $true
        }
        It "4-stellige Launcherversion mit 1-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('1') | Should -Be $true
        }
    }

    Describe "KEIN Match für Launcherversion, wenn höheres Client-Release vom Server" {
        It "1-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '1' -SupportedVersions @('2.2.3.4') | Should -Be $false
        }
        It "1-stellige Launcherversion mit 3-stelliger Serverversion" {
            Test-SupportedVersion -Version '1' -SupportedVersions @('2.2.3') | Should -Be $false
        }
        It "1-stellige Launcherversion mit 2-stelliger Serverversion" {
            Test-SupportedVersion -Version '1' -SupportedVersions @('2.2') | Should -Be $false
        }
        It "1-stellige Launcherversion mit 1-stelliger Serverversion" {
            Test-SupportedVersion -Version '1' -SupportedVersions @('2') | Should -Be $false
        }
        It "1-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '1' -SupportedVersions @('1.2.3.4') | Should -Be $false
        }
        It "1-stellige Launcherversion mit 3-stelliger Serverversion" {
            Test-SupportedVersion -Version '1' -SupportedVersions @('1.2.3') | Should -Be $false
        }
        It "1-stellige Launcherversion mit 2-stelliger Serverversion" {
            Test-SupportedVersion -Version '1' -SupportedVersions @('1.2') | Should -Be $false
        }

        It "2-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2' -SupportedVersions @('2.2.3.4') | Should -Be $false
        }
        It "2-stellige Launcherversion mit 3-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2' -SupportedVersions @('2.2.3') | Should -Be $false
        }
        It "2-stellige Launcherversion mit 2-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2' -SupportedVersions @('2.2') | Should -Be $false
        }
        It "2-stellige Launcherversion mit 1-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2' -SupportedVersions @('2') | Should -Be $false
        }
        It "2-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2' -SupportedVersions @('1.2.3.4') | Should -Be $false
        }
        It "2-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2' -SupportedVersions @('1.2.3') | Should -Be $false
        }

        It "3-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3' -SupportedVersions @('2.2.3.4') | Should -Be $false
        }
        It "3-stellige Launcherversion mit 3-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3' -SupportedVersions @('2.2.3') | Should -Be $false
        }
        It "3-stellige Launcherversion mit 2-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3' -SupportedVersions @('2.2') | Should -Be $false
        }
        It "3-stellige Launcherversion mit 1-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3' -SupportedVersions @('2') | Should -Be $false
        }
        It "3-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3' -SupportedVersions @('1.2.3.4') | Should -Be $false
        }

        It "4-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('2.2.3.4') | Should -Be $false
        }
        It "4-stellige Launcherversion mit 3-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('2.2.3') | Should -Be $false
        }
        It "4-stellige Launcherversion mit 2-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('2.2') | Should -Be $false
        }
        It "4-stellige Launcherversion mit 1-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('2') | Should -Be $false
        }
        It "4-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('1.3.3.4') | Should -Be $false
        }
        It "4-stellige Launcherversion mit 3-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('1.3.3') | Should -Be $false
        }
        It "4-stellige Launcherversion mit 2-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('1.3') | Should -Be $false
        }
        It "4-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('1.2.4.4') | Should -Be $false
        }
        It "4-stellige Launcherversion mit 3-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('1.2.4') | Should -Be $false
        }
        It "4-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('1.2.3.5') | Should -Be $false
        }
    }

    Describe "KEIN Match für Launcherversion, wenn niedrigeres Client-Release vom Server" {
        It "1-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '2' -SupportedVersions @('1.2.3.4') | Should -Be $false
        }
        It "1-stellige Launcherversion mit 3-stelliger Serverversion" {
            Test-SupportedVersion -Version '2' -SupportedVersions @('1.2.3') | Should -Be $false
        }
        It "1-stellige Launcherversion mit 2-stelliger Serverversion" {
            Test-SupportedVersion -Version '2' -SupportedVersions @('1.2') | Should -Be $false
        }
        It "1-stellige Launcherversion mit 1-stelliger Serverversion" {
            Test-SupportedVersion -Version '2' -SupportedVersions @('1') | Should -Be $false
        }

        It "2-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '2.2' -SupportedVersions @('1.2.3.4') | Should -Be $false
        }
        It "2-stellige Launcherversion mit 3-stelliger Serverversion" {
            Test-SupportedVersion -Version '2.2' -SupportedVersions @('1.2.3') | Should -Be $false
        }
        It "2-stellige Launcherversion mit 2-stelliger Serverversion" {
            Test-SupportedVersion -Version '2.2' -SupportedVersions @('1.2') | Should -Be $false
        }
        It "2-stellige Launcherversion mit 1-stelliger Serverversion" {
            Test-SupportedVersion -Version '2.2' -SupportedVersions @('1') | Should -Be $false
        }

        It "3-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '2.2.3' -SupportedVersions @('1.2.3.4') | Should -Be $false
        }
        It "3-stellige Launcherversion mit 3-stelliger Serverversion" {
            Test-SupportedVersion -Version '2.2.3' -SupportedVersions @('1.2.3') | Should -Be $false
        }
        It "3-stellige Launcherversion mit 2-stelliger Serverversion" {
            Test-SupportedVersion -Version '2.2.3' -SupportedVersions @('1.2') | Should -Be $false
        }
        It "3-stellige Launcherversion mit 1-stelliger Serverversion" {
            Test-SupportedVersion -Version '2.2.3' -SupportedVersions @('1') | Should -Be $false
        }

        It "4-stellige Launcherversion mit 4-stelliger Serverversion" {
            Test-SupportedVersion -Version '2.2.3.4' -SupportedVersions @('1.2.3.4') | Should -Be $false
        }
        It "4-stellige Launcherversion mit 3-stelliger Serverversion" {
            Test-SupportedVersion -Version '2.2.3.4' -SupportedVersions @('1.2.3') | Should -Be $false
        }
        It "4-stellige Launcherversion mit 2-stelliger Serverversion" {
            Test-SupportedVersion -Version '2.2.3.4' -SupportedVersions @('1.2') | Should -Be $false
        }
        It "4-stellige Launcherversion mit 1-stelliger Serverversion" {
            Test-SupportedVersion -Version '2.2.3.4' -SupportedVersions @('1') | Should -Be $false
        }
    }

    Describe "Match für Launcherversion, wenn mehreren Client-Releases vom Server" {
        It "3-stellige Launcherversion mit 3- und 4-stelligen Serverversionen" {
            Test-SupportedVersion -Version '1.2.3' -SupportedVersions @('1.2.3', '1.2.3.0') | Should -Be $true
        }
        It "4-stellige Launcherversion mit 3- und 4-stelligen Serverversionen" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('1.2.3', '1.2.3.4') | Should -Be $true
        }
    }

    Describe "KEIN Match für Launcherversion, wenn mehreren Client-Releases vom Server" {
        It "3-stellige Launcherversion mit 3- und 4-stelligen Serverversionen" {
            Test-SupportedVersion -Version '1.2.3' -SupportedVersions @('3.2.1', '2.3.1.0') | Should -Be $false
        }
        It "4-stellige Launcherversion mit 3- und 4-stelligen Serverversionen" {
            Test-SupportedVersion -Version '1.2.3.4' -SupportedVersions @('3.2.1', '2.3.1.0') | Should -Be $false
        }
    }
}
