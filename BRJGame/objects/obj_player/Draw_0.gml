if(hitColor != 0) {
	draw_set_color(hitColor);
	hitColorTimer--;
	if(hitColorTimer <= 0) {
		hitColor = 0;
	}
} else {
	draw_set_color(#00ff00);
}

draw_circle(x, y, 10, false);
draw_set_color(c_white);

draw_circle_color(x, y, 10 - (Health / HealthMax) * 10, c_red, #880000, false);

var _dirToMouse = point_direction(x, y, mouse_x, mouse_y);

var _handX = mouse_x;
var _handY = mouse_y;

if(point_distance(_handX, _handY, x, y) > handDist) {
	_handX = x + dcos(_dirToMouse) * handDist
	_handY = y - dsin(_dirToMouse) * handDist
}

if(instance_exists(orbLinkFromId)) {
	draw_line_width_color(orbLinkFromId.x, orbLinkFromId.y, _handX, _handY, 3, c_white, c_ltgray);
}