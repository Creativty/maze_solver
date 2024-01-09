package main

import "core:strconv"
import "vendor:raylib"

debug_render :: proc(path_index, steps_count: int) {
	using raylib

	buff := make([]byte, 16)
	defer delete(buff)

	index_str := strconv.itoa(buff, path_index - 1)
	DrawText(slice_to_cstring(buff), 32, 32, 16, PURPLE)

	steps_str := strconv.itoa(buff, steps_count)
	DrawText(slice_to_cstring(buff), 32, 64, 16, PURPLE)
}
