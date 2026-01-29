Write-Host "[Step 3] 配置 Podman..." -ForegroundColor Yellow
if (!(Get-Command podman -ErrorAction SilentlyContinue)) { scoop install podman }

$LocalAppPath = "$env:LOCALAPPDATA\containers"
if (!(Test-Path $LocalAppPath)) {
    $target = Join-Path $State.WSLPath "podman-data"
    New-Item -ItemType Directory -Path $target -Force
    cmd /c mklink /j "$LocalAppPath" "$target"
}

$fcos = Join-Path $ResourceDir "fedora-coreos-wsl.xz"
if (!(podman machine list | Select-String "podman-machine-default")) {
    podman machine init --image-path "$fcos" --rootful
}