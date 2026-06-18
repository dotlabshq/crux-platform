#!/usr/bin/env bash
# Crux Platform — convert.sh
# Syncs agent definitions to tool-specific locations
# Sets Arc as the default agent so no @mention is needed
set -euo pipefail

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RESET='\033[0m'
ok()   { echo -e "  ${GREEN}✓${RESET} $*"; }
info() { echo -e "  ${CYAN}→${RESET} $*"; }
warn() { echo -e "  ${YELLOW}⚠${RESET} $*"; }

TOOL="auto"
SOURCE="${CRUX_HOME:-$HOME/.crux}"
DRY_RUN=false
AGENTS_FILTER=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool)    TOOL="$2";           shift 2 ;;
    --source)  SOURCE="$2";         shift 2 ;;
    --agents)  AGENTS_FILTER="$2";  shift 2 ;;
    --dry-run) DRY_RUN=true;        shift ;;
    *) shift ;;
  esac
done

if [[ "$TOOL" == "auto" ]]; then
  if   [[ -d ".claude" ]];    then TOOL="claude-code"
  elif [[ -d ".opencode" ]];  then TOOL="opencode"
  elif [[ -d ".cursor" ]];    then TOOL="cursor"
  elif [[ -d ".windsurf" ]];  then TOOL="windsurf"
  else TOOL="claude-code"
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

should_include() {
  local role="$1"
  [[ -z "$AGENTS_FILTER" ]] && return 0
  echo "$AGENTS_FILTER" | tr ',' '\n' | grep -qx "$role"
}

convert_claude_code() {
  local agents_src="$SOURCE/agents"
  [[ ! -d "$agents_src" ]] && return

  $DRY_RUN || mkdir -p ".claude/agents"

  # Copy all agent AGENT.md files
  while IFS= read -r agent_file; do
    local role
    role=$(basename "$(dirname "$agent_file")")
    should_include "$role" || continue
    copy_if_changed "$agent_file" ".claude/agents/${role}.md"
  done < <(find "$agents_src" -name "AGENT.md" | sort)

  # CLAUDE.md — sets Arc as default, no @mention needed
  local claude_md="CLAUDE.md"
  if [[ ! -f "$claude_md" ]] || ! grep -q "You are Arc" "$claude_md" 2>/dev/null; then
    $DRY_RUN && { info "[dry-run] CLAUDE.md"; return; }
    cat > "$claude_md" << 'CLAUDE_EOF'
# Arc — Crux Platform Coordinator

You are **Arc**, the coordinator for this project.

Read `{framework-home}/skills/crux-arc/SKILL.md` at session start.
Default `{framework-home}` is `$HOME/.crux` unless `CRUX_HOME` is set.

You are Arc by default. The user does not need to type @arc.
When the user asks for another agent by name, load that agent's AGENT.md from `.claude/agents/`.
CLAUDE_EOF
    ok "CLAUDE.md (Arc as default)"
  else
    info "CLAUDE.md already set"
  fi
}

convert_opencode() {
  local agents_src="$SOURCE/agents"
  [[ ! -d "$agents_src" ]] && return

  $DRY_RUN || mkdir -p ".opencode/agents"

  while IFS= read -r agent_file; do
    local role
    role=$(basename "$(dirname "$agent_file")")
    should_include "$role" || continue
    copy_if_changed "$agent_file" ".opencode/agents/${role}.md"
  done < <(find "$agents_src" -name "AGENT.md" | sort)

  # opencode default agent config
  local cfg=".opencode/config.json"
  if [[ ! -f "$cfg" ]]; then
    $DRY_RUN || cat > "$cfg" << 'CFG_EOF'
{
  "default_agent": "arc",
  "agents_dir": ".opencode/agents"
}
CFG_EOF
    ok "$cfg (Arc as default)"
  fi
}

convert_cursor() {
  local agents_src="$SOURCE/agents"
  [[ ! -d "$agents_src" ]] && return

  $DRY_RUN || mkdir -p ".cursor/rules"

  while IFS= read -r agent_file; do
    local role
    role=$(basename "$(dirname "$agent_file")")
    should_include "$role" || continue
    copy_if_changed "$agent_file" ".cursor/rules/${role}.mdc"
  done < <(find "$agents_src" -name "AGENT.md" | sort)

  # .cursorrules — sets Arc as default
  local cursorrules=".cursorrules"
  if [[ ! -f "$cursorrules" ]] || ! grep -q "You are Arc" "$cursorrules" 2>/dev/null; then
    $DRY_RUN || cat > "$cursorrules" << 'CR_EOF'
You are Arc, the Crux Platform coordinator for this project.
Read $HOME/.crux/skills/crux-arc/SKILL.md at session start.
You are Arc by default — the user does not need to type @arc.
CR_EOF
    ok "$cursorrules (Arc as default)"
  fi
}

convert_windsurf() {
  local agents_src="$SOURCE/agents"
  [[ ! -d "$agents_src" ]] && return

  $DRY_RUN || mkdir -p ".windsurf/rules"

  while IFS= read -r agent_file; do
    local role
    role=$(basename "$(dirname "$agent_file")")
    should_include "$role" || continue
    copy_if_changed "$agent_file" ".windsurf/rules/${role}.md"
  done < <(find "$agents_src" -name "AGENT.md" | sort)

  # .windsurfrules
  local windsurfrules=".windsurfrules"
  if [[ ! -f "$windsurfrules" ]] || ! grep -q "You are Arc" "$windsurfrules" 2>/dev/null; then
    $DRY_RUN || cat > "$windsurfrules" << 'WS_EOF'
You are Arc, the Crux Platform coordinator for this project.
Read $HOME/.crux/skills/crux-arc/SKILL.md at session start.
You are Arc by default — the user does not need to type @arc.
WS_EOF
    ok "$windsurfrules (Arc as default)"
  fi
}

case "$TOOL" in
  claude-code) convert_claude_code ;;
  opencode)    convert_opencode ;;
  cursor)      convert_cursor ;;
  windsurf)    convert_windsurf ;;
  all)
    convert_claude_code
    convert_opencode
    convert_cursor
    convert_windsurf ;;
  *) warn "Unknown tool: $TOOL" ;;
esac

ok "Conversion complete → $TOOL (Arc is default, no @mention needed)"
