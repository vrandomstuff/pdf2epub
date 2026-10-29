// SPDX-License-Identifier: GPL-2.0-or-later

package main

import "core:fmt"
import "tfd"
import "ui"
import rl "vendor:raylib"

WIDTH :: 800
HEIGHT :: 600

buttonIds :: enum int {
	SelectEpubOutput,
	SelectPdfInput
}

debuggingCheckmark := ui.CheckmarkButton{
	pos = rl.Vector2{
		HEIGHT/2,
		WIDTH/2
	},
	color = rl.GRAY,
	toggled = false,
	icon = {},
	id = 3
}

input: cstring = "";
output: cstring = "";
truncatePath :: proc(path: cstring) -> cstring {
    if path == nil {
        return nil
    }
    
    s := string(path)
    if len(s) == 0 {
        return path
    }
    
    sep_count := 0
    target_idx := 0
    
    for i := len(s) - 1; i >= 0; i -= 1 {
        b := s[i]
        
        is_sep := false
        when ODIN_OS == .Windows {
            is_sep = (b == '/' || b == '\\')
        } else {
            is_sep = (b == '/')
        }
        
        if is_sep {
            sep_count += 1
            if sep_count == 3 {
                target_idx = i + 1
                break
            }
        }
    }
    
    result_str := s[target_idx:]
    if len(result_str) == 0 {
        return cstring("")
    }
    
    return cstring(raw_data(result_str))
}

main :: proc() {
	rl.SetConfigFlags({rl.ConfigFlag.WINDOW_RESIZABLE})
	
	rl.InitWindow(WIDTH, HEIGHT, "PDF to EPUB")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)
	font := rl.LoadFont("assets/IosevkaNerdFontPropo-SemiBold.ttf");
	defer rl.UnloadFont(font);
	checkmarkIcon := rl.LoadTexture("assets/check.png");
	defer rl.UnloadTexture(checkmarkIcon);
	debuggingCheckmark.icon = checkmarkIcon
	
	buttons := []ui.TextButton {
		ui.TextButton{
			rec = rl.Rectangle{
				x      = 0,
				y      = 0,
				width  = 192.25,
				height = 40
			},
			color = rl.GRAY,
			text  = "Select Output",
			id = cast(int)buttonIds.SelectEpubOutput
		},
		ui.TextButton{
			rec = rl.Rectangle{
				x      = 0,
				y      = 50,
				width  = 178,
				height = 40
			},
			color = rl.GRAY,
			text = "Select Input",
			id = cast(int)buttonIds.SelectPdfInput
		}
	}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing();
		
		rl.ClearBackground(rl.BLACK);

		showButtonCursor := false;
		mouse := rl.GetMousePosition();
		for button in buttons {
			hovered := ui.drawTextButton(button, mouse, font)

			if hovered {
				showButtonCursor = true;
			}

			pressed := ui.checkButton(hovered);
			if(pressed) {
				switch button.id {
				case cast(int)buttonIds.SelectPdfInput: {
					filters := [1]cstring{"*.pdf"}
					fileDialog := tfd.tinyfd_openFileDialog(
						"Select PDF",
						nil,
						1,
						&filters[0],
						"PDF files",
						0,
					)
					if fileDialog != nil {
						input = fileDialog
					}
				}
				case cast(int)buttonIds.SelectEpubOutput: {
					filters := [1]cstring{"*.epub"}
					fileDialog := tfd.tinyfd_saveFileDialog(
						"Select output",
						nil,
						1,
						&filters[0],
						"EPUB files",
					)
					if fileDialog != nil {
						output = fileDialog
					}
				}
				}
			}

			rl.DrawTextEx(font, truncatePath(output), rl.Vector2{212.25, 0}, ui.FONTSIZE, ui.FONTSPACE, rl.WHITE);
			rl.DrawTextEx(font, truncatePath(input), rl.Vector2{198, 50}, ui.FONTSIZE, ui.FONTSPACE, rl.WHITE);
		}
		
		hovered := ui.drawCheckmarkButton(debuggingCheckmark, mouse);
		ui.checkCheckmarkButton(&debuggingCheckmark, hovered);
		if showButtonCursor {
			rl.SetMouseCursor(rl.MouseCursor.POINTING_HAND);
		} else {
			rl.SetMouseCursor(rl.MouseCursor.DEFAULT);
		}
		rl.EndDrawing();
	}
}
