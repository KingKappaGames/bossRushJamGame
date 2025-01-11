x += xChange;
y += yChange;

part_particles_create_color(sys, x, y, trail, image_blend, 1);

duration--;
if(duration <= 0) {
	instance_destroy();
}