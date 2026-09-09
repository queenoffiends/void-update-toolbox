#!/bin/bash
# Installs Void Update Toolbox for the current user (no root required for
# the app itself — only for the one-time dependency install, if needed).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_NAME="void-update-toolbox"

BIN_DIR="$HOME/.local/bin"
ICON_DIR="$HOME/.local/share/icons/hicolor/scalable/apps"
DESKTOP_DIR="$HOME/.local/share/applications"

echo "==> Checking dependencies..."
MISSING=()
command -v python3 >/dev/null 2>&1 || MISSING+=(python3)
python3 -c "import tkinter" >/dev/null 2>&1 || MISSING+=(python3-tkinter)
command -v pkexec >/dev/null 2>&1 || MISSING+=(polkit)

if [ "${#MISSING[@]}" -ne 0 ]; then
  echo "    Missing: ${MISSING[*]}"
  read -rp "    Install now with xbps-install (needs sudo)? [y/N] " ans
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    sudo xbps-install -S "${MISSING[@]}"
  else
    echo "    Skipping. Install manually later with:"
    echo "        sudo xbps-install -S ${MISSING[*]}"
  fi
else
  echo "    All good."
fi

echo "==> Installing files..."
mkdir -p "$BIN_DIR" "$ICON_DIR" "$DESKTOP_DIR"

install -m 755 "$SCRIPT_DIR/$APP_NAME" "$BIN_DIR/$APP_NAME"
install -m 644 "$SCRIPT_DIR/icons/voidupdatetoolbox.svg" "$ICON_DIR/voidupdatetoolbox.svg"
sed "s|__EXEC_PATH__|$BIN_DIR/$APP_NAME|" \
  "$SCRIPT_DIR/voidupdatetoolbox.desktop" > "$DESKTOP_DIR/voidupdatetoolbox.desktop"
chmod 644 "$DESKTOP_DIR/voidupdatetoolbox.desktop"

command -v update-desktop-database >/dev/null 2>&1 \
  && update-desktop-database "$DESKTOP_DIR" >/dev/null 2>&1 || true
command -v gtk-update-icon-cache >/dev/null 2>&1 \
  && gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" >/dev/null 2>&1 || true

echo
case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *)
    echo "Note: $BIN_DIR is not on your PATH yet. Add this to your shell rc"
    echo "(~/.bashrc, ~/.zshrc, etc.) and restart your shell:"
    echo
    echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo
    ;;
esac

echo "==> Installed. Launch it from your app menu, or run: $APP_NAME"
