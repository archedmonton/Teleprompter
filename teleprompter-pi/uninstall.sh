#!/bin/bash
# =============================================================
#  Teleprompter — Raspberry Pi Uninstaller  v2.0
#  The Catholic Archdiocese of Edmonton — Communications
#  Author : Ruban Peppin <ruban.peppin@caedm.ca>
#
#  Removes ALL files created by install.sh:
#    - ~/teleprompter/              (app files + icon)
#    - ~/.config/autostart/teleprompter.desktop
#    - ~/.config/autostart/unclutter.desktop
#    - ~/Desktop/Teleprompter.desktop
#    - ~/.local/share/applications/teleprompter.desktop
#
#  Does NOT remove Chromium.
#  Safe to run even if files do not exist.
# =============================================================

INSTALL_DIR="$HOME/teleprompter"
AUTOSTART_FILE="$HOME/.config/autostart/teleprompter.desktop"
UNCLUTTER_FILE="$HOME/.config/autostart/unclutter.desktop"
DESKTOP_SHORTCUT="$HOME/Desktop/Teleprompter.desktop"
APPMENU_FILE="$HOME/.local/share/applications/teleprompter.desktop"

echo ""
echo "============================================="
echo "  Teleprompter Uninstaller for Raspberry Pi"
echo "  The Catholic Archdiocese of Edmonton"
echo "============================================="
echo ""

# Helper function
remove_item() {
    local label="$1"
    local path="$2"
    if [ -e "$path" ]; then
        rm -rf "$path"
        echo "  [removed] $label"
        echo "            $path"
    else
        echo "  [skipped] $label — not found"
        echo "            $path"
    fi
}

remove_item "Install directory"         "$INSTALL_DIR"
remove_item "Autostart entry"           "$AUTOSTART_FILE"
remove_item "Unclutter autostart"       "$UNCLUTTER_FILE"
remove_item "Desktop shortcut"          "$DESKTOP_SHORTCUT"
remove_item "App Menu entry"            "$APPMENU_FILE"

# Refresh app menu icon cache
if command -v update-desktop-database > /dev/null 2>&1; then
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
fi

echo ""
echo "============================================="
echo "  Uninstall complete."
echo "============================================="
echo ""
echo "  Chromium was NOT removed."
echo ""
echo "  Reboot to confirm autostart is cleared:"
echo "    sudo reboot"
echo ""
