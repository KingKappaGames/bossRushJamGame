event_inherited();

currentDirection += angleChange;

xChange =  dcos(currentDirection) * currentSpeed;
yChange = -dsin(currentDirection) * currentSpeed;

angleChange *= .993;

image_angle = currentDirection;

part_type_orientation(waveTrail, currentDirection - 13, currentDirection + 13, 0, 1, 0);
part_particles_create(sys, x, y, waveTrail, 2);