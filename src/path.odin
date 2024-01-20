package main

import "core:fmt"
import "vendor:raylib"

Path :: []Node
Segment :: struct
{
	start, end: [2]int
}

path_to_segments :: proc(path: Path) -> [dynamic]Segment
{
	if len(path) < 2 do fmt.panicf("Cannot generate segments from a short path")

	segments := make([dynamic]Segment)
	for i in 1..<(len(path)-1) {
		end := [2]int{ path[i].x, path[i].y }
		start := [2]int{ path[i - 1].x, path[i - 1].y }
		append(&segments, Segment{ start, end })
	}
	return segments
}

segments_render :: proc(segments: []Segment)
{
	using raylib
	for segment in segments {
		start := segment.start * WINDOW_CELL + (WINDOW_CELL / 2)
		end := segment.end * WINDOW_CELL + (WINDOW_CELL / 2)
		x1, y1 := i32(start.x), i32(start.y)
		x2, y2 := i32(end.x), i32(end.y)
		DrawLine(x1, y1, x2, y2, GREEN)
	}
}
