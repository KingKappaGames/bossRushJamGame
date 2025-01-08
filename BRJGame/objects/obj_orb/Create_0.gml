radius = 8;

xChange = 0;
yChange = 0;
speedDecay = .9;

type = 0;

linked = false;

connections = [];

linkOrb = function(otherOrb) {
	array_push(connections, otherOrb);
	array_push(otherOrb.connections, id);
	
	linked = true;
	
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
		var _orb = connections[_disconnectI];
		
		array_delete(_orb.connections, array_get_index(_orb.connections, id), 1);
	}
	
	instance_destroy(); // ??
}