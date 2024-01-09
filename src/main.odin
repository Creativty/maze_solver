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
WINDOW_TOOLBAR_HEIGHT :: WINDOW_CELL / 2
WINDOW_HEIGHT :: WINDOW_CELL * 8 + WINDOW_TOOLBAR_HEIGHT

main :: proc() {
	using raylib

	situation := situation_load("assets/Labyrinthe X.png")

	start, end: Node
 	end.x  = situation.cells_width  - 1
	end.y  = situation.cells_height - 1
	agent := Agent{ start.x, start.y }

	path := path_generate(situation.blocks, start, end)
	defer delete(path)

	steps_count    := 0
	path_running   := false
	frames_elapsed := 0
	path_index     := min(1, len(path))

	// Initialize window
	SetConfigFlags({ ConfigFlag.MSAA_4X_HINT })
	InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "raylib")
	defer CloseWindow()

	SetTargetFPS(60)
	for !WindowShouldClose() {
		if path_running do agent_update_guided(&agent, path[:], &path_index, &frames_elapsed)
		else do agent_update_manual(&agent, situation.blocks, &steps_count)
		if IsKeyDown(.UP) do frames_required += 1
		if IsKeyDown(.DOWN) do frames_required -= 1
		if frames_required <= 10 do frames_required = 10
		if IsKeyPressed(.SPACE) do path_running = !path_running
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
			toolbar_render(path_index, steps_count, path_running)
		EndDrawing()
		frames_elapsed += 1
	}
}
