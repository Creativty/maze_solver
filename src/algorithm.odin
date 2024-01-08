package main

import "core:fmt"

Direction :: enum { North, East, South, West }
Block_Set :: bit_set[Direction]

Node :: struct {
	x, y: int,
	f, g, h: int,
	parent: ^Node,
}

reverse_slice :: proc(slice: $T/[]$E) -> T {
	end := len(slice) - 1
	for i in 0..<len(slice) / 2 {
		temp := slice[i]
		slice[i] = slice[end - i]
		slice[end - i] = temp
	}
	return slice
}

pow :: proc(base, exp: int) -> f64 {
	total : f64 = 1
	for i in 0..<exp do total *= f64(base)
	return total
}

distance :: proc(a, b: Node) -> int {
	return abs(a.x - b.x) + abs(a.y - b.y)
}

find_lowest_f :: proc(list: []Node, maze: [][]Block_Set, start, end: Node) -> (Node, int) {
	found_node, found_index := list[0], 0
	for node, idx in list {
		if node.f < found_node.f {
			found_node = node
			found_index = idx
		}
	}
	return found_node, found_index
}

path_generate :: proc(maze: [][]Block_Set, start, end: Node) -> [dynamic]Node {
	M := len(maze); N := len(maze[0])
	path := make([dynamic]Node)
	deltas := [4][2]int{ { 1, 0 }, { 0, 1 }, {-1, 0 }, { 0,-1 } }
	open_list, closed_list := make([dynamic]Node), make([dynamic]Node)

	append(&open_list, start)
	search: for len(open_list) > 0 {
		current_node, current_index := find_lowest_f(open_list[:], maze, start, end)
		current_clone := new_clone(current_node)
		unordered_remove(&open_list, current_index)

		children := make([dynamic]Node, context.temp_allocator)
		for delta in deltas {
			x := current_node.x + delta.x
			y := current_node.y + delta.y

			if !(x >= 0 && x < M) do continue
			if !(y >= 0 && y < N) do continue
			if delta.x > 0 && .East in maze[x][y] do continue
			if delta.x < 0 && .West in maze[x][y] do continue
			if delta.y > 0 && .North in maze[x][y] do continue
			if delta.y < 0 && .South in maze[x][y] do continue

			child := Node{ x, y, 0, 0, 0, current_clone }
			append(&children, child)
		}
		adjacents: for &child, i in children {
			dist_to_end := distance(child, end)
			if dist_to_end == 0 {
				clear(&path)
				for node := &child; node != nil; node = node.parent do append(&path, node^)
				reverse_slice(path[:])
				break search
			} else {
				child.g = current_node.g + distance(child, current_node)
				child.h = distance(child, end)
				child.f = child.g + child.h

				for open_memb in open_list do if distance(open_memb, child) == 0 && open_memb.f < child.f do continue adjacents
				for close_memb in closed_list {
					if distance(close_memb, child) == 0 {
						if close_memb.f < child.f do continue adjacents
					}
				}
				append(&open_list, child)
			}
		}
		free_all(context.temp_allocator)
		append(&closed_list, current_node)
	}

	delete(open_list)
	delete(closed_list)
	return path
}
