x += xChange;
y += yChange;

if(y < -100 || y > room_height + 100) {
	instance_destroy();
}