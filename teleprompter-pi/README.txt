=====================================================
  TELEPROMPTER — Raspberry Pi Setup Guide
  v3.1
=====================================================

  Organization : The Catholic Archdiocese of Edmonton
  Department   : Communications
  Platform     : Raspberry Pi OS Desktop / Internet Explorer (Surface RT)

  This version:
    ✓ Opens Chromium as a normal maximized window
    ✓ Does NOT use kiosk mode
    ✓ Does NOT start automatically on boot
    ✓ Fullscreen is controlled inside the app itself
    ✓ Open by double-clicking the Desktop icon


=====================================================
  VERSION HISTORY
=====================================================

  v3.1.0  2026-06-17
    - Added dedicated Chromium profile for stability
      (~/.teleprompter-chrome-profile)
    - launch-teleprompter.sh added to automatically
      clear stale Chromium lock files on launch
    - Eliminates "Restore Session" crash prompts
    - uninstall.sh updated to clean up profile

  v3.0.0  2026-06-17
    - Removed kiosk mode entirely; Chromium now
      opens as a normal maximized window
    - Removed autostart on boot — app must be
      opened manually via the Desktop icon
    - install.sh actively removes any leftover
      autostart entry from previous installs
    - Installer reduced from 7 steps to 6 steps
    - uninstall.sh labels legacy autostart entries
      and removes them cleanly
    - README fully rewritten for v3.0 behavior

  v2.1.0  2026-06-17
    - Added TELEPROMPTER_MODE setting (windowed/kiosk)
    - Default changed from --kiosk to --start-maximized
    - Desktop, App Menu, and Autostart all used same mode

  v2.0.0  2026-06-17
    - Desktop launcher ~/Desktop/Teleprompter.desktop
    - App Menu entry ~/.local/share/applications/
    - SVG icon shipped with installer
    - Automatic gio trust-marking
    - Structured 7-step install output

  v1.2.0  2026-06-17
    - Startup splash screen with CAEDM branding
    - Dedicated Exit Fullscreen button added
    - CSS fade with graceful IE fallback

  v1.1.0  2026-06-17
    - Initial Raspberry Pi kiosk installer package
    - Chromium autostart via .desktop entry
    - Mouse cursor hiding via unclutter

  v1.0.0  2026-06-17
    - Initial release — single-file offline teleprompter
    - ES5-compatible (Internet Explorer / Surface RT)
    - Auto-scroll, speed/font controls, mirror mode,
      focus mode, localStorage save/load, fullscreen,
      keyboard shortcuts, touch support


=====================================================
  DEVELOPER / AUTHOR
=====================================================

  Name    : Ruban Peppin
  Role    : Developer, Communications
  Org     : The Catholic Archdiocese of Edmonton

  Email   : ruban.peppin@caedm.ca
            connect@rubangino.ca

  For bug reports, feature requests, or support,
  contact the developer at either email address above.


-----------------------------------------------------
FOLDER CONTENTS
-----------------------------------------------------

  teleprompter.html        The teleprompter web app (v1.2)
  teleprompter-icon.svg    Application icon (dark, burgundy accent)
  install.sh               Raspberry Pi installer (v3.1)
  uninstall.sh             Raspberry Pi uninstaller (v3.1)
  README.txt               This file


-----------------------------------------------------
WHAT THE INSTALLER CREATES
-----------------------------------------------------

  1. ~/teleprompter/
     App files, icon, and script stored here.

  2. ~/Desktop/Teleprompter.desktop
     Desktop icon — double-click to open the app.

  3. ~/.local/share/applications/teleprompter.desktop
     Adds Teleprompter to the Application Menu
     (under Utilities / Office).

  4. ~/teleprompter/launch-teleprompter.sh
     A safe launch script that deletes stale Chromium
     crash locks before opening the app using a
     dedicated profile: ~/.teleprompter-chrome-profile

  The app does NOT start automatically on boot.
  Open it manually by double-clicking the Desktop icon.


-----------------------------------------------------
HOW FULLSCREEN WORKS
-----------------------------------------------------

  This installer does NOT use Chromium's --kiosk flag.
  Chromium opens as a normal maximized window.

  Fullscreen is controlled entirely from inside
  the Teleprompter app using the on-screen buttons:

  ┌─────────────────────────────────────────────────┐
  │  [ ⛶ Full ]   → Enter fullscreen (or press F)  │
  │  [ ✕ Exit FS ] → Exit fullscreen                │
  └─────────────────────────────────────────────────┘

  The user can also press F11 in Chromium at any time
  to toggle the browser's own fullscreen mode.

  Keyboard shortcuts inside the app:
    F       Enter fullscreen
    H       Hide / show controls (focus mode)
    Space   Start / Pause scrolling
    R       Reset to top
    M       Mirror mode


-----------------------------------------------------
STEP 1 — COPY THIS FOLDER TO YOUR RASPBERRY PI
-----------------------------------------------------

Option A: USB drive
  1. Copy the teleprompter-pi folder to a USB drive.
  2. Plug the USB drive into the Raspberry Pi.
  3. Open a terminal and run:

     cp -r /media/pi/YOUR_DRIVE/teleprompter-pi ~/

