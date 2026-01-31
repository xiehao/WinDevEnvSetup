Write-Host "Setting up Container Image..." -ForegroundColor Yellow

$status = podman machine inspect --format "{{.State}}"
if ($status -ne "running") { podman machine start }

$tar = Join-Path $ResourceDir "arch-cpp-dev.tar.zst"
$df = Join-Path $ResourceDir "Dockerfile"

# Tier 1: Local Load
if (Test-Path $tar) {
    Write-Host "Loading local image tarball..."
    podman load -i $tar
} 
# Tier 2: Build from Dockerfile
elseif (Test-Path $df) {
    Write-Host "Building image from Dockerfile..."
    podman build -t arch-cpp-dev:latest -f $df $ResourceDir
} 
# Tier 3: Error
else {
    Write-Error "No image source found in Resources!"
    exit 1
}