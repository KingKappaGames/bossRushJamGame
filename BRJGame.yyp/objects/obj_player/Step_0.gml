depth = -(y + 12);

directionToMouse = point_direction(x, y, mouse_x, mouse_y);

#region movement and controls
if(state == "idle") {
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

	if(keyboard_check_released(vk_space)) {
		setState("jump", 28);
	}
	
	if(keyboard_check_pressed(vk_shift)) {		
		setState("spin");
	}
	
	if(keyboard_check_released(ord("E"))) {
		var _orb = instance_create_layer(x, y, "Instances", obj_orb);
		_orb.image_blend = make_color_rgb(irandom(255), irandom(255), irandom(255));
	}
} else if(state == "spin") {
	if(keyboard_check_released(vk_shift)) {
		setState("idle");
	} else {
		var _dirFromCenter = point_direction(spinCenterX, spinCenterY, x, y);
		
		if(abs(angle_difference(spinLastAngleOrb, _dirFromCenter)) > 1200 / spinDist) { // well... this basically creates an orb web every few degrees of travel but more on bigger circles becauese bigger circle = more distance per angle traveleed.... Don't ask me to be reasonable
			var _orb = instance_create_layer(x, y, "Instances", obj_orb);
			if(instance_exists(spinLastOrbId)) {
				_orb.linkOrb(spinLastOrbId);
			}
			spinLastOrbId = _orb;
			
			spinLastAngleOrb = _dirFromCenter;
		}
		
		if(keyboard_check(ord("W"))) {
			var _poiX = spinCenterX + dcos(_dirFromCenter + (300 / spinDist)) * spinDist;
			var _poiY = spinCenterY - dsin(_dirFromCenter + (300 / spinDist)) * spinDist;
			
			var _dirToPoi = point_direction(x, y, _poiX, _poiY);
			xChange += dcos(_dirToPoi) * moveSpeed * 3;
			yChange -= dsin(_dirToPoi) * moveSpeed * 3;
		} else if(keyboard_check(ord("S"))) {
			var _poiX = spinCenterX + dcos(_dirFromCenter - (300 / spinDist)) * spinDist;
			var _poiY = spinCenterY - dsin(_dirFromCenter - (300 / spinDist)) * spinDist;
			
			var _dirToPoi = point_direction(x, y, _poiX, _poiY);
			xChange += dcos(_dirToPoi) * moveSpeed * 3;
			yChange -= dsin(_dirToPoi) * moveSpeed * 3;
		}

		if(keyboard_check(ord("A"))) {
			spinDist -= 2;
		}

		if(keyboard_check(ord("D"))) {
			spinDist += 2;
		}
	}
}

x = clamp(x + xChange, 0, room_width);
y = clamp(y + yChange, 0, room_height);

//var _anglePushSpiderDirection = angle_difference(point_direction(0, 0, xChange, yChange), directionFacing);
if(state != "jump" && state != "knock") {
	directionFacing += angle_difference(point_direction(0, 0, xChange, yChange), directionFacing) / 10;
} else if(state == "knock") {
	directionFacing += 10;
}

xChange *= speedDecay;
yChange *= speedDecay;

if(state == "idle") {
	
} else {
	if(stateTimer != infinity) {
		stateTimer--;
		if(stateTimer <= 0) {
			setState("idle");
		}
	}
}

if(immunityFrames > 0) {
	immunityFrames--;
}

if(hitColorTimer > 0) {
	hitColorTimer--;
	if(hitColorTimer <= 0) {
		image_blend = c_white;
	}
}


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

#endregion

var _bulletNearest = instance_nearest(x, y, obj_bullet);
if(_bulletNearest != noone) {
	if(point_distance(x, y, _bulletNearest.x, _bulletNearest.y) < 12) { // 12 is just player width plus a little
		takeHit(_bulletNearest.damage, undefined, point_direction(_bulletNearest.x, _bulletNearest.y, x, y), 120);
		_bulletNearest.hit();
	}
}