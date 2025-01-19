x += xChange;
y += yChange;

var _height = dsin((flightDuration / maxFlightDuration) * 180) * flightMaxHeight;

part_particles_create_color(sys, x, y - _height, trailPart, image_blend, 1);

flightDuration--;
if(flightDuration > 0) {
	flightDuration--;
} else {
	instance_create_layer(x, y, "Instances", obj_attackWebNode);
	instance_destroy();
}