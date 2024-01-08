package main

import "core:fmt"
import "core:bytes"
import "core:image"
import "core:image/png"

image_load :: proc(#const filepath: string) -> (img: ^image.Image) {
	img_err: image.Error
	img, img_err = png.load_from_file(filepath)
	if img_err != nil do fmt.panicf("Could not load \"Chemins X.png\" ::", img_err)
	return
}

image_pixels :: proc(img: ^image.Image) -> (pixels: [dynamic]u32) {
	pixels    = make([dynamic]u32)
	unpacked := bytes.buffer_to_bytes(&img.pixels)
	
	for i := 0; i < len(unpacked); i += 3 {
		r, g, b := unpacked[i], unpacked[i + 1], unpacked[i + 2]
		pixel := u32(r)
		pixel = (pixel << 8) | u32(g)
		pixel = (pixel << 8) | u32(b)
		append(&pixels, pixel)
	}
	return
}

cell_pos_to_pixel_pos :: proc(stride, x, y: u32) -> u32
{
	return (x * CELL_SIZE) + (CELL_SIZE * y * stride)
}
