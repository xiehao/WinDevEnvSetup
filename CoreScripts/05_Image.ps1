$status = podman machine inspect --format "{{.State}}"
if ($status -ne "running") {
    podman machine start 
}

if (podman images -q arch-cpp-dev) {
    Write-Host ((T "ImageExists") -f "arch-cpp-dev")
}
else {
    $tar = Join-Path $ResourceDir "arch-cpp-dev.tar.zst"
    $df = Join-Path $ResourceDir "Dockerfile"

    # Tier 1: Local Load
    if (Test-Path $tar) {
        Write-Host ((T "LocalFirst") -f $tar)
        podman load -i $tar
    }
    # Tier 2: Build from Dockerfile
    elseif (Test-Path $df) {
        Write-Host (T "NetFallback")
        podman build -t arch-cpp-dev:latest -f $df $ResourceDir
    }
}