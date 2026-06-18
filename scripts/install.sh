#!/usr/bin/env bash
# Crux Platform — install.sh
# Downloads and installs the Crux Platform framework to $HOME/.crux
#
# Quick start:
#   curl -fsSL https://raw.githubusercontent.com/{org}/crux-platform/main/scripts/install.sh | bash
#
# With options:
#   curl -fsSL .../install.sh | bash -s -- --tool claude-code --agents coordinator,solution-architect
# =============================================================================
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

ok()   { echo -e "  ${GREEN}✓${RESET} $*"; }
info() { echo -e "  ${CYAN}→${RESET} $*"; }
warn() { echo -e "  ${YELLOW}⚠${RESET} $*"; }
err()  { echo -e "  ${RED}✗${RESET} $*" >&2; }
hdr()  { echo -e "\n${BOLD}${BLUE}$*${RESET}"; }

# Defaults
REPO="your-org/crux-platform"
BRANCH="main"
AGENTS_ARG=""
TOOL="auto"
DRY_RUN=false
FORCE=false
FRAMEWORK_HOME="${CRUX_HOME:-$HOME/.crux}"

REPO_ARCHIVE="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agents)  AGENTS_ARG="$2"; shift 2 ;;
    --tool)    TOOL="$2";       shift 2 ;;
    --branch)  BRANCH="$2";     shift 2
               REPO_ARCHIVE="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz" ;;
    --repo)    REPO="$2";       shift 2
               REPO_ARCHIVE="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz" ;;
    --dry-run) DRY_RUN=true;    shift ;;
    --force)   FORCE=true;      shift ;;
    --help|-h)
      echo "Usage: install.sh [--agents list] [--tool name] [--branch name] [--dry-run] [--force]"
      echo "  --agents    Comma-separated agent IDs (default: all)"
      echo "  --tool      claude-code | opencode | cursor | codex | all (default: auto-detect)"
      exit 0 ;;
    *) err "Unknown option: $1"; exit 1 ;;
  esac
done

echo ""
echo -e "${BOLD}${BLUE}┌─────────────────────────────────────┐${RESET}"
echo -e "${BOLD}${BLUE}│  Crux Platform — installer          │${RESET}"
echo -e "${BOLD}${BLUE}└─────────────────────────────────────┘${RESET}"
echo ""
echo -e "  Framework: ${CYAN}${FRAMEWORK_HOME}${RESET}"
echo -e "  Tool:      ${CYAN}${TOOL}${RESET}"
$DRY_RUN && echo -e "  ${YELLOW}Mode: dry-run${RESET}"

# Prerequisites
hdr "Checking prerequisites..."
DOWNLOADER=""
if command -v curl &>/dev/null; then DOWNLOADER="curl"; ok "curl"
elif command -v wget &>/dev/null; then DOWNLOADER="wget"; ok "wget"
else err "curl or wget required"; exit 1; fi
command -v tar &>/dev/null && ok "tar" || { err "tar required"; exit 1; }

download() {
  if [[ "$DOWNLOADER" == "curl" ]]; then curl -fsSL "$1" -o "$2"
  else wget -qO "$2" "$1"; fi
}

install_file() {
  local src="$1" dest="$2"
  [[ ! -f "$src" ]] && { warn "Not found: ${src#$EXTRACTED/}"; return; }
  if [[ -f "$dest" ]] && ! $FORCE; then
    info "Exists, skipping (--force to overwrite): ${dest#./}"; return
  fi
  $DRY_RUN && { info "[dry-run] would install: ${dest#./}"; return; }
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  ok "${dest#./}"
}

install_tree() {
  local src_root="$1" dest_root="$2"
  [[ ! -d "$src_root" ]] && { warn "Not found: ${src_root#$EXTRACTED/}"; return; }
  while IFS= read -r src_file; do
    local rel="${src_file#$src_root/}"
    install_file "$src_file" "$dest_root/$rel"
  done < <(find "$src_root" -type f | sort)
}

