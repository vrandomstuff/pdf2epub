// SPDX-License-Identifier: CC0-1.0
// The Odin bindings in this file are dedicated to the public domain under
// CC0 1.0 Universal; see LICENSE-CC0.txt. The vendored tinyfiledialogs C
// sources and header in this directory are third-party code under the zlib
// license; see their file headers.
/*
	Odin bindings for tinyfiledialogs v3.22.1 (tinyfiledialogs.h)
	https://tinyfiledialogs.sourceforge.net

	The C sources are in this folder as well. `tinyfiledialogs.lib` is a
	prebuilt x64 static library (MSVC) and is linked automatically.
	Rebuild it with `tfd/build_lib.ps1` after updating the C sources.

	On platforms other than Windows, build `tinyfiledialogs.c` into a library
	called `tinyfiledialogs` (for example `libtinyfiledialogs.a`) or change the
	`foreign import` below to point at the static library directly.

	Usage:
		import "tfd"

		tfd.tinyfd_messageBox("Title", "Hello", "ok", "info", 0)

	Notes:
	- All `char *` strings are UTF-8, including on Windows (since v3.6).
	- Strings returned by tinyfiledialogs live in static internal buffers.
	  Do not free them and do not hold on to them after the next call.
	- The library exposes its configuration as C globals (tinyfd_verbose,
	  tinyfd_winUtf8, ...). Odin resolves foreign variables through `__imp_`
	  symbols on Windows, which plain static C libraries do not provide, so the
	  globals are exposed through the library's own FFI functions
	  (`tinyfd_getGlobalChar` / `tinyfd_getGlobalInt` / `tinyfd_setGlobalInt`)
	  and the helper procedures at the bottom of this file.
*/
package tfd

import "core:c"

// Three bytes in the order red, green, blue.
RGB :: [3]u8

when ODIN_OS == .Windows {
	foreign import tfd_lib {
		"tinyfiledialogs.lib",
		"system:Comdlg32.lib",
		"system:Ole32.lib",
		"system:User32.lib",
		"system:Gdi32.lib",
		"system:Shell32.lib",
	}
} else {
	foreign import tfd_lib "system:tinyfiledialogs"
}

@(default_calling_convention="c")
foreign tfd_lib {
	// Plays the system beep.
	tinyfd_beep :: proc() ---

	// The return value is only meaningful for "tinyfd_query": 0 means console
	// mode, 1 means graphic mode. Otherwise the dialog is shown and 1 is
	// returned.
	tinyfd_notifyPopup :: proc(
		title:      cstring, // nil or ""
		message:    cstring, // nil or "", may contain \n and \t
		icon_type:  cstring, // "info", "warning", "error"
	) -> c.int ---

	// Returns 0 for cancel/no, 1 for ok/yes, 2 for no in yesnocancel.
	tinyfd_messageBox :: proc(
		title:          cstring, // nil or ""
		message:        cstring, // nil or "", may contain \n and \t
		dialog_type:    cstring, // "ok", "okcancel", "yesno", "yesnocancel"
		icon_type:      cstring, // "info", "warning", "error", "question"
		default_button: c.int,   // 0 for cancel/no, 1 for ok/yes, 2 for no
	) -> c.int ---

	// Returns nil on cancel. `default_input == nil` shows a password box,
	// an empty string shows a regular input box.
	tinyfd_inputBox :: proc(
		title:          cstring, // nil or ""
		message:        cstring, // nil or ""
		default_input:  cstring, // nil = passwordBox, "" = inputBox
	) -> cstring ---

	// Returns nil on cancel.
	tinyfd_saveFileDialog :: proc(
		title:                     cstring,       // nil or ""
		default_path_and_or_file:  cstring,       // nil or "", ending with / sets only a directory
		num_of_filter_patterns:    c.int,         // 0 or len(filter_patterns)
		filter_patterns:           [^]cstring,    // nil or e.g. {"*.txt"}
		single_filter_description: cstring,       // nil or "text files"
	) -> cstring ---

	// Returns nil on cancel. Multiple selected files are separated by '|'.
	tinyfd_openFileDialog :: proc(
		title:                     cstring,       // nil or ""
		default_path_and_or_file:  cstring,       // nil or "", ending with / sets only a directory
		num_of_filter_patterns:    c.int,         // 0 or len(filter_patterns)
		filter_patterns:           [^]cstring,    // nil or e.g. {"*.png", "*.jpg"}
		single_filter_description: cstring,       // nil or "image files"
		allow_multiple_selects:    c.int,         // 0 or 1
	) -> cstring ---

	// Returns nil on cancel.
	tinyfd_selectFolderDialog :: proc(
		title:         cstring, // nil or ""
		default_path:  cstring, // nil or ""
	) -> cstring ---

	// Returns nil on cancel, otherwise the colour as "#RRGGBB".
	// `default_rgb` is only used when `default_hex_rgb` is absent.
	// `default_rgb` and `result_rgb` may point at the same array.
	tinyfd_colorChooser :: proc(
		title:            cstring, // nil or ""
		default_hex_rgb:  cstring, // nil, "" or "#FF0000"
		default_rgb:      ^RGB,    // nil or {0, 128, 255}
		result_rgb:       ^RGB,    // receives the chosen colour
	) -> cstring ---

	// FFI helpers for the library's C globals. Return nil/-1 on error.
	tinyfd_getGlobalChar :: proc(variable_name: cstring) -> cstring ---
	tinyfd_getGlobalInt  :: proc(variable_name: cstring) -> c.int ---
	tinyfd_setGlobalInt  :: proc(variable_name: cstring, value: c.int) -> c.int ---
}

