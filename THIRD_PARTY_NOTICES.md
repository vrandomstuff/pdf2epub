# Third-Party Notices

This file lists the third-party components used by or distributed with
PDF to EPUB and the license terms that apply to them.

## Licensing of this project

- The project source code is licensed under the **GNU General Public
  License, version 2 or (at your option) any later version**
  (`GPL-2.0-or-later`). See `LICENSE`.
- `tfd/tfd.odin` (the Odin bindings) is dedicated to the public domain
  under **CC0 1.0 Universal**. See `tfd/LICENSE-CC0.txt`. CC0 is
  compatible with the GPL.
- The font in `assets/` is third-party Font Software under the **SIL Open
  Font License 1.1** and is **not** covered by the GPL. It is aggregated
  with, not merged into, the GPL-licensed program.
- `tfd/tinyfiledialogs.c` and `tfd/tinyfiledialogs.h` are third-party code
  under the **zlib** license and are **not** covered by the GPL.

## raylib

Used for the GUI. Statically linked into Windows builds through Odin's
`vendor:raylib` (`raylib.lib`).

License: zlib/libpng

```text
Copyright (c) 2013-2026 Ramon Santamaria (@raysan5)

This software is provided "as-is", without any express or implied warranty. In no event
will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial
applications, and to alter it and redistribute it freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not claim that you
  wrote the original software. If you use this software in a product, an acknowledgment
  in the product documentation would be appreciated but is not required.

  2. Altered source versions must be plainly marked as such, and must not be misrepresented
  as being the original software.

  3. This notice may not be removed or altered from any source distribution.
```

## Odin

Compiler, core library, and runtime used to build the program. The Odin
runtime is compiled into the executable.

License: zlib-style

```text
Copyright (c) 2016-2025 Ginger Bill. All rights reserved.

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
```

## tinyfiledialogs

Version 3.22.1, vendored unmodified from
<https://tinyfiledialogs.sourceforge.net> in `tfd/` and linked into builds.

License: zlib

```text
Copyright (c) 2014 - 2025 Guillaume Vareille http://ysengrin.com

This software is provided 'as-is', without any express or implied
warranty.  In no event will the authors be held liable for any damages
arising from the use of this software.
Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:
1. The origin of this software must not be misrepresented; you must not
claim that you wrote the original software.  If you use this software
in a product, an acknowledgment in the product documentation would be
appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
```

## Iosevka Nerd Font Propo SemiBold

Bundled UI font: `assets/IosevkaNerdFontPropo-SemiBold.ttf`.
Iosevka 34.8.0, patched with Nerd Fonts 3.5.1.

License: SIL Open Font License 1.1

Copyright (c) Renzhi Li (aka. Belleve Invis, belleve@typeof.net). The
copyright years and the full OFL 1.1 text are in the bundled
`assets/FONT_LICENSE.md`, and the font's internal name table also carries
the OFL notice. `assets/FONT_LICENSE.md` must be distributed with the font.

The font is a Nerd Fonts patched build. Nerd Fonts' patched-font notice is:

```text
Copyright (c) 2014, Ryan L McIntyre (https://ryanlmcintyre.com).

This Font Software is licensed under the SIL Open Font License, Version 1.1.
```

The Nerd Fonts `font-patcher` source code (MIT) is not distributed with
this project.

## Development-only dependencies

`tests/make_pdfs.py` uses the following packages to regenerate the test
fixtures. Neither is vendored, imported by the application, or distributed
with it:

- ReportLab — BSD-3-Clause
- Pillow — MIT-CMU

## Redistributing binaries

If you distribute a built executable, ship `LICENSE`,
`THIRD_PARTY_NOTICES.md`, and `assets/FONT_LICENSE.md` alongside it so the
notices for the statically linked libraries and the font travel with the
binary. The GPL also requires that you make the corresponding source code
available.
