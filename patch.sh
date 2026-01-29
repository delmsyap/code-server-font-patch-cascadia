#!/usr/bin/env bash
set -e

# -------- CONFIG --------
CS_ROOT="/usr/lib/code-server"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_FONTS="$SCRIPT_DIR/fonts/cascadia"

# Put fonts in a served directory
DST_FONTS="$CS_ROOT/src/browser/media/fonts"

WORKBENCH_HTML="$(find "$CS_ROOT" -name workbench.html | head -n 1)"
# ------------------------


echo "[*] Installing existing Cascadia Code fonts"

# sanity checks
for f in CascadiaCode.woff2 CascadiaCodeItalic.woff2; do
  if [[ ! -f "$SRC_FONTS/$f" ]]; then
    echo "[!] Missing: $SRC_FONTS/$f"
    exit 1
  fi
done

if [[ -z "$WORKBENCH_HTML" ]]; then
  echo "[!] workbench.html not found"
  exit 1
fi

sudo mkdir -p "$DST_FONTS"

echo "[*] Copying fonts"
sudo cp "$SRC_FONTS"/*.woff2 "$DST_FONTS/"

echo "[*] Backing up workbench.html"
sudo cp "$WORKBENCH_HTML" "$WORKBENCH_HTML.bak"

# inject CSS only once
if ! grep -q "Cascadia Code (auto)" "$WORKBENCH_HTML"; then
  # Load fonts using an absolute VS Code URL
  echo "[*] Injecting @font-face"

  sudo sed -i "/<\/head>/i \
<style>\n\
/* Cascadia Code (auto) */\n\
@font-face {\n\
  font-family: 'Cascadia Code';\n\
  src: url('{{BASE}}/_static/src/browser/media/fonts/CascadiaCode.woff2') format('woff2');\n\
  font-weight: 400;\n\
  font-style: normal;\n\
}\n\
@font-face {\n\
  font-family: 'Cascadia Code';\n\
  src: url('{{BASE}}/_static/src/browser/media/fonts/CascadiaCodeItalic.woff2') format('woff2');\n\
  font-weight: 400;\n\
  font-style: italic;\n\
}\n\
</style>\n" "$WORKBENCH_HTML"
else
  echo "[*] CSS already present, skipping"
fi


echo "[✓] Cascadia Code installed successfully"
echo
echo "👉 Add this to settings.json:"
echo "{
  \"editor.fontFamily\": \"'Cascadia Code', monospace\",
  \"editor.fontLigatures\": \"'calt', 'ss01'\"
}"