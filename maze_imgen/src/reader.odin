package main

import "core:io"
import "core:fmt"
import "core:strings"

reader_read_number :: proc(reader: ^strings.Reader) -> (n: int) {
	using strings

	b, size, err := '0', 1, io.Error.None
	for rune_isdigit(b) && err == .None
	{
		offset := int(b - '0')
		n = n * 10 + offset
		b, size, err = reader_read_rune(reader); 
		if (err == .EOF) do return
	}
	if err != .None do fmt.panicf("Could not read number: %v\n", err)
	else do err = reader_unread_rune(reader)

	if err != .None do fmt.panicf("Could not unread rune: %v\n", err)
	return
}

reader_read_combo :: proc(reader: ^strings.Reader) -> (a, b: int, err: io.Error)
{
	size: int
	r_space, r_newline: rune

	a = reader_read_number(reader)
	r_space, size = strings.reader_read_rune(reader) or_return
	if r_space != ' ' do fmt.panicf("Expected ' ' instead got '%v'\n", r_space);
	b = reader_read_number(reader)
	r_newline, size = strings.reader_read_rune(reader) or_return
	if r_newline != '\n' do fmt.panicf("Expected '\\n' instead got '%v'\n", r_newline);
	return
}

rune_isdigit :: proc(r: rune) -> bool {
	return r >= '0' && r <= '9'
}
