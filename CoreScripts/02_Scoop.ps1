Write-Host "[Step 2] 安装 Scoop..." -ForegroundColor Yellow
if (Get-Command scoop -ErrorAction SilentlyContinue) { return }

$sRoot = Read-Host "Scoop 安装路径 [D:\Scoop]"; if (!$sRoot) { $sRoot = "D:\Scoop" }
$gRoot = Read-Host "全局软件路径 [D:\ScoopGlobal]"; if (!$gRoot) { $gRoot = "D:\ScoopGlobal" }

[Environment]::SetEnvironmentVariable('SCOOP', $sRoot, 'User')
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $gRoot, 'Machine')
$env:SCOOP = $sRoot; $env:SCOOP_GLOBAL = $gRoot

Invoke-RestMethod -Uri "https://gitee.com/glennirwin/scoop-cn/raw/master/install.ps1" | Invoke-Expression
scoop bucket add main
scoop bucket add extras
scoop install 7zip git
scoop cache rm *