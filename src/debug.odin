package main

import "core:mem"
import "core:strconv"
import "vendor:raylib"

debug_render :: proc(path_index, steps_count: int, path_running: bool) {
	using raylib

	buff := make([]byte, 32)
	defer delete(buff)

	if path_running {
		mem.copy(raw_data(buff), raw_data(indicator_automatic), 8)
		index_str := strconv.itoa(buff[8:], path_index)
		DrawText(slice_to_cstring(buff), 32, 32, 16, PURPLE)
	} else {
		mem.copy(raw_data(buff), raw_data(indicator_manual), 10)
		steps_str := strconv.itoa(buff[10:], steps_count)
		DrawText(slice_to_cstring(buff), 32, 32, 16, PURPLE)
	}
}
