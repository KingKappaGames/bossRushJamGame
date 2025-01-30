timer += timerSpeed;
height = dsin(timer);

if(timer >= 180) {
	instance_destroy();
} else if(timer > 90) {
	timerSpeed = 1.8;
}