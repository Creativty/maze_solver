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

Agent :: struct {
	x, y: u32,
}

agent_render :: proc(agent: Agent) {
	using agent; using raylib
	SIZE :: 16

	screen_x := f32(x) * WINDOW_CELL + WINDOW_CELL / 2 - SIZE / 2
	screen_y := f32(y) * WINDOW_CELL + WINDOW_CELL / 2 - SIZE / 2
	DrawRectanglePro(Rectangle{ screen_x, screen_y, SIZE, SIZE}, Vector2{ 0, 0 }, 0, GOLD)
}

maze_temp_render :: proc(rows: [][]Block_Set) {
	using raylib
	for row, x_ in rows {
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

main :: proc() {
	using raylib

	// Load maze image
	img_maze  := image_load("assets/Labyrinthe X.png")
	defer image.destroy(img_maze)

	// Create Maze from image
	maze := maze_make(img_maze)
	defer maze_delete(maze)

	maze_walls := make([][]Block_Set, maze.rows)
	defer delete(maze_walls)

	for row, y in maze.data {
		maze_walls[y] = make([]Block_Set, len(row))
		for cell, x in row {
			maze_walls[cell.x][cell.y] = cell.walls
		}
	}

	maze.begin = [2]u32{ 0, 0 }
	maze.target = [2]u32{ maze.rows - 1, maze.cols - 1 }

	agent := Agent{ maze.begin.x, maze.begin.y }
	start, end: Node
	start.x, start.y = int(agent.x), int(agent.y)
	end.x, end.y = int(maze.target.x), int(maze.target.y)

	path := path_generate(maze_walls, start, end)
	defer delete(path)
	path_index := min(1, len(path))

	// Initialize window
	SetConfigFlags({ ConfigFlag.MSAA_4X_HINT })
	InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "raylib")
	defer CloseWindow()
	SetTargetFPS(60)

	fmt.println("Length :: ", len(path))
	steps_count := 0

	for !WindowShouldClose() {
		if IsKeyPressed(.LEFT)  do agent.x -= 1
		if IsKeyPressed(.RIGHT) do agent.x += 1
		if IsKeyPressed(.UP)  do  agent.y -= 1
		if IsKeyPressed(.DOWN) do agent.y += 1
		if IsKeyPressed(.LEFT) || IsKeyPressed(.RIGHT) || IsKeyPressed(.UP) || IsKeyPressed(.DOWN) do steps_count += 1
		if (IsKeyPressed(.SPACE)) {
			if path_index < len(path) {
				if (path[path_index].y - int(agent.y) < 0) {
					slot := path[path_index]
					wall := maze_walls[slot.x][slot.y]
					fmt.println(wall)
				}
				agent.x = u32(path[path_index].x)
				agent.y = u32(path[path_index].y)
				path_index = (path_index + 1) % len(path)
			}
		}
		if (IsMouseButtonPressed(.LEFT)) {
			position := GetMousePosition()
			cell_pos := position / WINDOW_CELL
			cell_x, cell_y := int(cell_pos.x), int(cell_pos.y)
			map_pos := position / WINDOW_ZOOM
			map_idx := map_pos.x + (map_pos.y * f32(img_maze.width))

			fmt.println(map_idx, cell_x, cell_y , maze_walls[cell_x][cell_y])
		}
		BeginDrawing()
			ClearBackground(RAYWHITE)
			// maze_render(&maze)
			maze_temp_render(maze_walls)
			agent_render(agent)
			buff: [8]byte
			index_str := strconv.itoa(buff[:], path_index - 1)
			DrawText(cstring(raw_data(buff[:])), 32, 32, 16, PURPLE)
			steps_str := strconv.itoa(buff[:], steps_count)
			DrawText(cstring(raw_data(buff[:])), 32, 64, 16, PURPLE)
		EndDrawing()
	}
}
