package main

import "core:strings"
import "vendor:raylib"

sidebar_render :: proc(state: ^State, path: Path)
{
	using raylib
	
	DrawRectangleRec( // Background
		Rectangle{ 
			WINDOW_MAZE_WIDTH, 0,
			WINDOW_SIDEBAR_WIDTH, WINDOW_SIDEBAR_HEIGHT
		},
		RAYWHITE
	)

	node := path[(state.manual_steps_taken % len(path))]
	direction := direction_from_difference(
		[2]int{ state.agent.x, state.agent.y },
		[2]int{ node.x, node.y }
	)
	direction_text := direction_to_text(direction)
	DrawText(
		strings.clone_to_cstring(direction_text),
		WINDOW_MAZE_WIDTH + TEXT_SIZE,
		WINDOW_SIDEBAR_HEIGHT / 2 - TEXT_SIZE / 2,
		TEXT_SIZE,
		TEXT_COLOR,
	)
}
