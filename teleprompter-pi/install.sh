#!/bin/bash
# =============================================================
#  Teleprompter — Raspberry Pi Installer  v2.0
#  The Catholic Archdiocese of Edmonton — Communications
#  Author : Ruban Peppin <ruban.peppin@caedm.ca>
#
#  What this script does:
#    1. Creates ~/teleprompter/ and copies the app file
#    2. Copies the SVG icon into ~/teleprompter/
#    3. Detects / installs Chromium
#    4. Installs unclutter (mouse cursor hider) if possible
#    5. Creates a Desktop launcher   ~/Desktop/Teleprompter.desktop
#    6. Creates an App Menu entry    ~/.local/share/applications/teleprompter.desktop
#    7. Creates an Autostart entry   ~/.config/autostart/teleprompter.desktop
#
#  Safe to re-run multiple times.
# =============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="$HOME/teleprompter"
HTML_FILE="$INSTALL_DIR/teleprompter.html"
ICON_FILE="$INSTALL_DIR/teleprompter-icon.svg"
FILE_URL="file://$HTML_FILE"

AUTOSTART_DIR="$HOME/.config/autostart"
APPMENU_DIR="$HOME/.local/share/applications"
DESKTOP_DIR="$HOME/Desktop"

AUTOSTART_FILE="$AUTOSTART_DIR/teleprompter.desktop"
APPMENU_FILE="$APPMENU_DIR/teleprompter.desktop"
DESKTOP_SHORTCUT="$DESKTOP_DIR/Teleprompter.desktop"

echo ""
echo "============================================="
echo "  Teleprompter Installer for Raspberry Pi"
echo "  The Catholic Archdiocese of Edmonton"
echo "============================================="
echo ""

# ── STEP 1: Create install directory ─────────────────────────
echo "[1/7] Creating install directory: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# ── STEP 2: Copy teleprompter.html ───────────────────────────
echo "[2/7] Copying teleprompter.html..."
if [ -f "$SCRIPT_DIR/teleprompter.html" ]; then
    cp "$SCRIPT_DIR/teleprompter.html" "$HTML_FILE"
    echo "      Copied to $HTML_FILE"
else
    echo "      WARNING: teleprompter.html not found in $SCRIPT_DIR"
    echo "      Please copy it manually to $HTML_FILE"
fi

# ── STEP 3: Copy / create SVG icon ───────────────────────────
echo "[3/7] Installing application icon..."
if [ -f "$SCRIPT_DIR/teleprompter-icon.svg" ]; then
    cp "$SCRIPT_DIR/teleprompter-icon.svg" "$ICON_FILE"
    echo "      Copied icon from $SCRIPT_DIR/teleprompter-icon.svg"
else
    # Write the embedded SVG icon directly
    cat > "$ICON_FILE" << 'SVG_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" width="64" height="64">
  <!-- Background -->
  <rect width="64" height="64" rx="10" fill="#0a0a0a"/>
  <!-- Screen rectangle -->
  <rect x="8" y="10" width="48" height="34" rx="4" fill="#1a1a1a" stroke="#860038" stroke-width="2"/>
  <!-- Burgundy accent bar -->
  <rect x="8" y="10" width="48" height="5" rx="4" fill="#860038"/>
  <!-- Text lines (representing script) -->
  <rect x="13" y="21" width="32" height="3" rx="1.5" fill="#ffffff" opacity="0.9"/>
  <rect x="13" y="28" width="38" height="3" rx="1.5" fill="#ffffff" opacity="0.65"/>
  <rect x="13" y="35" width="28" height="3" rx="1.5" fill="#ffffff" opacity="0.4"/>
  <!-- Stand stem -->
  <rect x="29" y="44" width="6" height="8" rx="2" fill="#333"/>
  <!-- Stand base -->
  <rect x="20" y="52" width="24" height="4" rx="2" fill="#444"/>
</svg>
SVG_EOF
    echo "      Created embedded SVG icon at $ICON_FILE"
fi

# ── STEP 4: Detect / install Chromium ────────────────────────
echo "[4/7] Checking for Chromium..."
CHROMIUM_CMD=""

if command -v chromium-browser > /dev/null 2>&1; then
    CHROMIUM_CMD="chromium-browser"
    echo "      Found: chromium-browser"
elif command -v chromium > /dev/null 2>&1; then
    CHROMIUM_CMD="chromium"
    echo "      Found: chromium"
else
    echo "      Chromium not found. Installing via apt..."
    sudo apt-get update -y
    sudo apt-get install -y chromium-browser
    if command -v chromium-browser > /dev/null 2>&1; then
        CHROMIUM_CMD="chromium-browser"
    elif command -v chromium > /dev/null 2>&1; then
        CHROMIUM_CMD="chromium"
    else
        echo "      ERROR: Could not install Chromium. Please install it manually."
        exit 1
    fi
    echo "      Installed: $CHROMIUM_CMD"
