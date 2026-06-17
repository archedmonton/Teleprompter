#!/bin/bash
# =============================================================
#  Teleprompter — Raspberry Pi Installer
#  Tested on Raspberry Pi OS Desktop (Bookworm / Bullseye)
#  Safe to re-run multiple times.
# =============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="$HOME/teleprompter"
AUTOSTART_DIR="$HOME/.config/autostart"
DESKTOP_FILE="$AUTOSTART_DIR/teleprompter.desktop"
HTML_FILE="$INSTALL_DIR/teleprompter.html"
FILE_URL="file://$HTML_FILE"

echo ""
echo "============================================="
echo "  Teleprompter Installer for Raspberry Pi"
echo "============================================="
echo ""

# ── 1. Create install directory ───────────────────────────────
echo "[1/5] Creating install directory: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# ── 2. Copy teleprompter.html ─────────────────────────────────
echo "[2/5] Copying teleprompter.html..."
if [ -f "$SCRIPT_DIR/teleprompter.html" ]; then
    cp "$SCRIPT_DIR/teleprompter.html" "$HTML_FILE"
    echo "      Copied from $SCRIPT_DIR/teleprompter.html"
else
    echo "      WARNING: teleprompter.html not found in $SCRIPT_DIR"
    echo "      Please copy it manually to $HTML_FILE"
fi

# ── 3. Install Chromium if missing ────────────────────────────
echo "[3/5] Checking for Chromium..."
CHROMIUM_CMD=""

if command -v chromium-browser >/dev/null 2>&1; then
    CHROMIUM_CMD="chromium-browser"
    echo "      Found: chromium-browser"
elif command -v chromium >/dev/null 2>&1; then
    CHROMIUM_CMD="chromium"
    echo "      Found: chromium"
else
    echo "      Chromium not found. Installing chromium-browser via apt..."
    sudo apt-get update -y
    sudo apt-get install -y chromium-browser
    if command -v chromium-browser >/dev/null 2>&1; then
        CHROMIUM_CMD="chromium-browser"
    elif command -v chromium >/dev/null 2>&1; then
        CHROMIUM_CMD="chromium"
    else
        echo "      ERROR: Could not install Chromium. Please install it manually."
        exit 1
    fi
    echo "      Installed: $CHROMIUM_CMD"
fi

# ── 4. Hide mouse cursor (optional, graceful) ─────────────────
echo "[4/5] Checking for unclutter (mouse-hide utility)..."
if command -v unclutter >/dev/null 2>&1; then
    echo "      unclutter is already installed."
else
    echo "      unclutter not found. Attempting to install..."
    sudo apt-get install -y unclutter 2>/dev/null && \
        echo "      Installed unclutter." || \
        echo "      Could not install unclutter — mouse cursor will remain visible (non-fatal)."
fi

# ── 5. Create autostart desktop entry ────────────────────────
echo "[5/5] Creating autostart entry..."
mkdir -p "$AUTOSTART_DIR"

cat > "$DESKTOP_FILE" << DESKTOP_EOF
[Desktop Entry]
Type=Application
Name=Teleprompter
Comment=Fullscreen teleprompter kiosk
Exec=bash -c 'sleep 5 && $CHROMIUM_CMD --kiosk --noerrdialogs --disable-infobars --disable-session-crashed-bubble --disable-restore-session-state --no-first-run --start-fullscreen "file://$HTML_FILE"'
X-GNOME-Autostart-enabled=true
DESKTOP_EOF

# Also add unclutter to autostart if available
if command -v unclutter >/dev/null 2>&1; then
    UNCLUTTER_FILE="$AUTOSTART_DIR/unclutter.desktop"
    cat > "$UNCLUTTER_FILE" << UNCLUTTER_EOF
[Desktop Entry]
Type=Application
Name=Unclutter
Comment=Hide mouse cursor when idle
Exec=unclutter -idle 1 -root
X-GNOME-Autostart-enabled=true
UNCLUTTER_EOF
    echo "      Created unclutter autostart entry."
fi

echo ""
echo "============================================="
echo "  Installation complete!"
echo "============================================="
echo ""
echo "  Teleprompter installed to : $INSTALL_DIR"
echo "  Autostart entry created   : $DESKTOP_FILE"
echo "  Chromium command used     : $CHROMIUM_CMD"
echo ""
echo "  To apply changes, REBOOT the Raspberry Pi:"
echo "    sudo reboot"
echo ""
echo "  To update the teleprompter later, copy a new"
echo "  teleprompter.html to:"
echo "    $HTML_FILE"
echo "  (No reboot needed — just refresh Chromium.)"
echo ""
