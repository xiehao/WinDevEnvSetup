# Write-Host "Installing Podman..." -ForegroundColor Yellow
# if (!(Get-Command podman -ErrorAction SilentlyContinue)) {
#     scoop install podman
#     scoop cache rm *
# }

# # Symbolic Link for Path Redirection
# $LocalAppPath = "$env:LOCALAPPDATA\containers"
# if (!(Test-Path $LocalAppPath)) {
#     $target = Join-Path $State.WSLPath "podman-data"
#     if (!(Test-Path $target)) { New-Item -ItemType Directory -Path $target -Force }
#     cmd /c mklink /j "$LocalAppPath" "$target"
# }

# # Tiered Init
# if (!(podman machine list | Select-String "podman-machine-default")) {
#     $fcos = Join-Path $ResourceDir "fedora-coreos-wsl.xz"
#     if (Test-Path $fcos) {
#         Write-Host "Initializing Podman from local image..."
#         podman machine init --image-path "$fcos" --rootful
#     } else {
#         Write-Host "Local image not found. Initializing from network..."
#         podman machine init --rootful
#     }
# }

if (!(Get-Command podman -ErrorAction SilentlyContinue)) {
    scoop install podman
    scoop cache rm *
}

# Symbolic Link for Path Redirection
$LocalAppPath = "$env:LOCALAPPDATA\containers"
if (!(Test-Path $LocalAppPath)) {
    $target = Join-Path $State.WSLPath "podman-data"
    if (!(Test-Path $target)) {
        New-Item -ItemType Directory -Path $target -Force
    }
    cmd /c mklink /j "$LocalAppPath" "$target"
}

$PodmanArch = if ($Arch -eq "x64") { "x86_64" } else { "aarch64" }
$zst = Join-Path $ResourceDir "podman-machine-$PodmanArch-wsl.tar.zst"

# Tiered Init
if (!(podman machine list | Select-String "podman-machine-default")) {
    if (Test-Path $zst) {
        Write-Host ((T "LocalFirst") -f $zst)
        podman machine init --image-path "$zst" --rootful
    }
    else {
        Write-Host (T "NetFallback")
        podman machine init --rootful
    }
}