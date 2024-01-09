package main

import "core:mem"
import "core:strconv"
import "vendor:raylib"

indicator_manual := "Manual :: "
indicator_frames := "Frames per step ::              "
indicator_automatic := "Auto :: "
frames_required := 45

toolbar_render :: proc(path_index, steps_count: int, path_running: bool) {
	using raylib

	buff := make([]byte, 32)
	defer delete(buff)

	if path_running {
		mem.copy(raw_data(buff), raw_data(indicator_automatic), 8)
		strconv.itoa(buff[8:], path_index)
		DrawText(slice_to_cstring(buff), 32, WINDOW_HEIGHT - WINDOW_TOOLBAR_HEIGHT, 16, BLACK)
	} else {
		mem.copy(raw_data(buff), raw_data(indicator_manual), 10)
		strconv.itoa(buff[10:], steps_count)
		DrawText(slice_to_cstring(buff), 32, WINDOW_HEIGHT - WINDOW_TOOLBAR_HEIGHT, 16, BLACK)
	}

	mem.copy(raw_data(buff), raw_data(indicator_frames), 32)
	strconv.itoa(buff[19:], frames_required)
	DrawText(slice_to_cstring(buff), WINDOW_WIDTH - (8 * 32), WINDOW_HEIGHT - WINDOW_TOOLBAR_HEIGHT, 16, BLACK)
}
