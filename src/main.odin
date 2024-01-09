package main

import "core:fmt"
import "core:image"
import "core:strconv"
import "core:math/rand"


import "vendor:raylib"

CELL_SIZE :: 24
WINDOW_ZOOM :: 3

WINDOW_CELL :: CELL_SIZE * WINDOW_ZOOM
WINDOW_WIDTH :: WINDOW_CELL * 12
WINDOW_HEIGHT :: WINDOW_CELL * 8

main :: proc() {
	using raylib

	situation := situation_load("assets/Labyrinthe X.png")

	end := Node{}
	start := Node{}
 	end.x = int(situation.cells_width)  - 1
	end.y = int(situation.cells_height) - 1
	agent := Agent{ start.x, start.y }

	path := path_generate(situation.blocks, start, end)
	defer delete(path)

	path_index  := min(1, len(path))
	steps_count := 0

	// Initialize window
	SetConfigFlags({ ConfigFlag.MSAA_4X_HINT })
	InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "raylib")
	defer CloseWindow()

	SetTargetFPS(60)
	for !WindowShouldClose() {
		agent_update(&agent, path[:], situation.blocks, &steps_count, &path_index)
		if (IsMouseButtonPressed(.LEFT)) {
			position := GetMousePosition()
			cell_pos := position / WINDOW_CELL
			cell_x, cell_y := int(cell_pos.x), int(cell_pos.y)
			map_pos := position / WINDOW_ZOOM
			map_idx := map_pos.x + (map_pos.y * f32(situation.pixels_width))

			fmt.println(map_idx, cell_x, cell_y , situation.blocks[cell_x][cell_y])
		}
		BeginDrawing()
			ClearBackground(RAYWHITE)
			agent_render(agent)
			walls_render(situation.blocks)
			debug_render(path_index, steps_count)
		EndDrawing()
	}
}
