function script_pullAndBreakLinks(sourceOrb, previousOrb = noone){
	for(var _linkI = array_length(sourceOrb.connections) - 1; _linkI >= 0; _linkI--) {
		var _connectedOrb = sourceOrb.connections[_linkI][0]; // id ([1] is dist max for this connection)
		if(_connectedOrb != previousOrb) {
			var _dist = point_distance(_connectedOrb.x, _connectedOrb.y, sourceOrb.x, sourceOrb.y);
			var _distMax = sourceOrb.connections[_linkI][1] * 1.25 + 15;
			if(_dist > _distMax) { // distance max for this link
				script_severLink(_connectedOrb, sourceOrb);
			} else {
				var _pullNormalRange = ((_distMax - 15) * .8);
				var _overPullDist = _dist - _pullNormalRange;
				if(_overPullDist > 0) {
					var _pullDir = point_direction(_connectedOrb.x, _connectedOrb.y, sourceOrb.x, sourceOrb.y);
					var _pullStrength = sqr(_overPullDist / (_distMax - _pullNormalRange)) * 15;
					
					var _xPull = dcos(_pullDir) * _pullStrength;
					var _yPull = -dsin(_pullDir) * _pullStrength;
				
					_connectedOrb.x += _xPull;
					_connectedOrb.y += _yPull; // portion of over pull that you've done, create elasticity
					
					sourceOrb.x -= _xPull / 3;
					sourceOrb.y -= _yPull / 3; 
					
					script_pullAndBreakLinks(_connectedOrb, sourceOrb);
				}
			}
		}
	}
	
	// each orb looks to the next and pulls it if less than dist, breaks if less than min of either's limits
}