event_inherited();

if(fakeOrb) {
	if(instance_exists(stuckToId)) {
		x = stuckToId.x;
		y = stuckToId.y;
		
		script_pullAndBreakLinks(id);
		
		if(irandom(12000) == 0) {
			snap();
		}
		
		if(array_length(connections) == 0) {
			instance_destroy();
		}
	}
}