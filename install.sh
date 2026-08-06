#!/usr/bin/env bash
# omniroute-skill installer — copies SKILL.md (+ DESCRIPTION.md) into every
# agent skills directory it finds. Safe to re-run (overwrites with latest).
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_NAME="omniroute"
installed=0

install_to() {
  local dest="$1"
  mkdir -p "$dest"
  cp "$SRC_DIR/SKILL.md" "$dest/SKILL.md"
  cp "$SRC_DIR/DESCRIPTION.md" "$dest/DESCRIPTION.md"
  echo "  ✓ installed -> $dest"
  installed=$((installed + 1))
}

echo "Installing omniroute skill..."

# OpenCode (also the canonical location used by most setups)
[[ -d "$HOME/.agents/skills" ]] && install_to "$HOME/.agents/skills/$SKILL_NAME"

# Codex
[[ -d "$HOME/.codex/skills" ]] && install_to "$HOME/.codex/skills/$SKILL_NAME"

# Claude Code
[[ -d "$HOME/.claude" ]] && install_to "$HOME/.claude/skills/$SKILL_NAME"

# Hermes
[[ -d "$HOME/.hermes/skills" ]] && install_to "$HOME/.hermes/skills/$SKILL_NAME"

# OpenClaw (extension-style install)
if [[ -d "$HOME/.openclaw/extensions" ]]; then
  install_to "$HOME/.openclaw/extensions/$SKILL_NAME/skills/$SKILL_NAME"
  cat > "$HOME/.openclaw/extensions/$SKILL_NAME/openclaw.plugin.json" <<'EOF'
{
  "name": "omniroute",
  "version": "1.0.0",
  "description": "Control and integrate with OmniRoute (self-hosted AI gateway)",
  "skills": ["skills/omniroute"]
}
EOF
  echo "  ✓ wrote openclaw plugin manifest -> ~/.openclaw/extensions/$SKILL_NAME/"
  installed=$((installed + 1))
fi

if [[ "$installed" -eq 0 ]]; then
  echo "No supported agent skill directories found."
  echo "Manual install: copy SKILL.md into <your-agent>/skills/omniroute/"
  echo "Found none of: ~/.agents/skills, ~/.codex/skills, ~/.claude, ~/.hermes/skills, ~/.openclaw/extensions"
  exit 1
fi

echo "Done — installed into $installed location(s)."
echo "Next: tell your agent to read SKILL.md (or just ask it to 'use the omniroute skill')."