# Download
hdr "Downloading Crux Platform framework..."
TMPDIR_WORK=$(mktemp -d)
trap 'rm -rf "$TMPDIR_WORK"' EXIT
ARCHIVE="$TMPDIR_WORK/crux.tar.gz"
EXTRACTED="$TMPDIR_WORK/extracted"
info "Fetching ${REPO}@${BRANCH}..."
download "$REPO_ARCHIVE" "$ARCHIVE"
mkdir -p "$EXTRACTED"
tar xzf "$ARCHIVE" --strip-components=1 -C "$EXTRACTED"
ok "Downloaded"

# Framework files
hdr "Installing framework files..."
install_file "$EXTRACTED/COORDINATOR.md"  "$FRAMEWORK_HOME/COORDINATOR.md"
install_tree "$EXTRACTED/bus"             "$FRAMEWORK_HOME/bus"
install_tree "$EXTRACTED/scripts"         "$FRAMEWORK_HOME/scripts"
install_tree "$EXTRACTED/templates"       "$FRAMEWORK_HOME/templates"
install_tree "$EXTRACTED/workflows"       "$FRAMEWORK_HOME/workflows"
install_tree "$EXTRACTED/docs"            "$FRAMEWORK_HOME/docs"

# Agents
hdr "Installing agents..."
if [[ -n "$AGENTS_ARG" ]]; then
  IFS=',' read -ra AGENT_LIST <<< "$AGENTS_ARG"
else
  AGENT_LIST=()
  while IFS= read -r role; do AGENT_LIST+=("$role"); done < <(
    find "$EXTRACTED/agents" -name "AGENT.md" 2>/dev/null \
    | while IFS= read -r f; do basename "$(dirname "$f")"; done | sort
  )
fi

for role in "${AGENT_LIST[@]}"; do
  role=$(echo "$role" | xargs)
  src_dir="$EXTRACTED/agents/${role}"
  dest_dir="$FRAMEWORK_HOME/agents/${role}"
  if [[ ! -f "$src_dir/AGENT.md" ]]; then
    warn "Agent not found: ${role}"; continue
  fi
  if [[ -f "$dest_dir/AGENT.md" ]] && ! $FORCE; then
    info "Agent exists, skipping: ${role}"; continue
  fi
  install_tree "$src_dir" "$dest_dir"
done

# Skills
hdr "Installing skills..."
install_tree "$EXTRACTED/skills/crux-coordinator" "$FRAMEWORK_HOME/skills/crux-coordinator"

for role in "${AGENT_LIST[@]}"; do
  agent_file="$FRAMEWORK_HOME/agents/${role}/AGENT.md"
  [[ ! -f "$agent_file" ]] && continue
  while IFS= read -r skill_name; do
    skill_name=$(echo "$skill_name" | xargs)
    src_skill="$EXTRACTED/skills/${skill_name}/SKILL.md"
    dest_skill="$FRAMEWORK_HOME/skills/${skill_name}/SKILL.md"
    [[ ! -f "$src_skill" ]] && continue
    [[ -f "$dest_skill" ]] && ! $FORCE && continue
    install_tree "$EXTRACTED/skills/${skill_name}" "$FRAMEWORK_HOME/skills/${skill_name}"
  done < <(
    awk '/## V. Skills/,/^---/' "$agent_file" \
    | grep '^\| `' | sed 's/.*`\([^`]*\)`.*/\1/'
  )
done

# Project structure
hdr "Creating project structure..."
for d in .crux .crux/docs .crux/summaries .crux/decisions .crux/workspace; do
  $DRY_RUN && info "[dry-run] would create: $d" || mkdir -p "$d"
done
ok "Directories ready"

# Global registry
hdr "Setting up global registry..."
REGISTRY_DIR="$FRAMEWORK_HOME/registry"
if $DRY_RUN; then
  info "[dry-run] would create: $REGISTRY_DIR"
else
  mkdir -p "$REGISTRY_DIR/projects"
  [[ ! -f "$REGISTRY_DIR/projects.md" ]] && cat > "$REGISTRY_DIR/projects.md" << 'REGEOF'
# Crux Project Registry

