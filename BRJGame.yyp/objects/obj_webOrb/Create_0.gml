radius = 8;
weight = 1;

xChange = 0;
yChange = 0;
speedDecay = .93;

type = 0;
fakeOrb = false;

stuckToId = noone;

linked = false;

connections = [];

snap = function(connection = -1) {
	audio_play_sound(snd_webSnap, 0, 0);
	
	if(connection == -1) {
		for(var _connections = array_length(connections) - 1; _connections >= 0; _connections--) {
			script_severLink(id, connections[_connections][0]);
		}
		instance_destroy();
	} else {
		script_severLink(id, connections[connection][0]);
	}
	
	if(array_length(connections) == 0) {
		instance_destroy();
	}
}

linkOrb = function(otherOrb) {
	var _dist = point_distance(x, y, otherOrb.x, otherOrb.y);
	
	array_push(connections, [otherOrb, _dist]);
	array_push(otherOrb.connections, [id, _dist]);
	
	linked = true;
	//linkDistMax = _dist * 1.25 + 15;
}

activateOrb = function() {
	part_particles_create_color(global.partSys, x, y, global.fluffPart, c_yellow, irandom_range(15, 30));
	
	for(var _disconnectI = array_length(connections) - 1; _disconnectI >= 0; _disconnectI--) {
		var _orb = connections[_disconnectI][0];
		
		var _searchIdFunc = function(_element, _index) {
			return _element[0] == id; // so called, "predicate function" well, this runs for each index of the searched array
		}
		
		array_delete(_orb.connections, array_find_index(_orb.connections, _searchIdFunc), 1);
	}
	
	instance_destroy(); // ??
}