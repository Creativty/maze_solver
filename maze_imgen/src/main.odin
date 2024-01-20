package main

import "core:io"
import "core:os"
import "core:fmt"
import "core:bytes"
import "core:strings"

Coordinate :: [2]int

Config :: struct {
	image_wpx, image_hpx: int,
	cell_wpx, cell_hpx: int,
	path: [dynamic]Coordinate,
}

print_usage :: proc(progname: string)
{
	fmt.println(progname, "was incorrectly called.");
	fmt.printf("Usage: %s <config_path> <output_path>\n", progname)
}

parse_configuration :: proc(config_path: string) -> (config: Config)
{
	// Open and read file
	config_bytes, ok := os.read_entire_file_from_filename(config_path)
	defer if ok do delete(config_bytes)
	if !ok do fmt.panicf("Could not read file: %s\n", config_path);
	config_string := transmute(string)config_bytes
	// Parse the loaded string
	reader: strings.Reader
	strings.reader_init(&reader, config_string)

	a, b: int
	err: io.Error

	// Read image dimensions
	a, b, err = reader_read_combo(&reader)
	if err != .None do fmt.panicf("Could not read image dimensions: %v\n")
	config.image_wpx, config.image_hpx = a, b

	// Read cell dimensions
	a, b, err = reader_read_combo(&reader)
	if err != .None do fmt.panicf("Could not read cell dimensions: %v\n")
	config.cell_wpx, config.cell_hpx = a, b

	// Read path nodes
	config.path = make([dynamic]Coordinate)
	for err == .None {
		a, b, err = reader_read_combo(&reader)
		append(&config.path, [2]int{ a, b })
	}

	if !(err == .None || err == .EOF) do fmt.panicf("Could not read coords: %v\n", err)
	return
}

main :: proc()
{
	// Arguments
	args := os.args
	if len(args) != 3 {
		print_usage(args[0])
		return
	}
	// Parse configuration
	config_path := args[1]
	config := parse_configuration(config_path)
	defer delete(config.path) // Cleanup no longer used memory
	// Image generation
	img := image_generate(config)
	defer bytes.buffer_destroy(&img.pixels)
	// Image writing
	output_path := args[2]
	image_write(&img, output_path)
}
