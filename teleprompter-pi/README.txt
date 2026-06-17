=====================================================
  TELEPROMPTER — Raspberry Pi Kiosk Setup Guide
  v2.0
=====================================================

  Organization : The Catholic Archdiocese of Edmonton
  Department   : Communications
  Platform     : Raspberry Pi OS Desktop / Internet Explorer (Surface RT)


=====================================================
  VERSION HISTORY
=====================================================

  v2.0.0  2026-06-17
    - Desktop launcher created at ~/Desktop/Teleprompter.desktop
    - App Menu entry created at ~/.local/share/applications/
    - SVG icon shipped with installer (teleprompter-icon.svg)
    - Icon embedded as fallback directly in install.sh
    - Automatic gio trust-marking for Bookworm compatibility
    - Structured 7-step install output with clear labels
    - Autostart, Desktop, and App Menu all use same kiosk flags
    - Uninstaller updated to remove all four shortcut locations
    - Kiosk flag added: --check-for-update-interval=31536000
    - README fully rewritten to match v2.0 workflow

  v1.2.0  2026-06-17
    - Added startup splash screen with CAEDM branding
      (burgundy #860038, 2.5 s auto-dismiss, Skip button,
      CSS fade with graceful IE fallback)
    - Added dedicated "Exit Fullscreen" button to top bar
      (all vendor prefixes: exitFullscreen, msExitFullscreen,
      webkitExitFullscreen, mozCancelFullScreen)
    - "Fullscreen is not active" status message on misfire

  v1.1.0  2026-06-17
    - Added Raspberry Pi kiosk installer package
    - Chromium autostart via .desktop entry
    - Mouse cursor hiding via unclutter
    - Supports both chromium and chromium-browser commands

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

  This project was designed and developed by
  Ruban Peppin for internal use by the Communications
  department of the Catholic Archdiocese of Edmonton.

  For bug reports, feature requests, or support,
  contact the developer at either email address above.


-----------------------------------------------------
FOLDER CONTENTS
-----------------------------------------------------

  teleprompter.html        The teleprompter web app (v1.2)
  teleprompter-icon.svg    Application icon (dark, burgundy accent)
  install.sh               Raspberry Pi installer (v2.0)
  uninstall.sh             Raspberry Pi uninstaller (v2.0)
  README.txt               This file


-----------------------------------------------------
WHAT THE INSTALLER CREATES
-----------------------------------------------------

  After running install.sh, three shortcuts are made:

  1. Desktop launcher
     ~/Desktop/Teleprompter.desktop
     Double-click this icon to open the teleprompter
     in a fullscreen Chromium kiosk window at any time.

  2. Application Menu entry
     ~/.local/share/applications/teleprompter.desktop
     The Teleprompter appears in the Raspberry Pi
     application menu under Utilities / Office.

  3. Autostart entry  (runs on every boot/login)
     ~/.config/autostart/teleprompter.desktop
     Chromium launches automatically 5 seconds after
     the desktop finishes loading.

  All three shortcuts share the same kiosk flags:
    --kiosk
    --disable-infobars
    --noerrdialogs
    --disable-session-crashed-bubble
    --check-for-update-interval=31536000


-----------------------------------------------------
STEP 1 — COPY THIS FOLDER TO YOUR RASPBERRY PI
-----------------------------------------------------

Option A: USB drive
  1. Copy the entire teleprompter-pi folder to a USB
     drive on your Windows computer.
  2. Plug the USB drive into the Raspberry Pi.
  3. Open a terminal and run:

     cp -r /media/pi/YOUR_DRIVE/teleprompter-pi ~/

Option B: SCP over the network (from another computer)
  Replace PI_IP with your Raspberry Pi's IP address:

     scp -r teleprompter-pi pi@PI_IP:~/

Option C: GitHub (if the repo is public)
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

The installer will print numbered steps as it runs:

  [1/7] Create ~/teleprompter/ directory
  [2/7] Copy teleprompter.html
  [3/7] Install SVG icon
  [4/7] Detect / install Chromium
  [5/7] Install unclutter (mouse hider)
  [6/7] Create Desktop launcher
  [7/7] Create App Menu and Autostart entries


-----------------------------------------------------
STEP 4 — TRUST THE DESKTOP ICON (if prompted)
-----------------------------------------------------

Raspberry Pi OS Bookworm may show the desktop icon
as untrusted. The installer attempts to mark it
trusted automatically using the "gio" tool.