when ODIN_OS == .Windows {
	@(default_calling_convention="c")
	foreign tfd_lib {
		// Conversion helpers. The returned strings live in static buffers.
		tinyfd_utf8toMbcs   :: proc(utf8_string:  cstring) -> cstring ---
		tinyfd_utf16toMbcs  :: proc(utf16_string: cstring16) -> cstring ---
		tinyfd_mbcsTo16     :: proc(mbcs_string:  cstring) -> cstring16 ---
		tinyfd_mbcsTo8      :: proc(mbcs_string:  cstring) -> cstring ---
		tinyfd_utf8to16     :: proc(utf8_string:  cstring) -> cstring16 ---
		tinyfd_utf16to8     :: proc(utf16_string: cstring16) -> cstring ---

		// UTF-16 variants of the dialogs above.
		tinyfd_notifyPopupW :: proc(
			title:     cstring16,
			message:   cstring16,
			icon_type: cstring16,
		) -> c.int ---

		tinyfd_messageBoxW :: proc(
			title:          cstring16,
			message:        cstring16,
			dialog_type:    cstring16,
			icon_type:      cstring16,
			default_button: c.int,
		) -> c.int ---

		tinyfd_inputBoxW :: proc(
			title:         cstring16,
			message:       cstring16,
			default_input: cstring16,
		) -> cstring16 ---

		tinyfd_saveFileDialogW :: proc(
			title:                     cstring16,
			default_path_and_or_file:  cstring16,
			num_of_filter_patterns:    c.int,
			filter_patterns:           [^]cstring16,
			single_filter_description: cstring16,
		) -> cstring16 ---

		tinyfd_openFileDialogW :: proc(
			title:                     cstring16,
			default_path_and_or_file:  cstring16,
			num_of_filter_patterns:    c.int,
			filter_patterns:           [^]cstring16,
			single_filter_description: cstring16,
			allow_multiple_selects:    c.int,
		) -> cstring16 ---

		tinyfd_selectFolderDialogW :: proc(
			title:        cstring16,
			default_path: cstring16,
		) -> cstring16 ---

		tinyfd_colorChooserW :: proc(
			title:           cstring16,
			default_hex_rgb: cstring16,
			default_rgb:     ^RGB,
			result_rgb:      ^RGB,
		) -> cstring16 ---
	}
}

/*
	Helpers for the exported C globals.
*/

// Contents of "tinyfd_version", e.g. "3.22.1".
get_version :: proc() -> cstring {
	return tinyfd_getGlobalChar("tinyfd_version")
}

// Contents of "tinyfd_needs": information about what the platform requires.
get_needs :: proc() -> cstring {
	return tinyfd_getGlobalChar("tinyfd_needs")
}

// Contents of "tinyfd_response": after a "tinyfd_query" call this holds the
// name of the dialog solution that will be used (e.g. "windows_wchar").
get_response :: proc() -> cstring {
	return tinyfd_getGlobalChar("tinyfd_response")
}

// 0 (default) or 1: on Unix, prints the command line calls.
get_verbose :: proc() -> c.int {
	return tinyfd_getGlobalInt("tinyfd_verbose")
}

set_verbose :: proc(value: c.int) -> c.int {
	return tinyfd_setGlobalInt("tinyfd_verbose", value)
}

// 1 (default) or 0: on Unix, hides errors and warnings from called dialogs.
get_silent :: proc() -> c.int {
	return tinyfd_getGlobalInt("tinyfd_silent")
}

set_silent :: proc(value: c.int) -> c.int {
	return tinyfd_setGlobalInt("tinyfd_silent", value)
}

// 0 (default) or 1.
get_allow_curses_dialogs :: proc() -> c.int {
	return tinyfd_getGlobalInt("tinyfd_allowCursesDialogs")
}

set_allow_curses_dialogs :: proc(value: c.int) -> c.int {
	return tinyfd_setGlobalInt("tinyfd_allowCursesDialogs", value)
}

// 0 (default) or 1: force console mode even when a graphic display is present.
get_force_console :: proc() -> c.int {
	return tinyfd_getGlobalInt("tinyfd_forceConsole")
}

set_force_console :: proc(value: c.int) -> c.int {
	return tinyfd_setGlobalInt("tinyfd_forceConsole", value)
}

when ODIN_OS == .Windows {
	// 1 (default) means `char` strings are UTF-8, 0 means MBCS.
	get_win_utf8 :: proc() -> c.int {
		return tinyfd_getGlobalInt("tinyfd_winUtf8")
	}

	set_win_utf8 :: proc(value: c.int) -> c.int {
		return tinyfd_setGlobalInt("tinyfd_winUtf8", value)
	}
}
