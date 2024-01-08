package main

import "core:fmt"
import "core:image"
import "vendor:raylib"

maze_cell_capture :: proc(pixels: []u32, c_stride, cx, cy: u32) -> (cell: Cell) {
	OFFSET :: CELL_SIZE / 2

	cell.x, cell.y = cx, cy
	stride := c_stride * CELL_SIZE

	pos := [2]u32{ u32(cx), u32(cy) }
	pos *= CELL_SIZE
	pos += OFFSET
	i := int(pos.x + (pos.y * stride))

	if (Cell_Color(pixels[i - OFFSET]) == Cell_Color.BLACK) do cell.walls |= { .East }
	if (Cell_Color(pixels[i + OFFSET]) == Cell_Color.BLACK) do cell.walls |= { .West }

	pos.y -= OFFSET
	i = int(pos.x + (pos.y * stride))
	if (Cell_Color(pixels[i]) == Cell_Color.BLACK) do cell.walls |= { .North }
	pos.y += CELL_SIZE
	i = int(pos.x + (pos.y * stride))
	if (i > len(pixels)) do return
	if (Cell_Color(pixels[i]) == Cell_Color.BLACK) do cell.walls |= { .South }
	if (cell.x == 5 && cell.y == 1) do fmt.println("Target pixel", i, "value", pixels[i])
	
	return
}

maze_make :: proc(img: ^image.Image) -> (maze: Maze) {
	using maze

	// Initialization
	rows  = u32(img.width  / CELL_SIZE)
	cols  = u32(img.height / CELL_SIZE)
	data = make([dynamic][dynamic]Cell, rows)
	for i in 0..<rows do data[i] = make([dynamic]Cell, cols)

	// Parsing
	pixels := image_pixels(img)
	defer delete(pixels)

	// Population
	pixels_slice := pixels[:]
	for col in 0..<cols {
		for row in 0..<rows do data[row][col] = maze_cell_capture(pixels[:], rows, row, col)
	}

	return
}

maze_delete :: proc(maze: Maze) {
	using maze

	for row in data do delete(row)
	delete(data)
}

maze_render :: proc(maze: ^Maze) {
	using raylib

	INDICATOR_SCALE :: 4
	begin := [4]i32{ 
		i32(maze.begin.x) * WINDOW_CELL + (WINDOW_CELL / 2) - (WINDOW_CELL / INDICATOR_SCALE / 2),
		i32(maze.begin.y) * WINDOW_CELL + (WINDOW_CELL / 2) - (WINDOW_CELL / INDICATOR_SCALE / 2),
		WINDOW_CELL / INDICATOR_SCALE,
		WINDOW_CELL / INDICATOR_SCALE,
	}
	target := [4]i32{ 
		i32(maze.target.x) * WINDOW_CELL,
		i32(maze.target.y) * WINDOW_CELL,
		WINDOW_CELL / INDICATOR_SCALE,
		WINDOW_CELL / INDICATOR_SCALE,
	}
	DrawRectangle(begin.x, begin.y, begin[2], begin[3], GREEN)
	DrawRectangle(target.x, target.y, target[2], target[3], RED)
	
	for row in 0..<maze.rows {
		for col in 0..<maze.cols {
			cell := maze.data[row][col]
			x, y := f32(row) * WINDOW_CELL, f32(col) * WINDOW_CELL

			WALL_THICK :: 4
			WALL_COLOR :: BLACK
			if (cell.left) do DrawLineEx(Vector2{x, y}, Vector2{x, y + WINDOW_CELL}, WALL_THICK, WALL_COLOR)
			if (cell.right) do DrawLineEx(Vector2{x + WINDOW_CELL, y}, Vector2{x + WINDOW_CELL, y + WINDOW_CELL}, WALL_THICK, WALL_COLOR)
			if (cell.top) do DrawLineEx(Vector2{x, y}, Vector2{x + WINDOW_CELL, y}, WALL_THICK, WALL_COLOR)
			if (cell.bottom) do DrawLineEx(Vector2{x, y + WINDOW_CELL}, Vector2{x + WINDOW_CELL, y + WINDOW_CELL}, WALL_THICK, WALL_COLOR)
		}
	}
}
