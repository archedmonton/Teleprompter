# 🎙️ Teleprompter

[![Version](https://img.shields.io/badge/version-3.2.0-blue.svg)](RELEASE_NOTES.md)
[![Release Notes](https://img.shields.io/badge/Release%20Notes-View%20Release%20Notes-orange.svg)](RELEASE_NOTES.md)
[![Platform](https://img.shields.io/badge/platform-Web%20%7C%20Windows%20%7C%20Raspberry%20Pi-lightgrey.svg)](https://github.com/archedmonton/Teleprompter)
[![ES5 Compatible](https://img.shields.io/badge/ES5-Compatible-brightgreen.svg)](https://github.com/archedmonton/Teleprompter)
[![Organization](https://img.shields.io/badge/CAEDM-Communications-860038.svg)](https://caedm.ca)

A fast, lightweight, and offline-first teleprompter application designed for professional broadcasting, homilies, and announcements. 

Built originally to breathe new life into older hardware (like the Microsoft Surface RT running Internet Explorer), the Teleprompter has evolved into a robust tool that supports modern browsers and offers a dedicated deployment package for Raspberry Pi desktop environments.

---

## ✨ Features

- **100% Offline Capable**: Runs entirely from a single local HTML file. No internet connection, npm, build tools, or CDN required.
- **Cross-Platform Compatibility**: Fully ES5-compatible. Works seamlessly on legacy browsers (Internet Explorer) as well as modern versions of Chrome, Edge, Safari, and Firefox.
- **Auto-Scrolling**: Smooth, customizable scrolling with granular speed controls.
- **Mirror Mode**: Horizontally flips the text for use with professional teleprompter beam-splitter glass.
- **Focus Mode**: Hides all navigation and control buttons for a clean, distraction-free reading experience.
- **Local Storage Integration**: Saves your script directly to the browser so you don't lose it between sessions.
- **Keyboard & Touch Controls**: Extensive keyboard shortcuts for hardware controllers, alongside a touch-friendly interface.
- **Custom Branding**: Professional, dark-themed startup splash screen tailored for the Catholic Archdiocese of Edmonton.

---

## 🚀 Getting Started (Windows / Mac / General)

Because the app is entirely self-contained in one file, installation is incredibly simple:

1. Download or clone this repository.
2. Double-click **`teleprompter.html`** to open it in your default web browser.
3. Paste your script into the editor, click **Load Script into Prompter**, and press **Start**.

---

## 🍓 Raspberry Pi Deployment

The project includes a dedicated `teleprompter-pi` folder containing an installer script optimized for Raspberry Pi OS Desktop environments.

This setup configures the app to run as a dedicated desktop application using a clean Chromium profile, ensuring maximum stability.

### Installation on Raspberry Pi

1. Transfer the repository to your Raspberry Pi.
2. Open a terminal and navigate to the pi folder:
   ```bash
   cd ~/Teleprompter/teleprompter-pi
   ```
3. Make the scripts executable:
   ```bash
   chmod +x install.sh uninstall.sh
   ```
4. Run the installer:
   ```bash
   ./install.sh
   ```

### What the Pi Installer Does

- Creates a dedicated directory at `~/teleprompter/`.
- Sets up a **Desktop Icon** and **Application Menu** shortcut.
- Generates a custom launch script (`launch-teleprompter.sh`) that automatically clears stale browser locks, preventing "Restore Session" crash prompts.
- Forces Chromium to open in a maximized window using an isolated browser profile (`~/.teleprompter-chrome-profile`), keeping your personal browsing history and the prompter entirely separate.

---

## ⌨️ Keyboard Shortcuts

Hardware presentation clickers or standard keyboards can be used to control the prompter:

| Key | Action |
| :--- | :--- |
| <kbd>Space</kbd> | Start / Pause scrolling |
| <kbd>R</kbd> | Reset to top |
| <kbd>Up Arrow</kbd> | Increase speed |
| <kbd>Down Arrow</kbd> | Decrease speed |
| <kbd>Right Arrow</kbd> | Increase font size |
| <kbd>Left Arrow</kbd> | Decrease font size |
| <kbd>M</kbd> | Toggle mirror mode |
| <kbd>H</kbd> | Hide / show controls (Focus mode) |
| <kbd>F</kbd> | Enter fullscreen |

---

## 👨‍💻 Developer / Author

**Ruban Peppin**  
*Developer, Communications*  
The Catholic Archdiocese of Edmonton  
📧 [ruban.peppin@caedm.ca](mailto:ruban.peppin@caedm.ca)  

**Alan Schietzsch**
*Webmaster, Communications*
📧 [webmaster@caedm.ca](mailto:webmaster@caedm.ca)

> *For bug reports, feature requests, or support, please contact the developer or webmaster directly.*

---

## 📄 License & Copyright

Copyright © 2026 Ruban Peppin  
The Catholic Archdiocese of Edmonton, Communications  
*All rights reserved.*
