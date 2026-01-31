# Enable Windows Features
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

$Arch = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "arm64" } else { "x64" }
$msi = Join-Path $ResourceDir "wsl_update_$Arch.msi"

# Install WSL2
if (Test-Path $msi) {
    # Tier 1: Local MSI
    Write-Host ((T "LocalFirst") -f $msi)
    Start-Process msiexec.exe -ArgumentList "/i `"$msi`" /quiet /norestart" -Wait
}
else {
    # Tier 2: Network Update
    Write-Host (T "NetFallback")
    wsl --update
}

# Path config
$choice = Read-Host (T "WslPathPrompt")
if ($choice -ne "N") {
    $target = Read-Host (T "InputPath")
    if ($target) {
        $State.WSLPath = $target
    }
}