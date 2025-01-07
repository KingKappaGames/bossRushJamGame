#region movement and controls
if(keyboard_check(ord("W"))) {
	yChange -= moveSpeed;
}

if(keyboard_check(ord("S"))) {
	yChange += moveSpeed;
}

if(keyboard_check(ord("A"))) {
	xChange -= moveSpeed;
}

if(keyboard_check(ord("D"))) {
	xChange += moveSpeed;
}

x = clamp(x + xChange, 0, room_width);
y = clamp(y + yChange, 0, room_height);

xChange *= speedDecay;
yChange *= speedDecay;

if(mouse_check_button_released(mb_left)) {
	var _orbNearest = instance_nearest(mouse_x, mouse_y, obj_orb);
	if(instance_exists(_orbNearest)) {
		var _orbDist = point_distance(_orbNearest.x, _orbNearest.y, x, y);
		if(_orbDist < orbClickRange) {
			if(instance_exists(orbLinkFromId)) { // coming from one orb to the next
				if(script_checkOrbsConnected(_orbNearest, orbLinkFromId) == false) { // can be -1 or bool
					_orbNearest.linkOrb(orbLinkFromId);
					orbLinkFromId = _orbNearest;
				}
			} else {
				orbLinkFromId = _orbNearest;
			}
		}
		
	}
}

if(mouse_check_button_released(mb_right)) {
	orbLinkFromId = noone;
}

if(keyboard_check_released(vk_space)) {
	var _orb = instance_create_layer(x, y, "Instances", obj_orb);
	image_blend = make_color_rgb(irandom(255), irandom(255), irandom(255));
}

#endregion

var _bulletNearest = instance_nearest(x, y, obj_bullet);
if(_bulletNearest != noone) {
	if(point_distance(x, y, _bulletNearest.x, _bulletNearest.y) < 12) { // 12 is just player width plus a little
		takeHit(_bulletNearest.damage, point_direction(_bulletNearest.x, _bulletNearest.y, x, y));
		_bulletNearest.hit();
	}
}

camera_set_view_pos(view_camera[0], clamp(lerp(camera_get_view_x(view_camera[0]), x - camWidth / 2, .2), 0, room_width - camWidth), clamp(lerp(camera_get_view_y(view_camera[0]), y - camHeight / 2, .2), 0, room_height - camHeight)); // loosely follow player and clamp without room bounds of camera