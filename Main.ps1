$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ResourceDir = Join-Path $PSScriptRoot "Resources"
$ScriptDir = Join-Path $PSScriptRoot "CoreScripts"
$StateFile = Join-Path $PSScriptRoot ".setup_state.json"

# --- 状态初始化逻辑 ---
if (Test-Path $StateFile) {
    $State = Get-Content $StateFile | ConvertFrom-Json
    
    # 如果检测到步数已经到达 6 (即上次已完成)
    if ($State.Step -ge 6) {
        Write-Host "[INFO] Setup was previously completed." -ForegroundColor Yellow
        $choice = Read-Host "Do you want to reset and re-run from Step 1? (Y/N, Default: N)"
        if ($choice -eq "Y" -or $choice -eq "y") {
            $State.Step = 1
            Write-Host "Resetting to Step 1..." -ForegroundColor Gray
        }
    }
} else {
    # 第一次运行，初始化默认值
    $State = @{ 
        Step = 1; 
        WSLPath = "D:\WSL"; 
        ScoopPath = "D:\Scoop"; 
        GlobalPath = "D:\ScoopGlobal" 
    }
}

# 辅助函数：保存当前进度
function Save-State($step) {
    $State.Step = $step
    $State | ConvertTo-Json | Out-File $StateFile
}

# --- 检查当前是否还需要运行 ---
if ($State.Step -ge 6) {
    Write-Host "`nAll steps are already marked as completed." -ForegroundColor Green
} else {
    Write-Host "`n=== Container Environment Setup (Starting from Step $($State.Step)) ===" -ForegroundColor Cyan

    # Step 执行循环
    for ($i = [int]$State.Step; $i -le 5; $i++) {
        $Pattern = "0${i}*.ps1"
        $Scripts = Get-ChildItem -Path $ScriptDir -Filter $Pattern
        
        if ($Scripts) {
            $Script = $Scripts[0]
            Write-Host "`n>>> Running Step ${i}: $($Script.Name)" -ForegroundColor Cyan
            
            & $Script.FullName

            # 检查执行结果：允许 0 (成功) 和 3010 (成功但需重启)
            $AllowedExitCodes = @(0, 3010)

            if ($null -ne $LASTEXITCODE -and $AllowedExitCodes -notcontains $LASTEXITCODE) {
                Write-Host "`n[ERROR] Step ${i} failed with Exit Code: $LASTEXITCODE" -ForegroundColor Red
                exit $LASTEXITCODE
            }

            # 如果是 3010，给用户一个友好提示
            if ($LASTEXITCODE -eq 3010) {
                Write-Host "`n[NOTE] Step ${i} requested a reboot. You can continue, but some features may require a restart." -ForegroundColor Yellow
            }

            Save-State ($i + 1)
        }
    }
}

Write-Host "`n====================================================" -ForegroundColor Green
Write-Host "Setup Completed Successfully!"
Write-Host "Please check the README for manual VSCode profile import."
Write-Host "===================================================="