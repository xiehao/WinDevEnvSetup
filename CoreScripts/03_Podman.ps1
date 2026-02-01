if (!(Get-Command podman -ErrorAction SilentlyContinue)) {
    scoop install podman
    scoop cache rm *
}

# Symbolic Link for Path Redirection
Write-Host (T "PodmanLink") -ForegroundColor Cyan
$LocalAppPath = "$env:LOCALAPPDATA\containers"
if (!(Test-Path $LocalAppPath)) {
    $target = Join-Path $State.WSLPath "podman-data"
    if (!(Test-Path $target)) {
        New-Item -ItemType Directory -Path $target -Force
    }
    # Create directory link using CMD
    cmd /c mklink /j "$LocalAppPath" "$target"
}

# Initialize podman machine
if (!(podman machine list | Select-String "podman-machine-default")) {
    # Find local rootfs resource
    $rootfs = Get-ChildItem -Path $ResourceDir -Filter "podman-machine-*.tar*" | Select-Object -First 1
    
    if ($rootfs) {
        Write-Host (T "LocalFirst" $rootfs.Name) -ForegroundColor Green
        
        # # --- 网络驱动器规避逻辑 ---
        # $ImportPath = $rootfs.FullName
        # $isNetwork = $rootfs.FullName.StartsWith("Z:") -or $rootfs.FullName.StartsWith("\\")
        
        # if ($isNetwork) {
        #     Write-Host (T "NetworkDrive") -ForegroundColor Yellow
        #     $TempLocalFile = Join-Path $env:TEMP $rootfs.Name
        #     Copy-Item $rootfs.FullName $TempLocalFile -Force
        #     $ImportPath = $TempLocalFile
        # }

        # Execute initialization
        podman machine init --image-path "$ImportPath" --rootful
        
        # Clean up temporary files
        if ($isNetwork -and (Test-Path $TempLocalFile)) { 
            Remove-Item $TempLocalFile -ErrorAction SilentlyContinue 
        }
    } else {
        Write-Host (T "NetFallback") -ForegroundColor Yellow
        podman machine init --rootful
    }
}