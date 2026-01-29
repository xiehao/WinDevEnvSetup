Write-Host "[Step 1] 配置 WSL2..." -ForegroundColor Yellow
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

$msi = Join-Path $ResourceDir "wsl_update_x64.msi"
if (Test-Path $msi) { Start-Process msiexec.exe -ArgumentList "/i `"$msi`" /quiet /norestart" -Wait }

$choice = Read-Host "修改 WSL 默认存储路径？(默认 D:\WSL, 输入 N 跳过)"
if ($choice -ne "N") { $target = Read-Host "输入路径 [D:\WSL]"; if ($target) { $State.WSLPath = $target } }