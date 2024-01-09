package main

import "core:fmt"
import "core:image"

Situation :: struct {
	blocks: [][]Block_Set,
	cells_width, cells_height: int,
	pixels_width, pixels_height: int,
}

Cell_Color :: enum u32 { BLACK = 0, WHITE = 16777215, GREEN = 65280 }

situation_load :: proc(#const filepath: string) -> (situation: Situation) {
	// Load maze image
	img  := image_load("assets/Labyrinthe X.png")
	defer image.destroy(img)

	situation.pixels_width, situation.pixels_height = img.width, img.height
	situation.blocks, situation.cells_width, situation.cells_height = walls_load(img, CELL_SIZE)

	return
}
