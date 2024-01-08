package main

// maze_cell_capture :: proc(pixels: []u32, stride_in_cells, cell_row, cell_col: u32) -> (cell: Cell) {
// 	using cell
// 
// 	// Fill coordinates
// 	x = cell_row
// 	y = cell_col
// 
// 	// Fill walls with true
// 	top = true
// 	left = true
// 	right = true
// 	bottom = true
// 	
// 	// Calculate screen space positions
// 	pixel_x, pixel_y := cell_row * CELL_SIZE, cell_col * CELL_SIZE
// 	pixel_i := (pixel_y * stride_in_cells) + pixel_x
// 	for dt in 0..<CELL_SIZE {
// 		top_i := pixel_i + u32(dt)
// 		left_i := pixel_i + (u32(dt) * (CELL_SIZE * stride_in_cells))
// 		right_i := pixel_i + ((CELL_SIZE - 1) + (u32(dt)) * (CELL_SIZE * stride_in_cells))
// 
// 		if pixels[top_i] == u32(Cell_Color.WHITE) do top = false
// 		if pixels[left_i] == u32(Cell_Color.WHITE) do left = false
// 		if pixels[right_i] == u32(Cell_Color.GREEN) do right = false
// 
// 		bx := (cell_row * CELL_SIZE) + u32(dt)
// 		by := ((cell_col + 1) * (CELL_SIZE - 1))
// 		bottom_i := bx + by * stride_in_cells
// 		if pixels[bottom_i] != u32(Cell_Color.WHITE) do bottom = false
// 	}
// 	return
// }
