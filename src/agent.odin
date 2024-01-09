package main

import "vendor:raylib"

Agent :: struct {
	x, y: int,
}

agent_render :: proc(agent: Agent) {
	using agent; using raylib

	SIZE :: 16
	screen_x := f32(x) * WINDOW_CELL + (WINDOW_CELL - SIZE) / 2
	screen_y := f32(y) * WINDOW_CELL + (WINDOW_CELL - SIZE) / 2
	DrawRectanglePro(Rectangle{ screen_x, screen_y, SIZE, SIZE}, Vector2{ 0, 0 }, 0, GOLD)
}

agent_update_manual :: proc(agent: ^Agent, walls: [][]Block_Set, step_count: ^int) {
	using raylib

	count_step := step_count^

	// Manual Movement
	if IsKeyPressed(.LEFT)  do agent.x -= 1
	if IsKeyPressed(.RIGHT) do agent.x += 1
	if IsKeyPressed(.UP)  do  agent.y -= 1
	if IsKeyPressed(.DOWN) do agent.y += 1
	if IsKeyPressed(.LEFT) || IsKeyPressed(.RIGHT) || IsKeyPressed(.UP) || IsKeyPressed(.DOWN) do count_step += 1

	step_count^ = count_step
}

agent_update_guided :: proc(agent: ^Agent, path: []Node, path_index: ^int, frames_elapsed: ^int) {
	if (frames_elapsed^ > frames_required) do frames_elapsed^ = 0
	else do return

	index_path := path_index^
	if index_path < len(path) {
		agent.x = int(path[index_path].x)
		agent.y = int(path[index_path].y)
		index_path = (index_path + 1) % len(path)
	}
	path_index^ = index_path
}
