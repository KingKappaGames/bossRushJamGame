x += xChange;
y += yChange;

if(object_index == obj_bullet) {
	if(flying) {
		part_particles_create_color(sys, x, y - flightHeight * 2, trail, image_blend, 1);
	}
	image_angle += imageSpin;

	flightHeight += heightChange;

	if(!flying) {
		heightChange += grav;
	}

	if(flightHeight <= 0) {
		hitGround();
	}

	if(x < 5 || x > room_width - 5 || y < 5 || y > room_height - 5) {
		hitGround();
	}
}


duration--;
if(duration <= 0) {
	instance_destroy();
}