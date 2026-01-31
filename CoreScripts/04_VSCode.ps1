if (!(Get-Command code -ErrorAction SilentlyContinue)) {
    scoop install vscode
    scoop cache rm *
}