package main

import "core:io"

writer_write_entry :: proc(stream: io.Stream, a, b: int)
{
	io.write_int(stream, a)
	io.write_rune(stream, ' ')
	io.write_int(stream, b)
	io.write_byte(stream, byte('\n'))
}

writer_write_config :: proc(stream: io.Stream, image_dimensions, cell_dimensions: [2]int)
{
	writer_write_entry(stream, image_dimensions.x, image_dimensions.y)
	writer_write_entry(stream, image_dimensions.x / cell_dimensions.x, image_dimensions.y / cell_dimensions.y)
}

writer_write_path :: proc(stream: io.Stream, path: Path)
{
	for step in path do writer_write_entry(stream, step.x, step.y)
}
