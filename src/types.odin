package main

Cell :: struct {
	x, y:						u32,
	walls:						Block_Set,
	left, right, top, bottom:	bool,
}

Cell_Color :: enum u32 { BLACK = 0, WHITE = 16777215, GREEN = 65280 }

Maze :: struct {
	rows:	u32,
	cols:	u32,
	data:	[dynamic][dynamic]Cell,
	begin, target: [2]u32,
}
