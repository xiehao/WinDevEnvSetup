if (!(Get-Command code -ErrorAction SilentlyContinue)) {
    scoop install vscode
    scoop cache rm *
} else {
    # 可以在 Messages.ps1 增加一个 "ComponentExists"
    # Write-Host (T "ComponentExists" "VS Code")
}