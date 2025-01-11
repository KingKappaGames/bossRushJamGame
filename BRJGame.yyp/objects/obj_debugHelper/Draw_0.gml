if(image_blend != c_white) {
	draw_set_color(image_blend);
}
if(shape == "circle") {
	draw_circle(x, y, radius, true);
} else if(shape == "line") {
	draw_line(x, y, xGoal, yGoal);
} else if(shape == "quadRect") {
	draw_rectangle(quadLeft, quadTop, quadRight, quadBottom, true);
}

if(image_blend != c_white) {
	draw_set_color(c_white);
}