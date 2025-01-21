x = clamp(x + xChange, 0, 9999);
y = clamp(y + yChange, 0, room_height);

if(fakeOrb) {
	if(instance_exists(stuckToId)) {
		x = stuckToId.x;
		y = stuckToId.y;
		
		script_pullAndBreakLinks(id);
		
		if(array_length(connections) == 0) {
			instance_destroy();
		}
	}
}

xChange *= speedDecay;
yChange *= speedDecay;