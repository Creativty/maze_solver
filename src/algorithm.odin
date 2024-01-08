package main

import "core:fmt"

Node :: [2]u32

heuristic :: proc(start, destination: Node) -> f32 {
	D :: 10
	start, destination := array_cast(start, f32), array_cast(destination, f32)
	dx, dy := abs(start.x - destination.x), abs(start.y - destination.y)
	return D * (dx + dy)
}

distance :: proc(start, destination: Node) -> u32 {
	return abs(start.x - destination.x) + (start.y - destination.y)
}

find_lowest :: proc(current: Node, nodes: []Node) -> (node: Maybe(Node)) {
	if (len(nodes) == 0) do return nil
	for other, i in nodes {
		switch v in node {
			case Node:
				if distance(current, other) < distance(current, v) {
					node = other
				}
			case:
				node = other
		}
	}
	return
}

check_node :: proc(node: Node, target: Node) {
}

a_star :: proc() {
	target, current: Node

	open_nodes   := make([dynamic]Node)
	closed_nodes := make([dynamic]Node)
	defer {
		delete( open_nodes)
		delete(closed_nodes)
	}

	append(&open_nodes, current)
	for distance(current, target) > 0 {
		lowest := find_lowest(current, open_nodes[:])
		switch v in lowest
		{
			case Node:
				if (distance(v, target) == 0) {
					fmt.println(closed_nodes)
					break
				} else {
					append(&closed_nodes, current)
					
				}
			case:
				fmt.panicf("unreachable\n")
		}
	}
}
