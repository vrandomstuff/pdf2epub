# AGENTS.md

## Project

Odin + raylib GUI scaffold for a PDF-to-EPUB converter. File selection is wired:
`main.odin` opens/saves paths through `tfd` and displays the last three path
components. PDF parsing and EPUB writing are unimplemented — there is no
conversion pipeline yet.

There is no README, CI, lockfile, test suite, package manifest, or OpenCode config.
The root is one Odin package (`main`); `ui/` is a separate package imported by it.
Subdirectories that are neither imported nor built directly are not compiled by
`odin build .`.

## Commands

Run from the repo root. The font and check icon are loaded via relative
`assets/...` paths, so the built `.exe` also fails to find them when launched from
another directory.

```powershell
odin run .        # build and launch
odin check .      # compile check without running (also checks imported ui package)
odin build .      # writes pdf-to-epub.exe (named after the directory)
```

`odin build . -out:build/app.exe` fails unless the parent directory already
exists; Odin does not create it.

Windows linking may print a `USER32.dll: CloseWindow` COMDAT conflict warning from
raylib; the build still succeeds.

There are no `*_test.odin` files. `tests/` holds two sample PDFs, not an
automated suite.

## Layout and gotchas

- `main.odin` — `package main`, raylib drawing/input loop. Defines `buttonIds`,
  the hardcoded `buttons` slice, and a package-level `debuggingCheckmark`. Both
  switch cases call `tfd` file dialogs and store the chosen paths in the globals
  `input`/`output`. There is no `default` case: a new button id needs its own case.
  Button widths come from `calculate-button-rec`.
  - `truncatePath` returns a display-only slice into the original `cstring`; it
    does not allocate or own the result.
- `ui/` — `package ui`; exports `FONTSIZE`, `FONTSPACE`, `TextButton`,
  `CheckmarkButton`, `drawTextButton`, `drawCheckmarkButton`, `checkButton`, and
  `checkCheckmarkButton`. Root `odin check .` covers it because `main.odin`
  imports it.
  - `checkButton` fires on left-mouse **release**. The checkmark icon is centered
    using `button.icon.width/height`, then drawn after the background rectangle.
- `assets/` — UI font, `check.png` checkmark icon, and font license. The font and
  icon are loaded by relative path as noted above.
- `krita/` — `check.kra` is the Krita source artwork for `assets/check.png`; it is
  not compiled or loaded at runtime.
- `tfd/` — vendored Odin bindings for tinyfiledialogs v3.22.1. Has no `main`.
  Windows links a prebuilt x64 MSVC `tinyfiledialogs.lib`; other platforms expect
  a system `tinyfiledialogs` library (see `foreign import` in `tfd/tfd.odin`).
  - The `.lib` and `.obj` are gitignored, so a fresh clone must run
    `pwsh tfd/build_lib.ps1` (requires VS C++ build tools) before importing `tfd`,
    or linking fails. Re-run it after editing `tinyfiledialogs.c`.
  - C globals are reached through FFI helpers; dialog strings live in static
    buffers — do not free them or keep them past the next call. See the header
    comment in `tfd/tfd.odin`.
  - `tfd/test.c` is a standalone manual C smoke test, not part of the Odin build.
- `tests/` — `with_character_data.pdf` (extractable text) and
  `without_character_data.pdf` (rasterized text) are fixtures for the two
  expected conversion paths. `python tests/make_pdfs.py` regenerates them and
  needs `reportlab` + `Pillow`; it contains a hardcoded absolute path to this
  checkout's `tests/` directory.
- `calculate-button-rec/` — standalone helper that prints an `rl.Rectangle`
  sized for its `TEXT`/`PADX`/`PADY`. Run from inside that directory
  (`cd calculate-button-rec; odin run .`) because it loads `../assets/...`.
  Its `package generateRecWithPadding` is intentional; Odin executables do not
  require the package to be named `main`.

Editor backup files (`*~`, `.#*`) are gitignored and not source.

## Licensing

Project code is GPL-2.0-or-later (`LICENSE`), except `tfd/tfd.odin`, which is
CC0-1.0 (`tfd/LICENSE-CC0.txt`). Third-party components: raylib, Odin, and
tinyfiledialogs are zlib-style; the bundled Iosevka Nerd Font is OFL-1.1
(`assets/FONT_LICENSE.md`). Keep `THIRD_PARTY_NOTICES.md` current when adding or
updating dependencies, and do not relicense the font or the vendored C files.
