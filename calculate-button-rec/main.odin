// SPDX-License-Identifier: GPL-2.0-or-later

package generateRecWithPadding

import "core:fmt"
import rl "vendor:raylib"

FONTSIZE :: 30
FONTSPACE :: 3
PADX :: 5
PADY :: 5
FONTPATH :: "../assets/IosevkaNerdFontPropo-SemiBold.ttf"
TEXT :: "Select Input"

main :: proc() {
	rl.SetTraceLogLevel(rl.TraceLogLevel.WARNING);
	rl.InitWindow(1,1,"init gpu lol");
	defer rl.CloseWindow();
	font := rl.LoadFont(FONTPATH);
	defer rl.UnloadFont(font);

	textSize: rl.Vector2 = rl.MeasureTextEx(font, TEXT, FONTSIZE, FONTSPACE);

	textSize.x += PADX * 2 // PADX * 2 is to cover both sides
	textSize.y += PADY * 2
	fmt.printf("rec = rl.Rectangle{{\n");
	fmt.printf("	x = 0,\n");
	fmt.printf("	y = 0,\n");
	fmt.printf("	width = %v,\n", textSize.x);
	fmt.printf("	height = %v\n", textSize.y);
	fmt.printf("}}\n");
}
