#!/usr/bin/env bash
# Crux Platform — convert.sh
# Syncs agent and skill definitions to tool-specific locations
set -euo pipefail

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RESET='\033[0m'
ok()   { echo -e "  ${GREEN}✓${RESET} $*"; }
info() { echo -e "  ${CYAN}→${RESET} $*"; }
warn() { echo -e "  ${YELLOW}⚠${RESET} $*"; }

TOOL="auto"
SOURCE="${CRUX_HOME:-$HOME/.crux}"
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool)    TOOL="$2";    shift 2 ;;
    --source)  SOURCE="$2";  shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    *) shift ;;
  esac
done

# Auto-detect tool
if [[ "$TOOL" == "auto" ]]; then
  if [[ -d ".claude" ]];  then TOOL="claude-code"
  elif [[ -d ".opencode" ]]; then TOOL="opencode"
  elif [[ -d ".cursor" ]];  then TOOL="cursor"
  else TOOL="claude-code"  # default
  fi
  info "Auto-detected tool: $TOOL"
fi

copy_if_changed() {
  local src="$1" dest="$2"
  [[ ! -f "$src" ]] && return
  $DRY_RUN && { info "[dry-run] $dest"; return; }
  mkdir -p "$(dirname "$dest")"
  if [[ ! -f "$dest" ]] || ! cmp -s "$src" "$dest"; then
    cp "$src" "$dest"
    ok "$dest"
  fi
}

convert_for_tool() {
  local tool="$1"
  local agents_src="$SOURCE/agents"
  [[ ! -d "$agents_src" ]] && return

  case "$tool" in
    claude-code)
      while IFS= read -r agent_file; do
        role=$(basename "$(dirname "$agent_file")")
        copy_if_changed "$agent_file" ".claude/agents/${role}.md"
      done < <(find "$agents_src" -name "AGENT.md" | sort) ;;

    opencode)
      while IFS= read -r agent_file; do
        role=$(basename "$(dirname "$agent_file")")
        copy_if_changed "$agent_file" ".opencode/agent/${role}.md"
      done < <(find "$agents_src" -name "AGENT.md" | sort) ;;

    cursor)
      while IFS= read -r agent_file; do
        role=$(basename "$(dirname "$agent_file")")
        copy_if_changed "$agent_file" ".cursor/rules/${role}.md"
      done < <(find "$agents_src" -name "AGENT.md" | sort) ;;

    all)
      convert_for_tool "claude-code"
      convert_for_tool "opencode"
      convert_for_tool "cursor" ;;

    *) warn "Unknown tool: $tool" ;;
  esac
}

convert_for_tool "$TOOL"
ok "Conversion complete for tool: $TOOL"
