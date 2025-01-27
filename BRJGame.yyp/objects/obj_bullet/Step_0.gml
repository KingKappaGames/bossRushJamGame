x += xChange;
y += yChange;

if(object_index == obj_bullet) {
	part_particles_create_color(sys, x, y, trail, image_blend, 1);
}

duration--;
if(duration <= 0) {
	instance_destroy();
}