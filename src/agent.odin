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

agent_can_move :: proc(agent: ^Agent, pos: [2]int, walls: [][]Block_Set) -> bool {
	width, height := len(walls), len(walls[0])

	// Maze boundaries
	if pos.x < 0 || pos.x >= width do return false
	if pos.y < 0 || pos.y >= height do return false

	// Walls block
	direction := direction_from_difference([2]int{agent.x, agent.y}, pos)
	return !(direction in walls[agent.x][agent.y])
}

agent_update_manual :: proc(agent: ^Agent, walls: [][]Block_Set, step_count: ^int)
{
	using raylib

	count_step := step_count^

	// Manual Movement
	if IsKeyPressed(.LEFT) && agent_can_move(agent, [2]int{ agent.x - 1, agent.y }, walls) {
		agent.x -= 1
		count_step += 1
	} else if IsKeyPressed(.RIGHT) && agent_can_move(agent, [2]int{ agent.x + 1, agent.y }, walls) {
		agent.x += 1
		count_step += 1
	} else if IsKeyPressed(.UP) && agent_can_move(agent, [2]int{ agent.x, agent.y - 1 }, walls) {
		agent.y -= 1
		count_step += 1
	} else if IsKeyPressed(.DOWN) && agent_can_move(agent, [2]int{ agent.x, agent.y + 1 }, walls) {
		agent.y += 1
		count_step += 1
	}

	step_count^ = count_step
}

agent_update_guided :: proc(agent: ^Agent, state: ^State, path: []Node) {
	if (state.frames_elapsed >= state.frames_per_step) {
		state.frames_elapsed = 0
	} else do return

	agent.x, agent.y = int(path[state.path_index].x), int(path[state.path_index].y)
	state.path_index += 1
	state.path_index = state.path_index % len(path)
}
