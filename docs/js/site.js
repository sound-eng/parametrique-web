const MANIFEST_URL = "releases/manifest.json";

function formatDate(isoDate) {
  const date = new Date(isoDate + "T00:00:00");
  return date.toLocaleDateString(undefined, {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
}

function setText(id, text) {
  const el = document.getElementById(id);
  if (el) {
    el.textContent = text;
  }
}

function setHtml(id, html) {
  const el = document.getElementById(id);
  if (el) {
    el.innerHTML = html;
  }
}

async function loadRelease() {
  const downloadBtn = document.getElementById("download-btn");
  const errorEl = document.getElementById("load-error");

  try {
    const response = await fetch(MANIFEST_URL, { cache: "no-cache" });
    if (!response.ok) {
      throw new Error(`Failed to load manifest (${response.status})`);
    }

    const manifest = await response.json();
    const release =
      manifest.releases.find((item) => item.version === manifest.latest) ??
      manifest.releases[0];

    if (!release) {
      throw new Error("No releases in manifest");
    }

    setText("latest-version", `Version ${release.version}`);
    setText(
      "download-meta",
      `macOS ${release.minMacOS}+ · ${formatDate(release.published)}`
    );

    if (downloadBtn) {
      downloadBtn.href = release.downloadUrl;
      downloadBtn.textContent = `Download ${release.fileName}`;
    }

    const hashEl = document.getElementById("sha256");
    if (hashEl) {
      if (release.sha256) {
        hashEl.textContent = `SHA-256: ${release.sha256}`;
        hashEl.hidden = false;
      } else {
        hashEl.hidden = true;
      }
    }

    document.title = `${manifest.product} ${release.version}`;
  } catch (error) {
    console.error(error);
    if (errorEl) {
      errorEl.textContent =
        "Could not load release information. Check releases/manifest.json.";
      errorEl.hidden = false;
    }
    if (downloadBtn) {
      downloadBtn.setAttribute("aria-disabled", "true");
      downloadBtn.classList.add("disabled");
      downloadBtn.removeAttribute("href");
    }
  }
}

document.addEventListener("DOMContentLoaded", loadRelease);
