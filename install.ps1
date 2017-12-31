
#
# Global Configuration
#

#
# Install Dot Files
#
$UserProfile = $env:USERPROFILE
$DocumentsPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::MyDocuments)

$PowerShellProfiles = @(
    @{
        ProfileDirectory = Join-Path -Path $DocumentsPath -ChildPath 'WindowsPowerShell'
        ProfilePath      = Join-Path -Path $DocumentsPath -ChildPath 'WindowsPowerShell\Microsoft.PowerShell_profile.ps1'
    },
    @{
        ProfileDirectory = Join-Path -Path $DocumentsPath -ChildPath 'PowerShell'
        ProfilePath      = Join-Path -Path $DocumentsPath -ChildPath 'PowerShell\Microsoft.PowerShell_profile.ps1'
    }
)

$PowerShellProfileSourcePath = Join-Path -Path $PSScriptRoot -ChildPath 'PowerShell\Microsoft.PowerShell_profile.ps1'

Foreach ($PowerShellProfile in $PowerShellProfiles) {
    if (-not (Test-Path -Path $PowerShellProfile.ProfileDirectory)) {
        $null = New-Item -Path $PowerShellProfile.ProfileDirectory -ItemType Directory
    }

    if (-not (Test-Path -Path $PowerShellProfile.ProfilePath)) {
        $null = New-Item -Path $PowerShellProfile.ProfilePath -Value $PowerShellProfileSourcePath -ItemType SymbolicLink
    }
}

$GitConfigPath       = Join-Path -Path $UserProfile -ChildPath '.gitconfig'
$GitConfigSourcePath = Join-Path -Path $PSScriptRoot -ChildPath '.gitconfig'
if (-not (Test-Path -Path $GitConfigPath)) {
    $null = New-Item -Path $GitConfigPath -Value $GitConfigSourcePath -ItemType SymbolicLink
}

