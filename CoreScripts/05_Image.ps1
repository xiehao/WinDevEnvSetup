Write-Host "[Step 5] 准备容器镜像..." -ForegroundColor Yellow
podman machine start
$tar = Join-Path $ResourceDir "arch-cpp-dev.tar.zst"
if (Test-Path $tar) { podman load -i $tar }
elseif (Test-Path "$ResourceDir\Dockerfile") {
    cd $ResourceDir; podman build -t arch-cpp-dev:latest .
}