package main

import "core:fmt"
import "core:math/rand"
import "core:image"

import "vendor:raylib"

CELL_SIZE :: 24
WINDOW_ZOOM :: 2
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

agent_step :: proc(agent: ^Agent, maze: ^Maze) {
	target := maze.target
}

main :: proc() {
	using raylib

	// Load maze image
	img_maze  := image_load("assets/Labyrinthe X.png")
	defer image.destroy(img_maze)

	// Create Maze from image
	maze := maze_make(img_maze)
	defer maze_delete(maze)

	maze.begin = [2]u32{ 0, 0 }
	maze.target = [2]u32{ maze.rows - 1, maze.cols - 1 }

	agent := Agent{ maze.begin.x, maze.begin.y }

	// Initialize window
	SetConfigFlags({ ConfigFlag.MSAA_4X_HINT })
	InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "raylib")
	defer CloseWindow()
	SetTargetFPS(60)

	// if (IsKeyPressed(.SPACE))
	// {
	// 	agent.x = u32(rand.int_max(int(maze.rows)))
	// 	agent.y = u32(rand.int_max(int(maze.cols)))
	// }
	for !WindowShouldClose() {
		if (IsKeyPressed(.C)) do agent_step(&agent, &maze)
		BeginDrawing()
			ClearBackground(RAYWHITE)
			maze_render(&maze)
			agent_render(agent)
		EndDrawing()
	}
}
