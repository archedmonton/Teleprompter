=====================================================
  TELEPROMPTER — Raspberry Pi Kiosk Setup Guide
=====================================================

  Organization : The Catholic Archdiocese of Edmonton
  Department   : Communications
  Platform     : Raspberry Pi OS Desktop / Internet Explorer

This package sets up the teleprompter to launch
automatically in fullscreen kiosk mode on boot
using Chromium on Raspberry Pi OS Desktop.

No internet connection is required after installation
(unless Chromium itself needs to be installed via apt).


=====================================================
  VERSION HISTORY
=====================================================

  v1.2.0  2026-06-17
    - Added startup splash screen with CAEDM branding
      (burgundy accent #860038, 2.5 s auto-dismiss,
      Skip button, CSS fade with IE fallback)
    - Added dedicated "Exit Fullscreen" button to
      top control bar (all vendor prefixes supported:
      exitFullscreen, msExitFullscreen,
      webkitExitFullscreen, mozCancelFullScreen)
    - Graceful "Fullscreen is not active" status
      message when exit is pressed outside fullscreen

  v1.1.0  2026-06-17
    - Added "Exit Fullscreen" button (initial draft)
    - Added Raspberry Pi kiosk installer package
      (install.sh, uninstall.sh, README.txt)
    - Chromium autostart via .desktop entry
    - Mouse cursor hiding via unclutter
    - Supports both chromium and chromium-browser
      commands, auto-detected at install time

  v1.0.0  2026-06-17
    - Initial release
    - Single-file offline teleprompter (teleprompter.html)
    - ES5-compatible (Internet Explorer / Surface RT)
    - Features: auto-scroll, speed/font controls,
      mirror mode, focus mode, localStorage save/load,
      fullscreen, keyboard shortcuts, touch support


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

  teleprompter.html   The teleprompter web app
  install.sh          Raspberry Pi installer script
  uninstall.sh        Raspberry Pi uninstaller script
  README.txt          This file


-----------------------------------------------------
STEP 1 — COPY THIS FOLDER TO YOUR RASPBERRY PI
-----------------------------------------------------

Option A: USB drive
  1. Copy the teleprompter-pi folder to a USB drive.
  2. Plug the USB drive into the Raspberry Pi.
  3. Open a terminal and copy to your home directory:

     cp -r /media/pi/YOUR_DRIVE/teleprompter-pi ~/

Option B: SCP over the network (from another computer)
  Replace PI_IP with your Raspberry Pi's IP address:

     scp -r teleprompter-pi pi@PI_IP:~/

Option C: Manually create the files on the Pi using
  the Raspberry Pi OS file manager or text editor.


-----------------------------------------------------
STEP 2 — MAKE SCRIPTS EXECUTABLE
-----------------------------------------------------

Open a terminal on the Raspberry Pi and run:

  cd ~/teleprompter-pi
  chmod +x install.sh uninstall.sh


-----------------------------------------------------
STEP 3 — RUN THE INSTALLER
-----------------------------------------------------

  ./install.sh

The installer will:
  - Create ~/teleprompter/
  - Copy teleprompter.html into ~/teleprompter/
  - Install Chromium if not already present
  - Install unclutter (hides mouse cursor) if available
  - Create an autostart entry so the teleprompter
    launches automatically at login/boot


-----------------------------------------------------
STEP 4 — REBOOT
-----------------------------------------------------

  sudo reboot

After rebooting, Chromium will open automatically
in fullscreen kiosk mode displaying the teleprompter.


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

If you need to close Chromium in kiosk mode:
  - Press Alt+F4 to close the window
  - Or connect a keyboard and press Ctrl+Alt+T
    to open a terminal, then:
      pkill chromium
      pkill chromium-browser


-----------------------------------------------------
HOW TO UPDATE TELEPROMPTER.HTML LATER
-----------------------------------------------------

Just copy the new file over the existing one:

  cp /path/to/new/teleprompter.html ~/teleprompter/

No reboot is required. Refresh Chromium with F5,
or restart it:

  pkill chromium-browser
  # It will relaunch automatically on next login,
  # or reboot the Pi.

Alternatively, scp from another machine:

  scp teleprompter.html pi@PI_IP:~/teleprompter/


-----------------------------------------------------
HOW TO UNINSTALL
-----------------------------------------------------

  cd ~/teleprompter-pi
  ./uninstall.sh

This removes:
  - ~/teleprompter/ (the install directory)
  - The autostart desktop entry

Chromium is NOT removed.

Then reboot to confirm autostart is cleared:

  sudo reboot


-----------------------------------------------------
TROUBLESHOOTING
-----------------------------------------------------

Q: The teleprompter does not launch on boot.
A: Make sure you are logged into a desktop session
   (not a headless/console session). Autostart
   entries only fire on graphical login.
   Check: ls ~/.config/autostart/

Q: Chromium shows a "restore session" banner.
A: The installer uses flags to suppress this.
   If it persists, run the installer again.

Q: localStorage says "not available".
A: This is normal for some Chromium kiosk
   configurations with strict security flags.
   The app will still work; scripts just won't
   be saved between sessions.

Q: The mouse cursor is visible.
A: Install unclutter manually:
     sudo apt-get install -y unclutter
   Then add it to autostart or run:
     unclutter -idle 1 -root &

Q: The splash screen does not appear.
A: Ensure you are opening the latest version of
   teleprompter.html (v1.2.0, 1067+ lines).
   Hard-refresh the browser with Ctrl+Shift+R
   if a cached version was previously loaded.


-----------------------------------------------------
REQUIREMENTS
-----------------------------------------------------

  - Raspberry Pi OS Desktop (Bookworm or Bullseye)
  - Chromium browser (installed by script if missing)
  - Internet access only needed if Chromium must be
    installed via apt (one-time)

  For Windows / Surface RT:
  - Open teleprompter.html directly in Internet
    Explorer or any modern browser — no install needed.

=====================================================
  Copyright 2026 Ruban Peppin /
  The Catholic Archdiocese of Edmonton, Communications
=====================================================
