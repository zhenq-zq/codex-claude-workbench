# 🧬 AI 科研工作台 · Codex × Claude

**你定方向，Codex 拆任务，Claude 执行，Codex 与你一起复核。**

把下面这段连同本仓库链接交给你的 AI，按指南搭建同款工作台。

```text
请阅读 https://github.com/zhenq-zq/codex-claude-workbench 的 DEPLOY_FOR_AI.md，按其中步骤帮我部署。
先检查你是否具备当前电脑的文件、终端或桌面操作权限，再识别系统和已有软件。
有权限就实际执行；没有权限就每次只指导一个步骤，等我完成后继续。
安装缺失的 VS Code 和官方 Codex、Claude Code 扩展，建立项目目录、共享任务和进度记录。
账号登录和系统授权提醒我自己完成，不读取或代填密码，不自动付费。
用虚拟示例检查结果，打开工作区与结果网页，逐项报告通过、待我操作、未验证的部分。
不要只给方案；也不要把发出命令当作部署成功。
```

如果 AI 无法打开 GitHub：[下载 ZIP](https://github.com/zhenq-zq/codex-claude-workbench/archive/refs/heads/main.zip)，解压后把 `DEPLOY_FOR_AI.md` 发给它。

## 装好后是什么样

```text
我的项目/
├─ 00_选题与研究主线/
├─ 01_模拟与实验/
├─ 02_分析与制图/
├─ 03_结果/
├─ 04_稿件/
├─ 05_投稿/
├─ 项目进度.md
├─ TASK.md
├─ PROJECT_MEMORY.md
├─ AGENTS.md
└─ CLAUDE.md
```

左侧按研究顺序找文件，中间打开进度和结果，右侧使用 AI 扩展。技术约定文件保留在磁盘，工作区里隐藏，避免挤占导航。

## 两种开始方式

- **交给 AI**：复制上面的指令。AI 按 [部署指南](DEPLOY_FOR_AI.md) 检查、执行和验收。
- **自己操作**：阅读 [手动指南](docs/MANUAL.md)，运行本仓库脚本。

Mac：

```bash
bash scripts/setup-macos.sh --install --open
```

Windows（PowerShell，在解压后的仓库目录）：

```powershell
powershell -File .\scripts\setup-windows.ps1 -Install -Open
```

默认项目放在系统用户目录的 `Documents/AI-Research-Workbench`。可指定独立新目录，见指南。**不覆盖同名文件**；已有项目出现冲突时请先让 AI 比对。

## 第一次练习

项目创建后，结果目录里已有一个可直接打开的 [虚拟示例](example/index.html)。它用于确认本地网页能打开，不代表 Claude 已执行任务。

在 Codex 里描述你的目标，让它写好 `TASK.md`；复制 [Claude 执行指令](docs/HANDOFF.md) 到 Claude 面板；完成后回到 Codex 复核真实产物。

当前版本通过共享文件交接，两个扩展不会自动互发消息。若操作者的 AI 有桌面控制能力，可以代为转交；没有该能力就手动复制。任何时候只让一个执行者写文件。

## 这个版本包含什么

- Mac／Windows 环境检查、VS Code 官方安装入口与扩展安装脚本。
- 你的编号目录、项目约定、任务、记忆、最新在上的进度模板。
- 明亮主题建议、隐藏后台文件、推荐扩展、独立 `.code-workspace` 文件。
- 虚拟待办网页、交接与验收指令。
- [测试范围](docs/VALIDATION.md) 和 [常见问题](docs/TROUBLESHOOTING.md)。

LaTeX 源文件位置已预留；**本包不默认下载庞大的 TeX 发行版、不安装模拟器、不替你做科研判断**。需要时按 [可选模块](docs/MODULES.md) 添加。

## 使用条件

需要联网访问官方服务，并有相应账号与地区使用条件。软件安装与模型额度是两回事；本包不包含模型订阅，也不提供绕过服务限制的方法。系统权限、账号登录、许可条款由用户处理。

**当前发布为 v0.1.0 预览版**：目录初始化与示例已做本地检查；全新 Windows／Mac 上的软件下载安装、登录和跨面板交接仍需实测。不要把它当作已验证的无人值守安装器。

## 官方依据

安装指令核对于 2026-10-17：[VS Code CLI](https://code.visualstudio.com/docs/configure/command-line)、[Codex IDE](https://developers.openai.com/codex/ide)、[Claude Code VS Code](https://code.claude.com/docs/en/vs-code)。具体支持情况以官方当前文档为准。

模板与代码采用 [MIT](LICENSE)。本项目不是 OpenAI、Anthropic 或 Microsoft 官方产品。
