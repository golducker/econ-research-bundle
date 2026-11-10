#!/usr/bin/env bash
# Install the econ-research skill bundle.
# Usage: ./install.sh [claude|codex|gemini|all]   (default: all)
#   claude -> ~/.claude/skills   (Claude Code)
#   codex  -> ~/.agents/skills   (Codex CLI, ChatGPT desktop app)
#   gemini -> ~/.gemini/skills   (Gemini CLI)
set -euo pipefail

target="${1:-all}"
src="$(cd "$(dirname "$0")" && pwd)/skills"

case "$target" in
  claude) dests=("$HOME/.claude/skills") ;;
  codex)  dests=("$HOME/.agents/skills") ;;
  gemini) dests=("$HOME/.gemini/skills") ;;
  all)    dests=("$HOME/.claude/skills" "$HOME/.agents/skills" "$HOME/.gemini/skills") ;;
  *) echo "Unknown target: $target (use claude, codex, gemini or all)"; exit 1 ;;
esac

for dest in "${dests[@]}"; do
  mkdir -p "$dest"
  for skill in "$src"/*/; do
    name="$(basename "$skill")"
    rm -rf "${dest:?}/$name"
    cp -R "$skill" "$dest/$name"
  done
  echo "Installed $(ls "$src" | wc -l | tr -d ' ') skills into $dest"
done
echo "Done. Restart your agent, then type /econ-research (Claude Code) or ask for the econ-research skill."
