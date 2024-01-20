package main

Direction :: enum { North, East, South, West }

direction_to_text :: proc(direction: Direction) -> string {
	switch direction {
		case .East:
			return "Left"
		case .West:
			return "Right"
		case .North:
			return "Up"
		case .South:
			return "Down"
		case:
			return "Invalid"
	}
}

direction_from_difference :: proc(start, end: [2]int) -> Direction
{
	if (start.x > end.x) do return .East
	if (start.x < end.x) do return .West
	if (start.y > end.y) do return .North
	if (start.y < end.y) do return .South
	return .South
}
