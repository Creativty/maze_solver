package main

import "core:os"
import "core:fmt"
import "core:image"
import "core:strconv"
import "core:math/rand"

import "vendor:raylib"

CELL_SIZE :: 24
WINDOW_ZOOM :: 2
WINDOW_CELL :: CELL_SIZE * WINDOW_ZOOM

WINDOW_MAZE_WIDTH  :: WINDOW_CELL * 12
WINDOW_MAZE_HEIGHT :: WINDOW_CELL * 8

WINDOW_TOOLBAR_WIDTH  :: WINDOW_MAZE_WIDTH
WINDOW_TOOLBAR_HEIGHT :: WINDOW_CELL

WINDOW_SIDEBAR_WIDTH :: WINDOW_CELL * 4
WINDOW_SIDEBAR_HEIGHT :: WINDOW_HEIGHT

WINDOW_WIDTH  :: WINDOW_MAZE_WIDTH + WINDOW_SIDEBAR_WIDTH
WINDOW_HEIGHT :: WINDOW_MAZE_HEIGHT + WINDOW_TOOLBAR_HEIGHT

WALL_THICK :: 2
WALL_COLOR :: raylib.BLACK

TEXT_SIZE :: 8
TEXT_COLOR :: raylib.BLACK

FRAMES_PER_STEP_MAX :: 300
FRAMES_PER_STEP :: 24
FRAMES_PER_STEP_MIN :: 1

CONFIG_PATH :: "/home/abderrahim/Github/maze_imgen/config_complete.dat"

State :: struct {
	path_index: 		int,
	frames_elapsed:		int,
	frames_per_step:	int,
	manual_steps_taken:	int,
	agent: 				Agent,
	is_controlled:		bool,
}

update :: proc(state: ^State, situation: Situation, path: []Node)
{
	using raylib
	using state
	
	if IsKeyPressed(.SPACE) { // Switch control mode
		path_index = 0
		frames_elapsed = 0
		frames_per_step = FRAMES_PER_STEP
		manual_steps_taken = 0
		agent.x, agent.y = 0, 0
		is_controlled = !is_controlled
		return
	}

	if !is_controlled { // Automatic steps
		agent_update_guided(&agent, state, path)
		if IsKeyDown(.UP) do frames_per_step += 1
		if IsKeyDown(.DOWN) do frames_per_step -= 1
	} else { // Manual steps
		agent_update_manual(&agent, situation.blocks, &manual_steps_taken)
	}

	frames_per_step = clamp(FRAMES_PER_STEP_MIN, frames_per_step, FRAMES_PER_STEP_MAX)
	frames_elapsed += 1
}

main :: proc() {
	using raylib

	state: State
	situation := situation_load("assets/Labyrinthe X.png")

	start, end: Node
 	end.x  = situation.cells_width  - 1
	end.y  = situation.cells_height - 1
	agent := Agent{ start.x, start.y }

	path := path_generate(situation.blocks, start, end)
	defer delete(path)

	segments := path_to_segments(path[:])
	defer delete(segments)

	fmt.println(segments)

	// Write configuration for maze_imgen
	fd, errno := os.open(CONFIG_PATH, os.O_RDWR, 0o777)
	stream := os.stream_from_handle(fd)
	writer_write_config(
		stream,
		[2]int{ situation.pixels_width, situation.pixels_height },
		[2]int{ situation.cells_width, situation.cells_height }
	)
	writer_write_path(
		stream,
		path[:]
	)
	os.close(fd)

	// Initialize window
	SetConfigFlags({ ConfigFlag.MSAA_4X_HINT })
	InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "raylib")
	defer CloseWindow()

	save_button := button_create_save_config(
		"Sauvgarder",
		WINDOW_MAZE_WIDTH + TEXT_SIZE, 0
	)

	SetTargetFPS(60)
	for !WindowShouldClose() {
		update(&state, situation, path[1:])
		button_update(&save_button)
		BeginDrawing()
			ClearBackground(WHITE)
			walls_render(situation.blocks)
			segments_render(segments[:])
			agent_render(state.agent)
			sidebar_render(&state, path[1:])
			button_render(&save_button)
			toolbar_render(&state)
			DrawRectangle(WINDOW_CELL * 11, WINDOW_CELL * 7, WINDOW_CELL, WINDOW_CELL, GREEN)
		EndDrawing()
		free_all(context.temp_allocator)
	}
}
