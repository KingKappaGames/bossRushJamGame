hostile = true; // to check whether it's hitting boss or player?

currentDirection = 0;
xChange = 0;
yChange = 0;

damage = 1;

duration = 180;

hit = function() {
	part_particles_create_color(global.partSys, x, y, global.fluffPart, c_red, irandom_range(3, 5));
	
	instance_destroy();
}