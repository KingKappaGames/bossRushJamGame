sys = global.partSys;

trail = global.projectileTrail;

hostile = true; // to check whether it's hitting boss or player?

currentDirection = 0;
xChange = 0;
yChange = 0;

damage = 1;

duration = 120;

image_blend = choose(c_orange, c_maroon, c_green, c_lime, c_yellow);

hit = function() {
	part_particles_create_color(global.partSys, x, y, global.fluffPart, c_orange, irandom_range(3, 5));
	
	instance_destroy();
}