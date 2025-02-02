x += xChange;
y += yChange;

image_angle += imageSpin;

flightHeight += heightChange;

heightChange += grav;

if(flightHeight <= 0) {
	hitGround();
}

duration--;
if(duration <= 0) {
	instance_destroy();
}