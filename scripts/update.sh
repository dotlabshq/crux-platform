#!/usr/bin/env bash
# Crux Platform — update.sh
# Updates framework files from upstream repo
set -euo pipefail

GREEN='\033[0;32m'; CYAN='\033[0;36m'; RESET='\033[0m'
ok()   { echo -e "  ${GREEN}✓${RESET} $*"; }
info() { echo -e "  ${CYAN}→${RESET} $*"; }

FRAMEWORK_HOME="${CRUX_HOME:-$HOME/.crux}"
DRY_RUN=false
AGENTS_ARG=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --agents)  AGENTS_ARG="$2"; shift 2 ;;
    *) shift ;;
  esac
done

info "Updating Crux Platform framework..."
INSTALL_ARGS=("--force")
$DRY_RUN && INSTALL_ARGS+=("--dry-run")
[[ -n "$AGENTS_ARG" ]] && INSTALL_ARGS+=("--agents" "$AGENTS_ARG")

bash "$FRAMEWORK_HOME/scripts/install.sh" "${INSTALL_ARGS[@]}"
ok "Update complete"
