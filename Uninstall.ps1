. (Join-Path $PSScriptRoot "Resources\Messages.ps1")

$Options = @(
    @{ ID = 1; Key = "UnOpt1"; Action = { 
            if (Get-Command podman -ErrorAction SilentlyContinue) {
                podman machine stop 2>$null
                podman machine rm -f 2>$null
            }
        }
    },
    @{ ID = 2; Key = "UnOpt2"; Action = {
            if (Get-Command scoop -ErrorAction SilentlyContinue) { 
                scoop uninstall vscode
            }
        }
    },
    @{ ID = 3; Key = "UnOpt3"; Action = {
            # Try the official uninstallation method
            if (Get-Command scoop -ErrorAction SilentlyContinue) {
                scoop uninstall scoop -f 2>$null
            }

            # Cleanup corresponding environment variables (User & Machine)
            [Environment]::SetEnvironmentVariable('SCOOP', $null, 'User')
            [Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $null, 'Machine')
        
            # Delete related files physically (e.g. D:\Scoop), if possible
            $StateFile = Join-Path $PSScriptRoot ".setup_state.json"
            if (Test-Path $StateFile) {
                $State = Get-Content $StateFile | ConvertFrom-Json
                $ScoopPaths = @($State.ScoopPath, $State.GlobalPath, "$env:USERPROFILE\.scoop")
                foreach ($P in $ScoopPaths) {
                    if ($P -and (Test-Path $P)) {
                        Remove-Item $P -Recurse -Force -ErrorAction SilentlyContinue
                    }
                }
            }
        }
    },
    @{ ID = 4; Key = "UnOpt4"; Action = {
            Remove-Item "D:\WSL" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item "D:\Scoop" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item (Join-Path $PSScriptRoot ".setup_state.json") -Force -ErrorAction SilentlyContinue
        }
    }
)

Clear-Host
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  $(T 'UnTitle')" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

foreach ($Opt in $Options) {
    Write-Host " [$($Opt.ID)] $(T $Opt.Key)" 
}
Write-Host " [A] $(T 'UnAll')" -ForegroundColor Red
Write-Host " [Q] $(T 'UnQuit')"
Write-Host "------------------------------------------"

$Input = Read-Host (T "UnSelect")

if ([string]::IsNullOrWhiteSpace($Input) -or $Input.ToLower() -eq "q") {
    Write-Host (T "UnCancel"); exit
}

# Stop related processes before looping actions.
Stop-Process -Name "Code", "podman*", "git*" -ErrorAction SilentlyContinue

$Selection = if ($Input.ToLower() -eq "a") { $Options } else {
    $Ids = $Input -split ','; $Ids | ForEach-Object { $id = $_.Trim(); $Options | Where-Object { $_.ID -eq $id } }
}

if ($Selection) {
    if ((Read-Host (T "UnConfirm")) -eq "Y") {
        $Selection | ForEach-Object { & $_.Action }
        Write-Host "`n$(T 'UnSuccess')" -ForegroundColor Green
    }
}
pause