If the icon still shows a warning or won't launch:

  a) Right-click the icon on the Desktop.
  b) Choose "Allow Launching" or "Trust this executable".
  c) The icon should now open normally.

This is a one-time step per installation.


-----------------------------------------------------
STEP 5 — REBOOT
-----------------------------------------------------

  sudo reboot

After rebooting:
  ✓ The Teleprompter desktop icon is available.
  ✓ Chromium opens automatically in kiosk mode.


-----------------------------------------------------
OPENING THE APP MANUALLY (without reboot)
-----------------------------------------------------

Option A: Double-click the Desktop icon.

Option B: Find "Teleprompter" in the Application Menu
          under Utilities or Office.

Option C: From a terminal:
  chromium-browser --kiosk "file://$HOME/teleprompter/teleprompter.html"


-----------------------------------------------------
DISABLING AUTOSTART (keeping the Desktop icon)
-----------------------------------------------------

If you do not want the app to open automatically
on every boot, remove only the autostart entry:

  rm ~/.config/autostart/teleprompter.desktop

The Desktop icon and App Menu entry will still work
for manual launch. No reboot required.


-----------------------------------------------------
KEYBOARD SHORTCUTS (while using the teleprompter)
-----------------------------------------------------

  Space         Start / Pause scrolling
  R             Reset to top
  Up / Down     Speed up / slow down
  Left / Right  Font size smaller / larger
  M             Toggle mirror mode
  H             Hide / show controls (focus mode)
  F             Enter fullscreen


-----------------------------------------------------
EXITING KIOSK MODE (for maintenance)
-----------------------------------------------------

  Alt+F4        Close the Chromium kiosk window
  Ctrl+Alt+T    Open a terminal, then:
                  pkill chromium
                  pkill chromium-browser


-----------------------------------------------------
HOW TO UPDATE TELEPROMPTER.HTML LATER
-----------------------------------------------------

Copy the new file over the existing one:

  cp /path/to/new/teleprompter.html ~/teleprompter/

No reboot is required.
Refresh Chromium with F5, or restart it:

  pkill chromium-browser

From another machine via scp:

  scp teleprompter.html pi@PI_IP:~/teleprompter/


-----------------------------------------------------
HOW TO UNINSTALL
-----------------------------------------------------

  cd ~/teleprompter-pi
  ./uninstall.sh

This removes:
  ✓ ~/teleprompter/                           (app + icon)
  ✓ ~/.config/autostart/teleprompter.desktop  (autostart)
  ✓ ~/.config/autostart/unclutter.desktop     (if present)
  ✓ ~/Desktop/Teleprompter.desktop            (desktop icon)
  ✓ ~/.local/share/applications/teleprompter.desktop

Chromium is NOT removed.

Then reboot to confirm autostart is cleared:

  sudo reboot


-----------------------------------------------------
TROUBLESHOOTING
-----------------------------------------------------

Q: The desktop icon does not appear after install.
A: Refresh the desktop. Right-click the desktop and
   choose "Refresh Desktop" or log out and back in.
   Check: ls ~/Desktop/

Q: Double-clicking the icon does nothing or shows
   a warning dialog.
A: Right-click the icon → "Allow Launching" or
   "Trust this executable". See Step 4 above.

Q: The teleprompter does not open on boot.
A: Autostart requires a graphical desktop session.
   Headless/console boots will not trigger it.
   Check: ls ~/.config/autostart/

Q: Chromium shows a "restore session" banner.
A: The installer uses flags to suppress this.
   If it persists, re-run the installer.

Q: localStorage says "not available".
A: Normal for some Chromium kiosk configurations.
   The app works fine; scripts won't persist between
   sessions.

Q: The mouse cursor is visible.
A: Install unclutter manually:
     sudo apt-get install -y unclutter
   Then run:
     unclutter -idle 1 -root &

Q: The splash screen does not appear.
A: Ensure you have teleprompter.html v1.2 (1067+
   lines). Hard-refresh with Ctrl+Shift+R.


-----------------------------------------------------
REQUIREMENTS
-----------------------------------------------------

  Raspberry Pi:
  - Raspberry Pi OS Desktop (Bookworm or Bullseye)
  - Chromium (auto-installed if missing — needs internet
    for that one step only)

  Windows / Surface RT:
  - Open teleprompter.html directly in Internet
    Explorer or any modern browser — no install needed.

=====================================================
  Copyright 2026 Ruban Peppin
  The Catholic Archdiocese of Edmonton, Communications
  ruban.peppin@caedm.ca | connect@rubangino.ca
=====================================================
