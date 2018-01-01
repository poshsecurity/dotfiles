#
# Global Configuration
#
$UserProfile = $env:USERPROFILE
$DocumentsPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::MyDocuments)
$AppDataRoaming = $env:APPDATA

#
# Install PowerShell Profile
#
'--------------------'
'PowerShell Profile'
'--------------------'
$PowerShellProfileSource = Join-Path -Path $PSScriptRoot -ChildPath 'PowerShell\Microsoft.PowerShell_profile.ps1'

$PowerShellProfiles = @(
    (Join-Path -Path $DocumentsPath -ChildPath 'WindowsPowerShell\Microsoft.PowerShell_profile.ps1') # PowerShell 5 and below
    (Join-Path -Path $DocumentsPath -ChildPath 'PowerShell\Microsoft.PowerShell_profile.ps1') # PowerShell 6
)

Foreach ($File in $PowerShellProfiles) {
    $ProfileDirectory = Split-Path -Path $File -Parent

    # Create the directory
    If (-not (Test-Path -Path $ProfileDirectory)) {
        'Creating directory {0}' -f $ProfileDirectory
        $null = New-Item -Path $ProfileDirectory -ItemType Directory
    }

    # Create the symbolic link
    If (-not (Test-Path -Path $File)) {
        'Creating symbolic link of {0} to {1}' -f $File, $PowerShellProfileSource
        $null = New-Item -Path $File -Value $PowerShellProfileSource -ItemType SymbolicLink
    }
}

#
# Install Dot Files
#
'--------------------'
'Dot Files'
'--------------------'
$DotFileSources = Get-ChildItem -Path $PSScriptRoot -Exclude @('README.md', 'install.ps1', 'LICENSE.md', '*PowerShell*') -Recurse | Where-Object {-not $_.PSIsContainer} |Select-Object -ExpandProperty FullName
Foreach ($DotFileSource in $DotFileSources) {
    
    $DestinationFile = $DotFileSource.Replace($PSScriptRoot, $UserProfile)
    $DestinationDirectory = Split-Path -Path $DestinationFile -Parent

    # Create the directory
    If (-not (Test-Path -Path $DestinationDirectory)) {
        'Creating directory {0}' -f $DestinationDirectory
        $null = New-Item -Path $DestinationDirectory -ItemType Directory
    }

    # Create the symbolic link
    If (-not (Test-Path -Path $DestinationFile)) {
        'Creating symbolic link of {0} to {1}' -f $DestinationFile, $DotFileSource
        $null = New-Item -Path $DestinationFile -Value $DotFileSource -ItemType SymbolicLink
    }

}
