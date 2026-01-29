$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ResourceDir = Join-Path $PSScriptRoot "Resources"
$ScriptDir = Join-Path $PSScriptRoot "CoreScripts"
$StateFile = Join-Path $PSScriptRoot ".setup_state.json"

if (Test-Path $StateFile) {
    $State = Get-Content $StateFile | ConvertFrom-Json
} else {
    $State = @{ Step = 1; WSLPath = "D:\WSL"; ScoopPath = "D:\Scoop"; GlobalPath = "D:\ScoopGlobal" }
}

function Save-State($step) { $State.Step = $step; $State | ConvertTo-Json | Out-File $StateFile }

Write-Host "=== 容器化编程环境安装程序 ===" -ForegroundColor Cyan

for ($i = $State.Step; $i -le 5; $i++) {
    $ScriptName = (Get-ChildItem -Path $ScriptDir -Filter "0$i*.ps1").FullName
    if ($ScriptName) { . $ScriptName; Save-State ($i + 1) }
}

# 最终提示
Clear-Host
Write-Host "================ 安装完成！ ================" -ForegroundColor Green
Write-Host "1. 请手动在 VSCode 中导入配置文件: $ResourceDir\Container.code-profile"
Write-Host "2. 检查 C:\Users\<用户名>\AppData\Local\Packages 搜索并清理旧的 .vhdx 文件"
Write-Host "3. 建议重启电脑以确保所有环境变量生效。"
Write-Host "============================================"