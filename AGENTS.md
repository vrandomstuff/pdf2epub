# AGENTS.md

## Project

Odin + raylib GUI scaffold for a PDF-to-EPUB converter. Only the UI shell exists:
`main.odin` draws two buttons and logs presses; PDF parsing, EPUB writing, and
file-dialog wiring are unimplemented (`main.odin` does not import `tfd` yet).

There is no README, CI, lockfile, test suite, package manifest, or OpenCode config.
The root is one Odin package; subdirectories are separate packages and are not
compiled by `odin build .` unless imported or built directly.

## Commands

Run from the repo root. The font is loaded via the relative path
`assets/IosevkaNerdFontPropo-SemiBold.ttf`, so the built `.exe` fails to start
correctly when launched from another directory.

```powershell
odin run .        # build and launch
odin check .      # compile check without running
odin build .      # writes pdf-to-epub.exe (named after the directory)
```

`odin build . -out:build/app.exe` fails unless the parent directory already
exists; Odin does not create it.

There are no `*_test.odin` files. `tests/` holds two sample PDFs, not an
automated suite.

## Layout and gotchas

- `main.odin` — `package main`, raylib UI. Button rectangles are hardcoded
  (computed with `calculate-button-rec`). To add a button, extend the `buttons`
  slice and `buttonIds` enum; press handling lives in the `switch button.id`
  default branch (currently a TODO print).
- `tfd/` — vendored Odin bindings for tinyfiledialogs v3.22.1. Has no `main`.
  Windows links a prebuilt x64 MSVC `tinyfiledialogs.lib`; other platforms expect
  a system `tinyfiledialogs` library (see `foreign import` in `tfd/tfd.odin`).
  - The `.lib` and `.obj` are gitignored, so a fresh clone must run
    `pwsh tfd/build_lib.ps1` (requires VS C++ build tools) before importing `tfd`,
    or linking fails. Re-run it after editing `tinyfiledialogs.c`.
  - C globals are reached through FFI helpers; dialog strings live in static
    buffers — do not free them or keep them past the next call. See the header
    comment in `tfd/tfd.odin`.
- `assets/` — UI font and license. Loaded by relative path as above.
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
