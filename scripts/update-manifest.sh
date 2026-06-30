#!/usr/bin/env bash
#
# Update docs/releases/manifest.json for a new GitHub Release.
#
# Usage:
#   ./scripts/update-manifest.sh VERSION PKG_PATH [NOTES]
#
# Example:
#   ./scripts/update-manifest.sh 1.0.21 ../parametrique-audio-device/dist/Parametrique-1.0.21.pkg
#
# After running:
#   1. Commit and push manifest changes
#   2. Create a GitHub Release tagged vVERSION and upload the .pkg

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly MANIFEST="${REPO_ROOT}/docs/releases/manifest.json"

usage() {
    cat <<EOF
Update the release manifest for GitHub Pages.

Usage:
  $(basename "$0") VERSION PKG_PATH [NOTES]

Arguments:
  VERSION   Marketing version (e.g. 1.0.21)
  PKG_PATH  Path to Parametrique-VERSION.pkg (used for SHA-256)
  NOTES     Optional one-line release notes

The download URL is generated as:
  https://github.com/<owner>/<repo>/releases/download/vVERSION/Parametrique-VERSION.pkg
EOF
}

die() {
    echo "error: $*" >&2
    exit 1
}

require_cmd() {
    command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

read_repo_slug() {
    python3 - "${MANIFEST}" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

repo = data.get("repository")
if not repo or "/" not in repo:
    raise SystemExit("manifest.json is missing a valid repository field")

print(repo)
PY
}

main() {
    if [[ $# -lt 2 ]]; then
        usage >&2
        exit 1
    fi

    local version="$1"
    local pkg_path="$2"
    local notes="${3:-macOS HAL virtual audio driver with 8-band per-channel parametric EQ.}"

    [[ "${version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "VERSION must look like 1.0.21"
    [[ -f "${pkg_path}" ]] || die "PKG not found: ${pkg_path}"

    require_cmd python3
    require_cmd shasum

    local repo_slug
    repo_slug="$(read_repo_slug)"

    local file_name="Parametrique-${version}.pkg"
    local download_url="https://github.com/${repo_slug}/releases/download/v${version}/${file_name}"
    local sha256
    sha256="$(shasum -a 256 "${pkg_path}" | awk '{ print $1 }')"
    local published
    published="$(date +%Y-%m-%d)"

  python3 - "${MANIFEST}" "${version}" "${published}" "${file_name}" "${download_url}" "${sha256}" "${notes}" <<'PY'
import json
import sys

manifest_path, version, published, file_name, download_url, sha256, notes = sys.argv[1:]

with open(manifest_path, encoding="utf-8") as f:
    data = json.load(f)

release = {
    "version": version,
    "published": published,
    "minMacOS": "14.6",
    "fileName": file_name,
    "downloadUrl": download_url,
    "sha256": sha256,
    "notes": notes,
}

releases = [r for r in data.get("releases", []) if r.get("version") != version]
releases.insert(0, release)
releases.sort(key=lambda r: tuple(int(x) for x in r["version"].split(".")), reverse=True)

data["latest"] = version
data["releases"] = releases

with open(manifest_path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY

    echo "Updated ${MANIFEST}"
    echo "  version:      ${version}"
    echo "  downloadUrl:  ${download_url}"
    echo "  sha256:       ${sha256}"
    echo
    echo "Next steps:"
    echo "  1. git add docs/releases/manifest.json"
    echo "  2. git commit -m \"Release ${version}\""
    echo "  3. gh release create \"v${version}\" \"${pkg_path}\" --title \"${version}\""
}

main "$@"
