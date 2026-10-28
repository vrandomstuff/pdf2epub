// SPDX-License-Identifier: GPL-2.0-or-later

package ui

import "core:strings"
import rl "vendor:raylib"

FONTSIZE :: 30
FONTSPACE :: 3

TextButton :: struct {
	rec:   rl.Rectangle,
	color: rl.Color,
	text:  string,
	id: int // this is not for the ui system it is for the developer to be able to use a switch in a for loop with some sort of enum
}

CheckmarkButton :: struct {
	pos: rl.Vector2,
	color: rl.Color,
	icon: rl.Texture2D,
	toggled: bool,
	id: int
}

drawTextButton :: proc(button: TextButton, mouse: rl.Vector2, font: rl.Font) -> bool {
	hovered: bool;

	cstr := strings.clone_to_cstring(button.text);
	defer delete(cstr);

	textSize: rl.Vector2 = rl.MeasureTextEx(font, cstr, FONTSIZE, FONTSPACE);

	textPos: rl.Vector2;
	textPos.x = button.rec.x + (button.rec.width - textSize.x) / 2;
	textPos.y = button.rec.y + (button.rec.height - textSize.y) / 2;
	color: rl.Color = button.color;
	
	if (rl.CheckCollisionPointRec(mouse, button.rec)) {
		hovered = true;
		color.r = u8(max(0, int(color.r) - 15));
		color.g = u8(max(0, int(color.g) - 15));
		color.b = u8(max(0, int(color.b) - 15));
	} else {
		hovered = false;
	}
	rl.DrawRectangleRec(button.rec, color);
	
	rl.DrawTextEx(font, cstr, textPos, FONTSIZE, FONTSPACE, rl.WHITE);
	return hovered;
}

drawCheckmarkButton :: proc(button: CheckmarkButton, mouse: rl.Vector2) -> bool {
	hovered: bool;
	rec: rl.Rectangle;
	color: rl.Color = button.color;

	rec.x = button.pos.x;
	rec.y = button.pos.y;
	rec.width = 50;
	rec.height = 50;

	checkPos: rl.Vector2;
	
	checkPos.x = rec.x + (rec.width - f32(button.icon.width)) / 2;
	checkPos.y = rec.y + (rec.height - f32(button.icon.height)) / 2;
	
	if (rl.CheckCollisionPointRec(mouse, rec)) {
		hovered = true;
		color.r = u8(max(0, int(color.r) - 15));
		color.g = u8(max(0, int(color.g) - 15));
		color.b = u8(max(0, int(color.b) - 15));
	} else {
		hovered = false;
	}
	
	rl.DrawRectangleRec(rec, color);
	if(button.toggled) {
		rl.DrawTextureV(button.icon, checkPos, rl.WHITE);
	}
	
	return hovered;
}

checkButton :: proc(hovered: bool) -> bool {
	return hovered && rl.IsMouseButtonReleased(rl.MouseButton.LEFT)
}

checkCheckmarkButton :: proc(button: ^CheckmarkButton, hovered: bool) -> bool {
	pressed := checkButton(hovered);
	
	if(pressed) {
		button.toggled = !button.toggled;
	}
	
	return pressed;
}
