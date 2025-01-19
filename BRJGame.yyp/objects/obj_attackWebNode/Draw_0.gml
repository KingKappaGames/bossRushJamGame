draw_self();

if(duration < 42) { // 42 frames of warning
	with(obj_attackWebNode) {
		if(id != other.id) {
			draw_line_width(x, y, other.x, other.y, 4);
		}
	}
}