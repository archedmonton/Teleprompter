#!/bin/bash
# =============================================================
#  Teleprompter — Raspberry Pi Installer  v3.2
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
#    7. Removes any leftover autostart entry from older installs
#
#  Chromium launches as a normal maximized window — NOT kiosk mode.
#  The app does NOT start automatically on boot.
#  To open: double-click the Desktop icon.
#
#  Safe to re-run multiple times.
# =============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="$HOME/teleprompter"
HTML_FILE="$INSTALL_DIR/teleprompter.html"
ICON_FILE="$INSTALL_DIR/teleprompter-icon.svg"
FILE_URL="file://$HTML_FILE"
LAUNCHER_SCRIPT="$INSTALL_DIR/launch-teleprompter.sh"

AUTOSTART_DIR="$HOME/.config/autostart"
APPMENU_DIR="$HOME/.local/share/applications"
DESKTOP_DIR="$HOME/Desktop"

AUTOSTART_FILE="$AUTOSTART_DIR/teleprompter.desktop"
APPMENU_FILE="$APPMENU_DIR/teleprompter.desktop"
DESKTOP_SHORTCUT="$DESKTOP_DIR/Teleprompter.desktop"

# Chromium flags — maximized window, no banners, no crash dialogs
CHROMIUM_FLAGS="--start-maximized --disable-infobars --noerrdialogs --disable-session-crashed-bubble"

echo ""
echo "============================================="
echo "  Teleprompter Installer for Raspberry Pi"
echo "  The Catholic Archdiocese of Edmonton"
echo "  v3.2 — standalone app mode, robust relaunch"
echo "============================================="
echo ""

# ── STEP 1: Create install directory ─────────────────────────
echo "[1/6] Creating install directory: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# ── STEP 2: Copy teleprompter.html ───────────────────────────
echo "[2/6] Copying teleprompter.html..."
if [ -f "$SCRIPT_DIR/teleprompter.html" ]; then
    cp "$SCRIPT_DIR/teleprompter.html" "$HTML_FILE"
    echo "      Copied to $HTML_FILE"
else
    echo "      WARNING: teleprompter.html not found in $SCRIPT_DIR"
    echo "      Please copy it manually to $HTML_FILE"
fi

# ── STEP 3: Copy / create SVG icon ───────────────────────────
echo "[3/6] Installing application icon..."
if [ -f "$SCRIPT_DIR/teleprompter-icon.svg" ]; then
    cp "$SCRIPT_DIR/teleprompter-icon.svg" "$ICON_FILE"
    echo "      Copied icon from $SCRIPT_DIR/teleprompter-icon.svg"
else
    # Write the embedded fallback SVG icon
    cat > "$ICON_FILE" << 'SVG_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" width="64" height="64">
  <rect width="64" height="64" rx="10" fill="#0a0a0a"/>
  <rect x="8" y="10" width="48" height="34" rx="4" fill="#1a1a1a" stroke="#860038" stroke-width="2"/>
  <rect x="8" y="10" width="48" height="6" rx="4" fill="#860038"/>
  <rect x="13" y="22" width="34" height="3" rx="1.5" fill="#ffffff" opacity="0.95"/>
  <rect x="13" y="29" width="38" height="3" rx="1.5" fill="#ffffff" opacity="0.65"/>
  <rect x="13" y="36" width="26" height="3" rx="1.5" fill="#ffffff" opacity="0.38"/>
  <rect x="29" y="44" width="6" height="8" rx="2" fill="#2a2a2a"/>
  <rect x="19" y="52" width="26" height="4" rx="2" fill="#3a3a3a"/>
</svg>
SVG_EOF
    echo "      Created embedded SVG icon at $ICON_FILE"
fi

# ── STEP 4: Detect / install Chromium ────────────────────────
echo "[4/6] Checking for Chromium..."
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
echo "[5/6] Checking for unclutter..."
if command -v unclutter > /dev/null 2>&1; then
    echo "      unclutter already installed."
else
    sudo apt-get install -y unclutter 2>/dev/null && \
        echo "      Installed unclutter." || \
        echo "      Could not install unclutter — mouse cursor remains visible (non-fatal)."
fi

# ── STEP 6: Create Launcher Script ───────────────────────────
echo "[6/7] Creating launcher script..."

