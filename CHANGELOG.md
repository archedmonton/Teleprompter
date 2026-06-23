# 📜 Changelog & Release Notes

All notable changes to the Teleprompter project will be documented in this file.

---

## [v3.1.0] - 2026-06-18
**Status:** 🟢 Stable / Production Ready

### Added
- **Dedicated Chromium Profile:** The app now runs in a completely isolated profile (`~/.teleprompter-chrome-profile`) ensuring personal browsing data and teleprompter data never mix.
- **Robust Launch Script:** Added `launch-teleprompter.sh` which automatically purges stale browser locks (`SingletonLock`, `SingletonSocket`, `SingletonCookie`, `Preferences.lock`) prior to launch.
- **Crash Prevention:** Completely eliminated the Chromium "Restore Session" crash prompts that can occur in kiosk-style environments after a hard reboot or force close.
- **Root Repository Documentation:** Added a professional `README.md` and this `CHANGELOG.md` for better repository structure.

### Changed
- `uninstall.sh` was updated to cleanly wipe the new isolated profile.
- All desktop shortcuts now point to the new wrapper script rather than executing Chromium directly.

---

## [v3.0.0] - 2026-06-17

### Changed
- **Removed OS-Level Kiosk Mode:** Transitioned the application to launch in a standard Maximized Window (`--start-maximized`). This is much safer and allows the presenter to use the internal app controls (like the `Full` and `Exit FS` buttons) to manage fullscreen without getting trapped.
- **Disabled Autostart:** The application no longer attempts to hijack the boot sequence. It must be launched intentionally via the Desktop icon.

### Removed
- Removed the `TELEPROMPTER_MODE` configuration block from the installer.
- Actively purges legacy `.config/autostart/` entries from older v1/v2 installations.

---

## [v2.1.0] - 2026-06-17

### Added
- Introduced the `TELEPROMPTER_MODE` flag allowing configuration between "windowed" and "kiosk" modes.
- Summary outputs on the installer to clarify which mode was selected.

---

## [v2.0.0] - 2026-06-17

### Added
- Created the Application Menu shortcut (`~/.local/share/applications/`).
- Bundled the `teleprompter-icon.svg` (Dark theme with CAEDM burgundy accent) natively.
- Added `gio` trust-marking to support Raspberry Pi OS Bookworm desktop icon security policies.

---

## [v1.2.0] - 2026-06-17

### Added
- **Custom Branding:** Added the professional Catholic Archdiocese of Edmonton startup splash screen with auto-fade and a manual skip button.
- **Exit Fullscreen Button:** Added a dedicated exit fullscreen button to the top control bar with cross-browser vendor-prefix support (`msExitFullscreen`, `webkitExitFullscreen`, etc.).

---

## [v1.0.0] - 2026-06-17

### Added
- Initial release of the offline HTML Teleprompter.
- Full ES5 compatibility for legacy hardware (e.g., Internet Explorer on Microsoft Surface RT).
- Core features: Auto-scrolling, Speed & Font controls, Mirror Mode, Focus Mode.
- Integrated `localStorage` engine for script persistence across sessions.