Option B: SCP over the network (from another computer)
  Replace PI_IP with your Raspberry Pi's IP address:

     scp -r teleprompter-pi pi@PI_IP:~/

Option C: Git clone (if the repo is accessible)
     git clone https://github.com/archedmonton/Teleprompter.git
     cd Teleprompter/teleprompter-pi


-----------------------------------------------------
STEP 2 — MAKE SCRIPTS EXECUTABLE
-----------------------------------------------------

  cd ~/teleprompter-pi
  chmod +x install.sh uninstall.sh


-----------------------------------------------------
STEP 3 — RUN THE INSTALLER
-----------------------------------------------------

  ./install.sh

The installer will print 7 numbered steps:

  [1/7] Create ~/teleprompter/ directory
  [2/7] Copy teleprompter.html
  [3/7] Install SVG icon
  [4/7] Detect / install Chromium
  [5/7] Install unclutter (mouse hider, optional)
  [6/7] Create launcher script
  [7/7] Create Desktop icon + App Menu entry
        Remove any old autostart entries (cleanup)


-----------------------------------------------------
STEP 4 — TRUST THE DESKTOP ICON (if prompted)
-----------------------------------------------------

Raspberry Pi OS Bookworm may show the desktop icon
as untrusted. The installer automatically tries to
trust it using the "gio" tool.

If the icon shows a warning or won't open:

  a) Right-click the Desktop icon.
  b) Choose "Allow Launching" or "Trust this executable".
  c) Double-click to open — it should work now.

This is a one-time step per installation.


-----------------------------------------------------
OPENING THE APP
-----------------------------------------------------

Option A: Double-click the Desktop icon.

Option B: Application Menu → Utilities → Teleprompter

Option C: Terminal command:
  chromium-browser --start-maximized \
    "file://$HOME/teleprompter/teleprompter.html"

  (Use "chromium" instead of "chromium-browser"
   on newer Raspberry Pi OS versions.)

The app does NOT start automatically on boot.


-----------------------------------------------------
USING THE TELEPROMPTER
-----------------------------------------------------

  1. Edit or paste your script in the text editor area.
  2. Press "Load Script into Prompter".
  3. Press Start (or Space) to begin scrolling.
  4. Use the Full button (or F key) to go fullscreen.
  5. Use Exit FS to return to windowed mode.
  6. Press H to hide controls for a clean reading view.
  7. Press R to reset to the top.


-----------------------------------------------------
HOW TO UPDATE TELEPROMPTER.HTML LATER
-----------------------------------------------------

Copy the new file over the existing one:

  cp /path/to/new/teleprompter.html ~/teleprompter/

No reboot required. Close and reopen the app, or
press Ctrl+R in Chromium to refresh.

From another machine via scp:

  scp teleprompter.html pi@PI_IP:~/teleprompter/


-----------------------------------------------------
HOW TO UNINSTALL
-----------------------------------------------------

  cd ~/teleprompter-pi
  ./uninstall.sh

This removes:
  ✓ ~/teleprompter/                           (app + icon)
  ✓ ~/Desktop/Teleprompter.desktop            (desktop icon)
  ✓ ~/.local/share/applications/teleprompter.desktop
  ✓ ~/.teleprompter-chrome-profile            (profile)
  ✓ ~/.config/autostart/teleprompter.desktop  (if present)
  ✓ ~/.config/autostart/unclutter.desktop     (if present)

Chromium is NOT removed.


-----------------------------------------------------
TROUBLESHOOTING
-----------------------------------------------------

Q: The desktop icon does not appear after install.
A: Refresh the desktop (right-click → Refresh) or
   log out and back in.
   Check: ls ~/Desktop/

Q: Double-clicking the icon does nothing.
A: Right-click the icon → "Allow Launching" or
   "Trust this executable". See Step 4 above.

Q: The app opens but exits fullscreen immediately.
A: This is expected — the app is not in kiosk mode.
   Use the Full button or F key inside the app to
   enter fullscreen. Use Exit FS or Esc to leave it.

Q: Chromium shows a "restore session" banner.
A: This should no longer happen in v3.1, as the new
   launch script deletes crash locks automatically.
   Ensure you use the Desktop icon to open the app.

Q: localStorage says "not available".
A: Normal for some Chromium configurations.
   The app works fine; scripts won't persist between
   sessions in that case.

Q: The mouse cursor is distracting.
A: Install unclutter manually:
     sudo apt-get install -y unclutter
   Then run:
     unclutter -idle 2 -root &


-----------------------------------------------------
REQUIREMENTS
-----------------------------------------------------

  Raspberry Pi:
  - Raspberry Pi OS Desktop (Bookworm or Bullseye)
  - Chromium (auto-installed if missing — requires
    internet for that one step only)

  Windows / Surface RT:
  - Open teleprompter.html directly in Internet
    Explorer or any modern browser — no install needed.

=====================================================
  Copyright 2026 Ruban Peppin
  The Catholic Archdiocese of Edmonton, Communications
  ruban.peppin@caedm.ca | connect@rubangino.ca
=====================================================
