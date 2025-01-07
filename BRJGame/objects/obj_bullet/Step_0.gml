x += xChange;
y += yChange;

duration--;
if(duration <= 0) {
	instance_destroy();
}