# Parametrique

![Parametrique main window](docs/assets/parametrique-main-window.png)

macOS parametric EQ for your system output — through a virtual HAL device, or by tapping whatever is already playing. The UI is recognizable to sound engineers and audio enthusiasts alike.

Parametrique applies an 8-band per-channel parametric EQ using proven DSP math. In Virtual device mode, settings persist after you quit; in System audio mode, EQ runs while the app is open.

This repository is the public **download site and release channel** for Parametrique — installers, documentation, and the GitHub Pages site. It does not contain the app or driver source code.

**[Download the latest release →](https://sound-eng.github.io/parametrique-web/)**

Requires **macOS 14.6 or later**.


## Quick start

1. Download and open `Parametrique-<version>.pkg` from the [download page](https://sound-eng.github.io/parametrique-web/).
2. Launch **Parametrique** from `/Applications`.
3. Open **Parametrique → Settings → Mode** and pick one:
   - **Virtual device** — select **Parametrique EQ Device** in **System Settings → Sound**, then choose your speakers under **Proxied device**.
   - **System audio** — leave your normal output selected, grant **Audio Recording** if prompted, and keep Parametrique running.


## Using the app

| Main window | Settings (Parametrique → Settings) |
|-------------|-------------------------------------|
| 8-band EQ, live response graph, L/R ganging, bypass, Level, Balance, meters | Mode, proxied device / loopback status, buffer size, driver options |
| Changes apply to the active backend immediately | Export Diagnostics when troubleshooting |

- **Modes** — Virtual device keeps EQ after quit; System audio EQs the current default output and stops when you quit. Only one mode is active at a time.
- **EQ** — adjust bands in the main window; use presets to save and recall curves.
- **Proxied device** (Virtual device) — pick the physical output you want to hear. Without this, audio routes to the first device in the list.
- **No sound?** — Virtual device: confirm the proxied device and raise **Parametrique EQ Device** in Audio MIDI Setup. System audio: check **Audio Recording** permission and keep a normal (non-Parametrique) default output.
- **Crackling?** — increase buffer size in Settings.

## Install

A step-by-step install guide is on the site: [install guide](https://sound-eng.github.io/parametrique-web/install.html).


## Uninstall

1. Remove the driver — **Parametrique → Settings → Driver → Uninstall…** (or delete `Parametrique.driver` manually from `/Library/Audio/Plug-Ins/HAL/`).
2. Restart Core Audio if you deleted the driver manually: `sudo launchctl kickstart -k system/com.apple.audio.coreaudiod`
3. Delete **Parametrique** from `/Applications`.
