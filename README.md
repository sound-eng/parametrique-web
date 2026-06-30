# Parametrique — Download Site

Public download page for the Parametrique macOS installer. The site is served via **GitHub Pages** from the `docs/` folder. Release `.pkg` files are published as **GitHub Release assets** on this repository.

Application source and build tooling live in [parametrique-audio-device](https://github.com/sound-eng/parametrique-audio-device).

## Site

| Path | Purpose |
|------|---------|
| `docs/index.html` | Landing page with download button |
| `docs/install.html` | Install guide |
| `docs/releases/manifest.json` | Latest version, download URL, SHA-256 |
| `docs/css/`, `docs/js/` | Static assets |

The download button reads `manifest.json` at runtime so you only update one file per release.

## Enable GitHub Pages

1. Open **Settings → Pages** on this repository.
2. Under **Build and deployment**, set **Source** to **Deploy from a branch**.
3. Choose branch **main** and folder **/docs**.
4. Save. The site will be available at `https://sound-eng.github.io/Parametrique-web/` (or your custom domain).

## Publish a new release

From `parametrique-audio-device`, build and notarize the installer:

```bash
./scripts/build-distribution.sh --notarize
```

Then in this repo:

```bash
# 1. Update manifest (version, URL, SHA-256)
./scripts/update-manifest.sh 1.0.21 /path/to/Parametrique-1.0.21.pkg "Optional release notes."

# 2. Commit manifest
git add docs/releases/manifest.json
git commit -m "Release 1.0.21"

# 3. Create GitHub Release and upload the .pkg
gh release create v1.0.21 /path/to/Parametrique-1.0.21.pkg --title "1.0.21"
```

The release tag must be `v<version>` (e.g. `v1.0.21`) and the uploaded file must be named `Parametrique-<version>.pkg` so the download URL in the manifest matches.

### Pre-publish checklist

- [ ] Version bumped in `parametrique-audio-device/shared/Version.xcconfig`
- [ ] Installer built, signed, and notarized
- [ ] Smoke test passed (see `parametrique-audio-device/packaging/SMOKE_TEST.md`)
- [ ] `docs/releases/manifest.json` updated via `scripts/update-manifest.sh`
- [ ] GitHub Release created with matching tag and `.pkg` asset
- [ ] Download button on the site works

## Local preview

Serve `docs/` with any static file server:

```bash
python3 -m http.server 8080 --directory docs
```

Open http://localhost:8080

## Repository layout

```text
parametrique-web/
├── docs/                  # GitHub Pages root
│   ├── index.html
│   ├── install.html
│   ├── releases/manifest.json
│   ├── css/
│   └── js/
├── scripts/
│   └── update-manifest.sh
└── README.md
```

Do not commit `.pkg` files — upload them to GitHub Releases only.
