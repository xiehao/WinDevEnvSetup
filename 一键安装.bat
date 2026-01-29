@echo off
:: 自动提权：请求管理员权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

echo [1/2] 正在开启 PowerShell 脚本执行权限...
powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"

echo [2/2] 正在启动主安装程序...
powershell -File "%~dp0Main.ps1"
pause