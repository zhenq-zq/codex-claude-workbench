# 手动部署：每次做一步

1. 从 https://code.visualstudio.com/ 下载适合系统的 VS Code，按系统提示安装。
2. 在扩展商店安装 Codex（OpenAI）与 Claude Code（Anthropic），核对发布者，再分别登录。
3. 下载本仓库 ZIP，解压，用 VS Code 打开解压后的仓库文件夹。
4. 在 VS Code 终端运行对应系统的 setup 脚本。只建目录时不加安装参数：

Mac：`bash scripts/setup-macos.sh --open`
Windows：`powershell -File .\scripts\setup-windows.ps1 -Open`

5. 打开脚本给出的 `我的项目.code-workspace`。如果系统不允许脚本运行，让你的 AI 逐项读取 `templates/workspace/`，用其文件工具复制到一个新目录；不要关闭系统安全策略。
6. 展开左侧编号目录，打开 `项目进度.md`，再打开 `03_结果/示例_一周待办.html`（默认浏览器）。
7. 按 `HANDOFF.md` 开始第一轮任务。

没有 Python、Node、Git 也能下载 ZIP 和创建基础工作区；安装和使用 AI 扩展仍需要账号与官方服务可达。
