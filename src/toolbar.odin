package main

import "core:fmt"
import "core:mem"
import "core:strings"
import "core:strconv"
import "vendor:raylib"

toolbar_render_text :: proc(text: string, pos: [2]int)
{
	using raylib
	DrawText(
		strings.clone_to_cstring(text),
		i32(pos.x),
		WINDOW_HEIGHT - WINDOW_TOOLBAR_HEIGHT + i32(pos.y),
		TEXT_SIZE,
		TEXT_COLOR,
	)
}

toolbar_render_label :: proc(label: string, value: int, pos: [2]int)
{
	using raylib
	label_len := len(label)

	buff := make([]byte, label_len + 16)
	defer delete(buff)

	mem.copy(raw_data(buff), raw_data(label), label_len)
	strconv.itoa(buff[label_len:], value)

	DrawText(
		cstring(raw_data(buff)),
		i32(pos.x),
		WINDOW_HEIGHT - WINDOW_TOOLBAR_HEIGHT + i32(pos.y),
		TEXT_SIZE,
		TEXT_COLOR,
	)
}

toolbar_render :: proc(state: ^State) {
	using raylib

	if !state.is_controlled {
		toolbar_render_label(
			"Mode automatic at step ",
			state.path_index,
			[2]int{TEXT_SIZE * 2, TEXT_SIZE }
		)
	} else {
		toolbar_render_label(
			"Mode controlled at step ",
			state.manual_steps_taken,
			[2]int{TEXT_SIZE * 2, TEXT_SIZE }
		)
	}

	toolbar_render_text(
		fmt.tprintf(
			"Speed %d/%d",
			state.frames_per_step,
			FRAMES_PER_STEP_MAX
		),
		[2]int{WINDOW_WIDTH / 2 + TEXT_SIZE * 2, TEXT_SIZE }
	)
	DrawRectangleLinesEx(
		Rectangle{ 
			0, WINDOW_MAZE_HEIGHT,
			WINDOW_TOOLBAR_WIDTH + 1, WINDOW_TOOLBAR_HEIGHT + 1
		},
		WALL_THICK, WALL_COLOR
	)
}
