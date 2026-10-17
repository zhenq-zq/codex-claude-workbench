#!/bin/bash
# Run from the downloaded repository. No sudo; never overwrite project files.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORKSPACE="$HOME/Documents/AI-Research-Workbench"
INSTALL=0
OPEN=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --workspace) [ "$#" -ge 2 ] || { echo 'Missing workspace path' >&2; exit 2; }; WORKSPACE="$2"; shift 2;;
    --install) INSTALL=1; shift;;
    --open) OPEN=1; shift;;
    *) echo "Unknown option: $1" >&2; exit 2;;
  esac
done
[ "$(uname -s)" = Darwin ] || { echo 'This script supports macOS only.' >&2; exit 2; }
mkdir -p "$WORKSPACE"
# Source template is fixed and project-local. cp -n preserves all existing files.
while IFS= read -r -d '' source; do
  relative="${source#"$ROOT/templates/workspace/"}"
  target="$WORKSPACE/$relative"
  mkdir -p "$(dirname "$target")"
  if [ -e "$target" ] || [ -L "$target" ]; then
    printf 'KEPT existing: %s\n' "$relative"
  else
    cp -n "$source" "$target"
    printf 'CREATED: %s\n' "$relative"
  fi
done < <(find "$ROOT/templates/workspace" -type f -print0)
find_code() {
  if command -v code >/dev/null 2>&1; then command -v code; return; fi
  for item in '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"; do
    if [ -x "$item" ]; then printf '%s\n' "$item"; return; fi
  done
  return 1
}
CODE="$(find_code || true)"
if [ "$INSTALL" -eq 1 ]; then
  if [ -z "$CODE" ]; then
    case "$(uname -m)" in arm64) PLATFORM=darwin-arm64;; x86_64) PLATFORM=darwin;; *) echo 'Unsupported Mac CPU' >&2; exit 2;; esac
    DOWNLOADS="$ROOT/.downloads"
    mkdir -p "$DOWNLOADS/unpacked" "$HOME/Applications"
    curl --fail --location --proto '=https' --tlsv1.2 "https://update.code.visualstudio.com/latest/$PLATFORM/stable" -o "$DOWNLOADS/vscode.zip"
    ditto -x -k "$DOWNLOADS/vscode.zip" "$DOWNLOADS/unpacked"
    APP="$DOWNLOADS/unpacked/Visual Studio Code.app"
    codesign --verify --deep --strict "$APP"
    spctl --assess --type execute "$APP"
    DEST="$HOME/Applications/Visual Studio Code.app"
    [ ! -e "$DEST" ] || { echo 'Existing app found; stopping without overwriting it.' >&2; exit 1; }
    mv "$APP" "$DEST"
    CODE="$(find_code)"
  fi
  "$CODE" --install-extension OpenAI.chatgpt
  "$CODE" --install-extension anthropic.claude-code
  "$CODE" --list-extensions
fi
printf '\nWorkspace: %s\n' "$WORKSPACE/我的项目.code-workspace"
printf 'Next: verify both extensions and sign in yourself, then follow docs/HANDOFF.md.\n'
if [ "$OPEN" -eq 1 ]; then
  if [ -n "$CODE" ]; then "$CODE" --new-window "$WORKSPACE/我的项目.code-workspace"; else echo 'VS Code not found. Install it using docs/MANUAL.md.'; fi
  open "$WORKSPACE/03_结果/示例_一周待办.html"
fi
