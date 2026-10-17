param(
  [string]$Workspace = (Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'AI-Research-Workbench'),
  [switch]$Install,
  [switch]$Open
)
$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$TemplateRoot = Join-Path $RepoRoot 'templates/workspace'
New-Item -ItemType Directory -Path $Workspace -Force | Out-Null
Get-ChildItem -LiteralPath $TemplateRoot -Recurse -File | ForEach-Object {
  $Relative = $_.FullName.Substring($TemplateRoot.Length).TrimStart([char[]]@('\','/'))
  $Target = Join-Path $Workspace $Relative
  New-Item -ItemType Directory -Path (Split-Path -Parent $Target) -Force | Out-Null
  if (Test-Path -LiteralPath $Target) { Write-Output "KEPT existing: $Relative" }
  else { Copy-Item -LiteralPath $_.FullName -Destination $Target; Write-Output "CREATED: $Relative" }
}
function Find-Code {
  $Found = Get-Command code -ErrorAction SilentlyContinue
  if ($Found) { return $Found.Source }
  $Candidates = @()
  if ($env:LOCALAPPDATA) { $Candidates += (Join-Path $env:LOCALAPPDATA 'Programs/Microsoft VS Code/bin/code.cmd') }
  if ($env:ProgramFiles) { $Candidates += (Join-Path $env:ProgramFiles 'Microsoft VS Code/bin/code.cmd') }
  foreach ($Candidate in $Candidates) { if (Test-Path -LiteralPath $Candidate) { return $Candidate } }
  return $null
}
$Code = Find-Code
if ($Install) {
  if (-not $Code) {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw 'winget not found. Install VS Code from https://code.visualstudio.com/ and rerun.' }
    & winget install --id Microsoft.VisualStudioCode --exact --source winget
    if ($LASTEXITCODE -ne 0) { throw "VS Code installation incomplete (exit $LASTEXITCODE). Resolve the displayed prompt; do not bypass it." }
    $Code = Find-Code
    if (-not $Code) { throw 'VS Code CLI not found after installation; restart the terminal or use the manual guide.' }
  }
  & $Code --install-extension OpenAI.chatgpt
  if ($LASTEXITCODE -ne 0) { throw 'Codex extension installation failed.' }
  & $Code --install-extension anthropic.claude-code
  if ($LASTEXITCODE -ne 0) { throw 'Claude Code extension installation failed.' }
  & $Code --list-extensions
  if ($LASTEXITCODE -ne 0) { throw 'Could not list installed extensions.' }
}
$WorkspaceFile = Join-Path $Workspace '我的项目.code-workspace'
Write-Output "Workspace: $WorkspaceFile"
Write-Output 'Next: verify both extensions and sign in yourself, then follow docs/HANDOFF.md.'
if ($Open) {
  if ($Code) { & $Code --new-window $WorkspaceFile }
  else { Write-Output 'VS Code not found. Follow docs/MANUAL.md.' }
  Start-Process (Join-Path $Workspace '03_结果/示例_一周待办.html')
}