| Slug | Name | Path | Type | Status | Registered |
|---|---|---|---|---|---|
REGEOF
  [[ ! -f "$REGISTRY_DIR/capabilities.md" ]] && \
    cp "$EXTRACTED/templates/decisions/CAPABILITY-REGISTRY.template.md" \
       "$REGISTRY_DIR/capabilities.md" 2>/dev/null || true
  [[ ! -f "$REGISTRY_DIR/sdk-versions.md" ]] && cat > "$REGISTRY_DIR/sdk-versions.md" << 'REGEOF'
# SDK Version Registry

REGEOF
  ok "Registry initialized at $REGISTRY_DIR"
fi

# AGENTS.md bootstrap
hdr "Updating project AGENTS.md..."
MARKER="Crux Project Bootstrap"
AGENTS_FILE="AGENTS.md"
if [[ -f "$AGENTS_FILE" ]] && grep -q "$MARKER" "$AGENTS_FILE" 2>/dev/null; then
  info "AGENTS.md already has Crux bootstrap"
elif $DRY_RUN; then
  info "[dry-run] would update AGENTS.md"
else
  CONTENT="# Crux Project Bootstrap

Before interpreting project state, routing work, or loading agents, read:

  \`{framework-home}/skills/crux-coordinator/SKILL.md\`

Default \`{framework-home}\` is \`\$HOME/.crux\` unless \`CRUX_HOME\` is set."
  if [[ -f "$AGENTS_FILE" ]]; then
    tmp=$(mktemp)
    { printf '%s\n\n---\n\n' "$CONTENT"; cat "$AGENTS_FILE"; } > "$tmp"
    mv "$tmp" "$AGENTS_FILE"
    ok "AGENTS.md (prepended bootstrap)"
  else
    printf '%s\n' "$CONTENT" > "$AGENTS_FILE"
    ok "AGENTS.md created"
  fi
fi

# .gitignore
hdr "Updating .gitignore..."
if [[ -f ".gitignore" ]]; then
  grep -qxF ".crux/workspace/" ".gitignore" 2>/dev/null \
    && info "Already in .gitignore: .crux/workspace/" \
    || { $DRY_RUN || echo ".crux/workspace/" >> ".gitignore"; ok "Added .crux/workspace/ to .gitignore"; }
else
  $DRY_RUN || echo ".crux/workspace/" > ".gitignore"
  ok "Created .gitignore"
fi

# Convert
hdr "Converting agent definitions..."
CONVERT_SCRIPT="$FRAMEWORK_HOME/scripts/convert.sh"
if [[ -f "$CONVERT_SCRIPT" ]]; then
  chmod +x "$CONVERT_SCRIPT"
  CONVERT_ARGS=("--tool" "$TOOL" "--source" "$FRAMEWORK_HOME")
  $DRY_RUN && CONVERT_ARGS+=("--dry-run")
  "$CONVERT_SCRIPT" "${CONVERT_ARGS[@]}"
else
  warn "convert.sh not found — run it manually after install"
fi

# Done
echo ""
echo -e "${BOLD}${GREEN}┌─────────────────────────────────────────────┐${RESET}"
echo -e "${BOLD}${GREEN}│  Crux Platform installed successfully       │${RESET}"
echo -e "${BOLD}${GREEN}└─────────────────────────────────────────────┘${RESET}"
echo ""
echo -e "  ${BOLD}Next steps:${RESET}"
echo ""
echo -e "  1. Start your AI tool in this project directory"
echo -e "  2. The coordinator will run workspace initialization on first boot"
echo -e "  3. Answer 3 questions — coordinator handles everything else"
echo ""
echo -e "  ${BOLD}Available agents:${RESET}"
for role in "${AGENT_LIST[@]:0:8}"; do echo -e "    ${CYAN}@${role}${RESET}"; done
[[ ${#AGENT_LIST[@]} -gt 8 ]] && echo -e "    ${CYAN}... and ${#AGENT_LIST[@]} total${RESET}"
echo ""
echo -e "  ${BOLD}Update framework:${RESET}"
echo -e "    ${CYAN}$FRAMEWORK_HOME/scripts/update.sh${RESET}"
echo ""
