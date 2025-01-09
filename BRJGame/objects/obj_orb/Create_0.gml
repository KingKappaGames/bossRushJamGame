radius = 8;
weight = 1;

xChange = 0;
yChange = 0;
speedDecay = .9;

type = 0;
fakeOrb = false;

stuckToId = noone;

linked = false;

connections = [];

linkOrb = function(otherOrb) {
	var _dist = point_distance(x, y, otherOrb.x, otherOrb.y);
	
	array_push(connections, [otherOrb, _dist]);
	array_push(otherOrb.connections, [id, _dist]);
	
	linked = true;
	//linkDistMax = _dist * 1.25 + 15;
	
	var _orbsRing = script_checkOrbLoop(id, id);
	
	if(_orbsRing != -1) {
		
		var _collisionPoints = [];
		var _orb = noone;
		
		for(var _triggerI = array_length(_orbsRing) - 1; _triggerI >= 0; _triggerI--) {
			_orb = _orbsRing[_triggerI];
			
			array_push(_collisionPoints, [_orb.x, _orb.y]);
			_orb.activateOrb();
		}
		
		var _bosses = [];
		with(obj_boss) {
			array_push(_bosses, id);
		}
		
		for(var _i = array_length(_bosses) - 1; _i >= 0; _i--) {
			var _boss = _bosses[_i];
			if(script_pointInComplexPolygon(_boss.x, _boss.y, _collisionPoints)) {
				_boss.hit(10);
			}
		}
	}
}

activateOrb = function() {
	part_particles_create(global.partSys, x, y, global.fluffPart, irandom_range(15, 30));
	
	for(var _disconnectI = array_length(connections) - 1; _disconnectI >= 0; _disconnectI--) {
		var _orb = connections[_disconnectI][0];
		
		var _searchIdFunc = function(_element, _index) {
			return _element[0] == id; // so called, "predicate function" well, this runs for each index of the searched array
		}
		
		array_delete(_orb.connections, array_find_index(_orb.connections, _searchIdFunc), 1);
	}
	
	instance_destroy(); // ??
}