$ResourceDir = Join-Path $PSScriptRoot "Resources"
if (!(Test-Path $ResourceDir)) { New-Item -ItemType Directory -Path $ResourceDir }

$Files = @(
    @{ Name = "wsl_update_x64.msi"; Url = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" },
    @{ Name = "fedora-coreos-wsl.xz"; Url = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/41.20250106.3.0/x86_64/fedora-coreos-41.20250106.3.0-live-rootfs.x86_64.img.tar.xz" }
)

foreach ($File in $Files) {
    $TargetPath = Join-Path $ResourceDir $File.Name
    if (!(Test-Path $TargetPath)) {
        Write-Host "正在下载 $($File.Name)..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $File.Url -OutFile $TargetPath
    }
}
Write-Host "大文件下载完成！请手动放入 Dockerfile, arch-cpp-dev.tar.zst 和 Container.code-profile。" -ForegroundColor Green