# Code Server Font Patch

This patch enables [code-server](https://github.com/cdr/code-server) to load **Cascadia Code** (with italic and cursive support) in the server.

It supports **offline font files** and automatically injects the necessary `@font-face` rules for proper italics and cursive glyphs.

---

## Screenshot

![Code Server with Cascadia Code](images/screenshot.png)

---

## Installation

1. Clone this repository:

```bash
git clone https://github.com/yourusername/code-server-font-patch.git
cd code-server-font-patch

2. Make sure you have the Cascadia Code font files in the fonts/cascadia folder next to the script:



fonts/cascadia/
├── CascadiaCode.woff2
└── CascadiaCodeItalic.woff2

3. Run the patch script. The script automatically detects your code-server installation path:



sudo ./install-cascadia-existing.sh

> The script will copy the fonts to the code-server _static folder, inject the CSS, and back up workbench.html.
No need to manually edit workbench.html or hardcode paths.




---

Settings

After installing, configure your editor settings in settings.json to enable Cascadia Code and cursive italics:

{
  "editor.fontFamily": "'Cascadia Code', monospace",
  "terminal.integrated.fontFamily": "'Cascadia Code', monospace",
  "editor.fontLigatures": "'calt', 'ss01'"
}

'calt', 'ss01' enables Cascadia Code’s cursive italic glyphs.

Optional: add 'ss02' for extra stylistic flourishes.



---

Verification

1. Open code-server and check comments or italic tokens — letters like f, k, y should have curvy/cursive shapes.


2. Open Developer Tools → Network → Font to ensure:



CascadiaCode.woff2 → 200 OK
CascadiaCodeItalic.woff2 → 200 OK


---

Notes

Fonts are served offline — no Google Fonts dependency.

Works on any Linux system or Termux environment.

Safe for re-use — backs up workbench.html before injecting CSS.

To update or reinstall after a code-server update, simply re-run the script.

