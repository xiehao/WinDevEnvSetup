Write-Host "Installing VSCode..." -ForegroundColor Yellow
if (!(Get-Command code -ErrorAction SilentlyContinue)) {
    scoop install vscode
    scoop cache rm *
}