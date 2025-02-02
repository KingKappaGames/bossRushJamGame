event_inherited();

currentDirection += angleChange;

xChange =  dcos(currentDirection) * currentSpeed;
yChange = -dsin(currentDirection) * currentSpeed;

angleChange *= angleDecay;

image_angle = currentDirection;

part_type_orientation(waveTrail, currentDirection - 21, currentDirection + 21, 0, 2, 0);
if(irandom(1) == 0) {
	part_particles_create_color(sys, x, y, projectileTrail, #ffbbbb, 1);
}
part_particles_create(sys, x + random_range(-1, 1), y + random_range(-1, 1), waveTrail, 2);