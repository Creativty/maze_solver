package main

import "core:fmt"
import "core:image"
import "vendor:raylib"

@(private="file")
pixel_is_wall :: proc(pixel: u32) -> bool {
	return Cell_Color(pixel) == .BLACK
}

wall_from_pixels :: proc(x, y: int, pixels: []u32, width: int, wall_size := CELL_SIZE) -> (wall: Block_Set) {
	center := [2]int{ x, y } * wall_size
	offset, stride :=  wall_size / 2, width * wall_size
{
	center += offset
	index  := center.x + (center.y * stride)
	if pixel_is_wall(pixels[index - offset]) do wall |= { .East }
	if pixel_is_wall(pixels[index + offset]) do wall |= { .West }
}
{
	center -= [2]int{ 0, offset }
 	index  := int(center.x + (center.y * stride))
	if pixel_is_wall(pixels[index]) do wall |= { .North }
}
{
	center += [2]int{ 0, wall_size }
 	index  := int(center.x + (center.y * stride))
	if index < len(pixels) && pixel_is_wall(pixels[index]) do wall |= { .South }
}
	return
}

walls_load :: proc(img: ^image.Image, img_cell_size : int = CELL_SIZE) -> (walls: [][]Block_Set, width, height: int) {
	// Dimensions
	width  = img.width  / img_cell_size
	height = img.height / img_cell_size
	// Allocation
	walls  = make([][]Block_Set, width)
	for &row in walls do row = make([]Block_Set, height)
	// Image from (r, g, b, a)[] to rgba[]
	pixels := image_pixels(img)
	defer delete(pixels)
	// Parsing
	for x in 0..<width {
		for y in 0..<height {
			walls[x][y] = wall_from_pixels(x, y, pixels[:], width, img_cell_size)
		}
	}
	fmt.println("walls_load ", len(walls), len(walls[0]))
	return
}

walls_render :: proc(walls: [][]Block_Set) {
	using raylib

	for row, x_ in walls {
		for wall, y_ in row {
			x, y := f32(x_) * WINDOW_CELL, f32(y_) * WINDOW_CELL

			WALL_THICK :: 1
			WALL_COLOR :: BLACK
			if (.East in wall) do DrawLineEx(Vector2{x, y}, Vector2{x, y + WINDOW_CELL}, WALL_THICK, WALL_COLOR)
			if (.West in wall) do DrawLineEx(Vector2{x + WINDOW_CELL, y}, Vector2{x + WINDOW_CELL, y + WINDOW_CELL}, WALL_THICK, WALL_COLOR)
			if (.North in wall) do DrawLineEx(Vector2{x, y}, Vector2{x + WINDOW_CELL, y}, WALL_THICK, WALL_COLOR)
			if (.South in wall) do DrawLineEx(Vector2{x, y + WINDOW_CELL}, Vector2{x + WINDOW_CELL, y + WINDOW_CELL}, WALL_THICK, WALL_COLOR)
		}
	}
}
