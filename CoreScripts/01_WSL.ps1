Write-Host "Configuring WSL2..." -ForegroundColor Yellow

# Enable Windows Features
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Tier 1: Local MSI
$msi = Join-Path $ResourceDir "wsl_update_x64.msi"
if (Test-Path $msi) {
    Write-Host "Installing local WSL kernel update..."
    Start-Process msiexec.exe -ArgumentList "/i `"$msi`" /quiet /norestart" -Wait
} else {
    # Tier 2: Network Update
    Write-Host "未找到本地 MSI 安装包，尝试通过网络更新..."
    wsl --update
}

# Path config
$choice = Read-Host "Change default WSL path? (Default: D:\WSL, Enter 'N' to skip)"
if ($choice -ne "N") {
    $target = Read-Host "Input path [D:\WSL]"
    if ($target) { $State.WSLPath = $target }
}