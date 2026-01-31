$Messages = @{
    "zh-CN" = @{
        "Start"         = "=== 容器开发环境安装程序 ==="
        "StepRunning"   = ">>> 正在运行步骤 {0}: {1}"
        "ErrorExit"     = "[错误] 步骤 {0} 失败，退出码: {1}"
        "RebootNote"    = "[提示] 步骤 {0} 请求重启。请重启电脑后再次运行脚本。"
        "ResetChoice"   = "检测到环境已安装完成。是否重置并重新运行所有步骤？(Y/N, 默认: N)"
        "WslPathPrompt" = "是否修改 WSL 默认存储路径？(默认: D:\WSL, 输入 N 跳过)"
        "InputPath"     = "请输入路径 [D:\WSL]"
        "LocalFirst"    = "检测到本地资源 {0}，优先使用本地安装。"
        "NetFallback"   = "未发现本地资源，尝试通过网络下载安装..."
        "Success"       = "安装圆满完成！请根据 README 导入 VSCode 配置文件。"
        "ImageExists"   = "镜像 {0} 已存在，跳过导入。"
    }
    "en-US" = @{
        "Start"         = "=== Container Environment Setup ==="
        "StepRunning"   = ">>> Running Step {0}: {1}"
        "ErrorExit"     = "[ERROR] Step {0} failed with Exit Code: {1}"
        "RebootNote"    = "[NOTE] Step {0} requested a reboot. Please restart and run again."
        "ResetChoice"   = "Setup already completed. Reset and re-run all steps? (Y/N, Default: N)"
        "WslPathPrompt" = "Change default WSL path? (Default: D:\WSL, Enter 'N' to skip)"
        "InputPath"     = "Input path [D:\WSL]"
        "LocalFirst"    = "Local resource {0} found. Using local installation."
        "NetFallback"   = "Local resource not found. Falling back to network..."
        "Success"       = "Setup Completed Successfully! Check README for VSCode profile."
        "ImageExists"   = "Image {0} already exists. Skipping."
    }
}
$Lang = if ((Get-Culture).Name -eq "zh-CN") { "zh-CN" } else { "en-US" }
function T($Key) { return $Messages[$Lang][$Key] }