#!/usr/bin/env bash
set -euo pipefail

# ── Colors ──────────────────────────────────────────────────────────

BOLD="\033[1m"
RESET="\033[0m"
DIM="\033[2m"
RED="\033[31m"
GREEN="\033[32m"
CORAL="\033[38;2;224;128;96m"

info()  { printf "  ${BOLD}${CORAL}%s${RESET} %s\n" "$1" "$2"; }
ok()    { printf "  ${GREEN}installed${RESET} %s\n" "$1"; }
err()   { printf "  ${RED}%s${RESET} %s\n" "$1" "$2" >&2; }

# ── Config ──────────────────────────────────────────────────────────

OPENCODE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
THEMES_DIR="$OPENCODE_DIR/themes"
REPO="ember-theme/opencode"
BRANCH="main"
THEMES=(ember.json ember-soft.json ember-light.json ember-lighter.json)

# ── Locate opencode config ──────────────────────────────────────────

if [ ! -d "$OPENCODE_DIR" ]; then
    err "error" "opencode config not found at $OPENCODE_DIR"
    echo ""
    echo "  Download opencode from https://opencode.ai"
    exit 1
fi

mkdir -p "$THEMES_DIR"

# ── Install themes ──────────────────────────────────────────────────

echo ""
info "opencode" "$OPENCODE_DIR"
echo ""

installed=0
for name in "${THEMES[@]}"; do
    url="https://raw.githubusercontent.com/$REPO/$BRANCH/$name"
    if curl -fsSL "$url" -o "$THEMES_DIR/$name" 2>/dev/null; then
        ok "$name"
        installed=$((installed + 1))
    else
        err "skip" "$name (download failed)"
    fi
done

echo ""
if [ "$installed" -eq 0 ]; then
    err "error" "no themes could be downloaded"
    exit 1
fi

ok "done" "$installed themes installed to $THEMES_DIR"
echo ""
printf "  Set your theme in ~/.config/opencode/tui.json:\n"
printf "  ${DIM}{\"theme\": \"ember\"}${RESET}\n"
echo ""
