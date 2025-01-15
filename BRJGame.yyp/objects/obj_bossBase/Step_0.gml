depth = -y; // el classico, que quapo

if(!instance_exists(player)) {
	player = noone;
} else {
	dirToPlayer = point_direction(x, y, player.x, player.y);
}

if(blockingLinksRef != 0) { // get web blocks
	for(var _i = array_length(blockingLinksRef) - 1; _i >= 0; _i--) {
		var _orbPair = blockingLinksRef[_i];
		if(_orbPair[0].fakeOrb == false && _orbPair[1].fakeOrb == false) {
			if(script_checkLineIntersectsLine(_orbPair[0].x, _orbPair[0].y, _orbPair[1].x, _orbPair[1].y, x - xChange * 2, y - yChange * 2, x + xChange * 2, y + yChange * 2, true) != 0) { // check all web links for collision with this boss and create fake collision point if so
				script_createWebStuckPoint(id, _orbPair); // blocking links is a sub array of both orbs in the link, perfect for this
			}
		}
	}
}

if(xChange >= 0) { // face in direction you're moving (depends on the sprite art direction..
	directionFacing = 1;
} else {
	directionFacing = -1;
}

x = clamp(x + xChange, 0, room_width);
y = clamp(y + yChange, 0, room_height);

xChange *= speedDecay;
yChange *= speedDecay;

if(stateTimer >= 0) {
	stateTimer--;
	//stateTimer -= delta_time / 1000; // this is if we do attack timing in ms instead of frames..
}