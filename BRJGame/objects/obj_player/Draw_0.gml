var _alphaFlash = 1;
if(immunityFrames > 0) {
	_alphaFlash = .4 + round(current_time % 250 / 250) * .6; // flashing while immune
}

draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, directionFacing - 90, image_blend, image_alpha * _alphaFlash);
draw_set_alpha(1);
draw_set_color(c_white); // undo hit and immune visual effects

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