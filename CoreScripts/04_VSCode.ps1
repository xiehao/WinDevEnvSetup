Write-Host "[Step 4] 安装 VSCode..." -ForegroundColor Yellow
if (!(Get-Command code -ErrorAction SilentlyContinue)) { scoop install vscode }