fi

# ── STEP 5: Install unclutter (mouse cursor hider) ───────────
echo "[5/7] Checking for unclutter..."
if command -v unclutter > /dev/null 2>&1; then
    echo "      unclutter already installed."
else
    sudo apt-get install -y unclutter 2>/dev/null && \
        echo "      Installed unclutter." || \
        echo "      Could not install unclutter — mouse cursor remains visible (non-fatal)."
fi

# ── Helper: build the kiosk Exec line ────────────────────────
KIOSK_EXEC="$CHROMIUM_CMD --kiosk --disable-infobars --noerrdialogs --disable-session-crashed-bubble --check-for-update-interval=31536000 \"$FILE_URL\""

# ── STEP 6: Create Desktop launcher ──────────────────────────
echo "[6/7] Creating Desktop launcher..."
mkdir -p "$DESKTOP_DIR"

cat > "$DESKTOP_SHORTCUT" << DESK_EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Teleprompter
GenericName=Teleprompter
Comment=CAEDM Teleprompter — open in fullscreen kiosk mode
Exec=bash -c '$KIOSK_EXEC'
Icon=$ICON_FILE
Terminal=false
Categories=Utility;Office;
StartupNotify=false
DESK_EOF

chmod +x "$DESKTOP_SHORTCUT"

# Raspberry Pi OS Bookworm requires the file to be trusted
# Attempt to mark it trusted using gio (GNOME / LXDE)
if command -v gio > /dev/null 2>&1; then
    gio set "$DESKTOP_SHORTCUT" metadata::trusted true 2>/dev/null && \
        echo "      Marked as trusted via gio." || \
        echo "      Note: right-click the desktop icon and choose 'Allow Launching' if needed."
else
    echo "      Note: right-click the desktop icon and choose 'Allow Launching' if prompted."
fi

echo "      Desktop shortcut: $DESKTOP_SHORTCUT"

# ── STEP 7a: Create App Menu entry ───────────────────────────
echo "[7/7] Creating App Menu and Autostart entries..."
mkdir -p "$APPMENU_DIR"

cat > "$APPMENU_FILE" << APPMENU_EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Teleprompter
GenericName=Teleprompter
Comment=CAEDM Teleprompter — fullscreen kiosk mode
Exec=bash -c '$KIOSK_EXEC'
Icon=$ICON_FILE
Terminal=false
Categories=Utility;Office;
StartupNotify=false
APPMENU_EOF

chmod +x "$APPMENU_FILE"
echo "      App Menu entry : $APPMENU_FILE"

# ── STEP 7b: Create Autostart entry ──────────────────────────
mkdir -p "$AUTOSTART_DIR"

cat > "$AUTOSTART_FILE" << AUTO_EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Teleprompter (Autostart)
Comment=CAEDM Teleprompter — launches automatically on boot
Exec=bash -c 'sleep 5 && $KIOSK_EXEC'
Icon=$ICON_FILE
Terminal=false
X-GNOME-Autostart-enabled=true
StartupNotify=false
AUTO_EOF

chmod +x "$AUTOSTART_FILE"
echo "      Autostart entry: $AUTOSTART_FILE"

# ── Unclutter autostart ───────────────────────────────────────
if command -v unclutter > /dev/null 2>&1; then
    UNCLUTTER_FILE="$AUTOSTART_DIR/unclutter.desktop"
    cat > "$UNCLUTTER_FILE" << UNCLUTTER_EOF
[Desktop Entry]
Type=Application
Name=Unclutter
Comment=Hide mouse cursor when idle
Exec=unclutter -idle 1 -root
X-GNOME-Autostart-enabled=true
UNCLUTTER_EOF
    chmod +x "$UNCLUTTER_FILE"
    echo "      Unclutter autostart: $UNCLUTTER_FILE"
fi

# ── Update desktop icon cache ─────────────────────────────────
if command -v update-desktop-database > /dev/null 2>&1; then
    update-desktop-database "$APPMENU_DIR" 2>/dev/null || true
fi

# ── Summary ───────────────────────────────────────────────────
echo ""
echo "============================================="
echo "  Installation complete!"
echo "============================================="
echo ""
echo "  App files       : $INSTALL_DIR"
echo "  Desktop icon    : $DESKTOP_SHORTCUT"
echo "  App Menu entry  : $APPMENU_FILE"
echo "  Autostart entry : $AUTOSTART_FILE"
echo "  Chromium cmd    : $CHROMIUM_CMD"
echo ""
echo "  ► Double-click the desktop icon to launch."
echo "  ► If prompted, choose 'Allow Launching'."
echo "  ► Autostart is ENABLED — app opens on boot."
echo ""
echo "  To disable autostart without uninstalling:"
echo "    rm \"$AUTOSTART_FILE\""
echo ""
echo "  To apply autostart, REBOOT:"
echo "    sudo reboot"
echo ""
