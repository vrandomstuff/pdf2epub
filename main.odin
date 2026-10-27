// SPDX-License-Identifier: GPL-2.0-or-later

package main

import "core:strings"
import "core:fmt"
import "tfd"
import rl "vendor:raylib"

WIDTH :: 800
HEIGHT :: 600
FONTSIZE :: 30
FONTSPACE :: 3

TextButton :: struct {
	rec:   rl.Rectangle,
	color: rl.Color,
	text:  string,
	id: int // this is not for the ui system it is for the developer to be able to use a switch in a for loop with some sort of enum
}

drawTextButton :: proc(button: TextButton, mouse: rl.Vector2, font: rl.Font) -> bool {
	hovered: bool

	cstr := strings.clone_to_cstring(button.text);
	defer delete(cstr)

	textSize: rl.Vector2 = rl.MeasureTextEx(font, cstr, FONTSIZE, FONTSPACE);

	textPos: rl.Vector2;
	textPos.x = button.rec.x + (button.rec.width - textSize.x) / 2;
	textPos.y = button.rec.y + (button.rec.height - textSize.y) / 2;
	color: rl.Color = button.color;
	
	if (rl.CheckCollisionPointRec(mouse, button.rec)) {
		hovered = true;
		color.r = u8(max(0, int(color.r) - 15))
		color.g = u8(max(0, int(color.g) - 15))
		color.b = u8(max(0, int(color.b) - 15))
	} else {
		hovered = false;
	}
	rl.DrawRectangleRec(button.rec, color);
	
	rl.DrawTextEx(font, cstr, textPos, FONTSIZE, FONTSPACE, rl.WHITE);
	return hovered
}

checkButton :: proc(hovered: bool) -> bool {
	return hovered && rl.IsMouseButtonPressed(rl.MouseButton.LEFT)
}

buttonIds :: enum int {
	SelectEpubOutput,
	SelectPdfInput
}

main :: proc() {
	rl.InitWindow(WIDTH, HEIGHT, "PDF to EPUB")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)
	font := rl.LoadFont("assets/IosevkaNerdFontPropo-SemiBold.ttf");
	defer rl.UnloadFont(font);

	buttons := []TextButton {
		TextButton{
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
		TextButton{
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
			hovered := drawTextButton(button, mouse, font)

			if hovered {
				showButtonCursor = true;
			}

			pressed := checkButton(hovered);
			if(pressed) {
				switch button.id {
					case: fmt.println("TODO: implement press handlers");
				}
			}
		}

		if showButtonCursor {
			rl.SetMouseCursor(rl.MouseCursor.POINTING_HAND);
		} else {
			rl.SetMouseCursor(rl.MouseCursor.DEFAULT);
		}
		rl.EndDrawing();
	}
}
