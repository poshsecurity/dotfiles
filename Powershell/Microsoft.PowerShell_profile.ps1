#
# Global Variables
#
$GITHOME   = Join-Path -Path $HOME -ChildPath 'GIT'
$DESKTOP   = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
$DOCUMENTS = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::MyDocuments)

#
# PS Module Path Updates
#
# I store all of my projects under d:\Git\<Organisation-Provider>\MyPowerShellModule. For Instance D:\Git\PoshSecurity-GitHub\Posh-Syslog.
# I want to be able to lazy load all of these modules, so I want to add them to the $ENV:PSModulePath
$GitLocations = Resolve-Path -Path $GITHOME
$Env:PSModulePath += ($GitLocations -join ';')

# If we are running 6, include the built in modules (note some might not work correctly)
if ($PSVersionTable.PSVersion.Major -ge 6) {
    $BuiltInPowerShell5Module = Join-Path $env:ProgramFiles '\WindowsPowerShell\Modules\'
    $Env:PSModulePath += (';{0}' -f $BuiltInPowerShell5Module)
}

#
# Posh-GIT
#
# Import the Posh-Git module
Import-Module -Name Posh-Git

# Start Pageant (SSH Agent) if it isn't already started.
if ($null -eq (Get-Process pageant -ErrorAction SilentlyContinue))
{
    Start-SshAgent -Quiet
}

#
# Quick functions to save time
#
# From: https://github.com/scottmuc/poshfiles/blob/master/Microsoft.PowerShell_profile.ps1
Function Touch {
    Param (
        # Path to file to touch
        [Parameter(mandatory=$true)]
        [String]
        $Path,

        # Date to set as touch
        [Parameter(mandatory=$false)]
        [datetime]
        $Date = (Get-Date)
    )

    if (-not (Test-Path -Path $Path)) {
        Set-Content -Path $Path -Value ($null)
    }

    Get-ChildItem -Path $path | ForEach-Object {
            $_.CreationTime = $date
            $_.LastAccessTime = $date
            $_.LastWriteTime = $date 
    }
}

Function which {
    Param (
        # Command Name
        [Parameter(mandatory=$true)]
        [String]
        $Name
    )

    $Command = Get-Command $name

    switch ($Command.CommandType) {
        'Cmdlet' {
            @{
                Source  = $Command.Source
                Version = $Command.Version
            }
        }
        
        'Application' {
            $Command.Definition
        }
        
        Default {
            $Command
        }
    }
}

Function Set-GitIdentity {
    Param (
        # Your Name
        [Parameter(mandatory=$true)]
        [String]
        $Name,

        # Your Email
        [Parameter(mandatory=$true)]
        [String]
        $Email
    )
    git config user.name $Name
    git config user.email $Email
}

Function Set-GitSigning {
    Param (
        # Your Name
        [Parameter(mandatory=$true)]
        [String]
        $KeyID
    )
    user.signingkey $KeyID
    commit.gpgsign true
}

#
# Aliases
#
Set-Alias -Name g -Value git

#
# PowerShell Default Parameter Values
#
$PSDefaultParameterValues = @{
    'Export-Csv:NoTypeInformation' = $true
}
