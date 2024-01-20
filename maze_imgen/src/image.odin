package main

import "core:fmt"
import "core:bytes"
import "core:image"
import "core:slice"
import "core:image/netpbm"

Segment :: struct {
	start, end: Coordinate
}

image_render_pixel :: proc(img: ^image.Image, x, y: int)
{
	i := x + (y * img.width)
	if (i >= img.width * img.height || i <= 0) do i = 0
	img.pixels.buf[i] = 0
}

image_render_line :: proc(img: ^image.Image, start, end: Coordinate)
{
	// Bresenham's Algorithm: https://ghost-together.medium.com/how-to-code-your-first-algorithm-draw-a-line-ca121f9a1395
	x, y, xe, ye: int

	x1, y1 := start.x, start.y
	x2, y2 := end.x, end.y
	dx, dy := x2 - x1, y2 - y1

	dx1, dy1 := abs(dx), abs(dy)

	px, py := 2 * dy1 - dx1, 2 * dx1 - dy1

	if dy1 <= dx1 {
		if dx >= 0 {
			x = x1
			y = y1
			xe = x2
		} else {
			x = x2
			y = y2
			xe = x1
		}
		image_render_pixel(img, x, y)
		for i := 0; x < xe; i += 1 {
			x += 1
			if px <= 0 do px += 2 * dy1;
			else {
				if (dx < 0 && dy < 0) || (dx > 0 && dy > 0) do y += 1
				else do y -= 1
				px += 2 * (dy1 - dx1)
			}
			image_render_pixel(img, x, y)
		}
	} else {
		if dy >= 0 {
			y = y1
			x = x1
			ye = y2
		} else {
			y = y2
			x = x2
			ye = y1
		}
		image_render_pixel(img, x, y)
		for i := 0; y < ye; i += 1 {
			y += 1
			if py <= 0 do py += 2 * dx1
			else {
				if (dx < 0 && dy < 0) || (dx > 0 && dy > 0) do x += 1
				else do x -= 1
				py += 2 * (dx1 - dy1)
			}
			image_render_pixel(img, x, y)
		}
	}

}

image_render_segments :: proc(img: ^image.Image, config: Config, segments: []Segment) {
	// Fill image with white pixels
	pixels_len := img.width * img.height
	bytes.buffer_init_allocator(&img.pixels, pixels_len, pixels_len)
	slice.fill(img.pixels.buf[:], 255)

	// Render segments as lines
	for segment in segments do image_render_line(img, segment.start * config.cell_wpx + config.cell_wpx / 2, segment.end * config.cell_hpx + config.cell_hpx / 2)
}

image_generate :: proc(config: Config) -> (img: image.Image)
{
	// Check for valid path
	path := config.path
	if len(path) < 2 {
		fmt.panicf("Cannot generate segments from a short path, path has %d nodes which is less than the required minimum 2.\n", len(path))
	}

	// Generate segments from path
	segments := make([dynamic]Segment)
	defer delete(segments)

	for i in 1..<(len(path)-1) {
		start, end := path[i - 1], path[i]
		append(&segments, Segment{ start, end })
	}
	// Create image
	img.width, img.height = config.image_wpx, config.image_hpx
	img.channels, img.depth, img.which = 1, 8, .NetPBM

	image_render_segments(&img, config, segments[:])
	return
}

image_write :: proc(img: ^image.Image, output_path: string)
{
	err := netpbm.save_to_file(output_path, img)
	if err != nil do fmt.panicf("Could not save to file %s because of %v\n", output_path, err)
}
