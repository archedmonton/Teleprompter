#!/bin/bash
# =============================================================
#  Teleprompter — Raspberry Pi Uninstaller
#  Removes the teleprompter install and autostart entry.
#  Does NOT remove Chromium.
#  Safe to run even if files do not exist.
# =============================================================

INSTALL_DIR="$HOME/teleprompter"
AUTOSTART_DIR="$HOME/.config/autostart"
DESKTOP_FILE="$AUTOSTART_DIR/teleprompter.desktop"
UNCLUTTER_FILE="$AUTOSTART_DIR/unclutter.desktop"

echo ""
echo "============================================="
echo "  Teleprompter Uninstaller for Raspberry Pi"
echo "============================================="
echo ""

# ── Remove install directory ──────────────────────────────────
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing install directory: $INSTALL_DIR"
    rm -rf "$INSTALL_DIR"
    echo "Done."
else
    echo "Install directory not found (already removed): $INSTALL_DIR"
fi

# ── Remove autostart desktop entry ───────────────────────────
if [ -f "$DESKTOP_FILE" ]; then
    echo "Removing autostart entry: $DESKTOP_FILE"
    rm -f "$DESKTOP_FILE"
    echo "Done."
else
    echo "Autostart entry not found (already removed): $DESKTOP_FILE"
fi

# ── Remove unclutter autostart entry (if it was created by installer) ──
if [ -f "$UNCLUTTER_FILE" ]; then
    echo "Removing unclutter autostart entry: $UNCLUTTER_FILE"
    rm -f "$UNCLUTTER_FILE"
    echo "Done."
fi

echo ""
echo "============================================="
echo "  Uninstall complete."
echo "============================================="
echo ""
echo "  Chromium was NOT removed."
echo "  Reboot to confirm autostart is cleared:"
echo "    sudo reboot"
echo ""
