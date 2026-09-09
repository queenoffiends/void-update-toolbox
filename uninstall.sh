#!/bin/bash
set -euo pipefail

APP_NAME="void-update-toolbox"
BIN_DIR="$HOME/.local/bin"
ICON_DIR="$HOME/.local/share/icons/hicolor/scalable/apps"
DESKTOP_DIR="$HOME/.local/share/applications"

rm -f "$BIN_DIR/$APP_NAME"
rm -f "$ICON_DIR/voidupdatetoolbox.svg"
rm -f "$DESKTOP_DIR/voidupdatetoolbox.desktop"

command -v update-desktop-database >/dev/null 2>&1 \
  && update-desktop-database "$DESKTOP_DIR" >/dev/null 2>&1 || true

echo "==> Removed."
