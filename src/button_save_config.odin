package main

import "core:fmt"
import "vendor:raylib"

Button_Save_Config :: struct {
	bg, fg: raylib.Color,
	bg_hover: raylib.Color,
	px, py: i32,
	x, y, w, h: i32,
	text: cstring,

	is_hover: bool,
}

button_create_save_config :: proc(text: cstring, x, y: i32, bg := raylib.DARKGRAY, fg := raylib.WHITE, bg_hover := raylib.GRAY, px : i32 = 16, py : i32 = 8) -> (button: Button_Save_Config)
{
	using raylib

	button.x, button.y = x, y

	font := GetFontDefault()
	text_measurement := MeasureTextEx(
		font, text, TEXT_SIZE, 1.0
	)
	button.w, button.h = i32(text_measurement.x), i32(text_measurement.y)

	button.px, button.py = px, py

	button.text   = text
	button.bg_hover   = bg_hover
	button.bg, button.fg   = bg, fg

	button.is_hover = false

	return button
}

button_on_click_save_config :: proc()
{
	fmt.println("button_on_click_save_config")
}

button_update_save_config :: proc(button: ^Button_Save_Config)
{
	using button
	using raylib

	mouse := GetMousePosition()
	rectangle := Rectangle{ f32(x), f32(y), f32(w + px), f32(h + py) }

	is_hover = CheckCollisionPointRec(mouse, rectangle)
	if is_hover && IsMouseButtonPressed (.LEFT) do button_on_click_save_config()
}

button_render_save_config :: proc(button: ^Button_Save_Config)
{
	using button
	using raylib

	rectangle := Rectangle{ f32(x), f32(y), f32(w + px * 2), f32(h + py * 2) }
	DrawRectangleRec(
		rectangle,
		bg_hover if is_hover else bg
	)
	DrawRectangleLines(x, y, w + px * 2, h + py * 2, fg)
	DrawText(text, x + (px / 3 * 2), y + py, TEXT_SIZE, WHITE)
}