cat > "$LAUNCHER_SCRIPT" << LAUNCH_EOF
#!/bin/bash

PROFILE_DIR="\$HOME/.teleprompter-chrome-profile"

# Kill any lingering Teleprompter Chromium processes to ensure clean launch
pkill -f "\.teleprompter-chrome-profile" 2>/dev/null || true

# Clean stale lock files to prevent "Restore Session" crash prompts
rm -f "\$PROFILE_DIR/SingletonLock"
rm -f "\$PROFILE_DIR/SingletonSocket"
rm -f "\$PROFILE_DIR/SingletonCookie"
rm -f "\$PROFILE_DIR/Default/Preferences.lock"

# Launch Chromium cleanly in app mode
exec "$CHROMIUM_CMD" \\
  --user-data-dir="\$PROFILE_DIR" \\
  --start-maximized \\
  --no-first-run \\
  --disable-session-crashed-bubble \\
  --disable-infobars \\
  --noerrdialogs \\
  --disable-restore-session-state \\
  --app="$FILE_URL"
LAUNCH_EOF

chmod +x "$LAUNCHER_SCRIPT"
echo "      Created: $LAUNCHER_SCRIPT"

# ── STEP 7a: Create Desktop launcher ─────────────────────────
echo "[7/7] Creating Desktop launcher and App Menu entry..."
mkdir -p "$DESKTOP_DIR"

cat > "$DESKTOP_SHORTCUT" << DESK_EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Teleprompter
GenericName=Teleprompter
Comment=Offline Teleprompter
Exec=/bin/bash -lc '$LAUNCHER_SCRIPT'
Icon=$ICON_FILE
Terminal=false
Categories=Office;Utility;
StartupNotify=true
DESK_EOF

chmod +x "$DESKTOP_SHORTCUT"

# Attempt to mark trusted (Raspberry Pi OS Bookworm)
if command -v gio > /dev/null 2>&1; then
    gio set "$DESKTOP_SHORTCUT" metadata::trusted true 2>/dev/null && \
        echo "      Desktop icon marked as trusted via gio." || \
        echo "      Note: right-click the desktop icon and choose 'Allow Launching' if needed."
else
    echo "      Note: right-click the desktop icon and choose 'Allow Launching' if prompted."
fi

echo "      Desktop shortcut : $DESKTOP_SHORTCUT"

# ── STEP 7b: Create App Menu entry ───────────────────────────
mkdir -p "$APPMENU_DIR"

cat > "$APPMENU_FILE" << APPMENU_EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Teleprompter
GenericName=Teleprompter
Comment=Offline Teleprompter
Exec=/bin/bash -lc '$LAUNCHER_SCRIPT'
Icon=$ICON_FILE
Terminal=false
Categories=Office;Utility;
StartupNotify=true
APPMENU_EOF

chmod +x "$APPMENU_FILE"
echo "      App Menu entry   : $APPMENU_FILE"

# ── STEP 7c: Remove any leftover autostart entry ──────────────
if [ -f "$AUTOSTART_FILE" ]; then
    rm -f "$AUTOSTART_FILE"
    echo "      Removed old autostart entry: $AUTOSTART_FILE"
else
    echo "      No leftover autostart entry found (good)."
fi

# Also remove old unclutter autostart if present
UNCLUTTER_AUTOSTART="$AUTOSTART_DIR/unclutter.desktop"
if [ -f "$UNCLUTTER_AUTOSTART" ]; then
    rm -f "$UNCLUTTER_AUTOSTART"
    echo "      Removed old unclutter autostart entry."
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
echo "  App files      : $INSTALL_DIR"
echo "  Desktop icon   : $DESKTOP_SHORTCUT"
echo "  App Menu entry : $APPMENU_FILE"
echo "  Chromium cmd   : $CHROMIUM_CMD"
echo "  Launch mode    : Standalone App Window (--app)"
echo "  Autostart      : DISABLED"
echo ""
echo "  ► Double-click the Desktop icon to open."
echo "  ► If prompted, choose 'Allow Launching'."
echo "  ► The app does NOT open automatically on boot."
echo ""
echo "  To update the teleprompter later, copy a new"
echo "  teleprompter.html to:"
echo "    $HTML_FILE"
echo "  (No reboot or reinstall needed.)"
echo ""
