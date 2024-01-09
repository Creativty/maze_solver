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

agent_update :: proc(agent: ^Agent, path: []Node, walls: [][]Block_Set, step_count, path_index: ^int) {
	using raylib

	index_path, count_step := path_index^, step_count^

	// Manual Movement
	if IsKeyPressed(.LEFT)  do agent.x -= 1
	if IsKeyPressed(.RIGHT) do agent.x += 1
	if IsKeyPressed(.UP)  do  agent.y -= 1
	if IsKeyPressed(.DOWN) do agent.y += 1
	if IsKeyPressed(.LEFT) || IsKeyPressed(.RIGHT) || IsKeyPressed(.UP) || IsKeyPressed(.DOWN) do count_step += 1

	// A_Star Movement
	if (IsKeyPressed(.SPACE)) {
		if index_path < len(path) {
			if (path[index_path].y - int(agent.y) < 0) {
				slot := path[index_path]
				wall := walls[slot.x][slot.y]
			}
			agent.x = int(path[index_path].x)
			agent.y = int(path[index_path].y)
			index_path = (index_path + 1) % len(path)
		}
	}

	path_index^ = index_path
	step_count^ = count_step
}
