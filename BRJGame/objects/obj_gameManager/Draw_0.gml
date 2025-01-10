var _drawnLinks = global.linksTotalThisFrame; // pairs of [orb1, orb2, linkDist]

with(obj_orb) { // with each orb draw links but not duplicates
	if(linked) {
		for(var _connectionI = array_length(connections) - 1; _connectionI >= 0; _connectionI--) { // with each connected orb to that orb
			var _orb = connections[_connectionI][0];
			var _alreadyDrawn = false;
			
			if(instance_exists(_orb)) {
				for(var _totalLinksI = array_length(_drawnLinks) - 1; _totalLinksI >= 0; _totalLinksI--) { // check total connections to see if it's already been done
					var _pair = _drawnLinks[_totalLinksI];
					if((_pair[0] == id && _pair[1] == _orb) || (_pair[1] == _orb && _pair[0] == id)) { // check if pair exists already, this is annoying to do like this but whatever
						_alreadyDrawn = true;
						break;
					}
				}
				
				if(!_alreadyDrawn) {
					draw_line_width_color(_orb.x, _orb.y, x, y, 3, c_white, c_ltgray);
				
					var _dist = point_distance(x, y, _orb.x, _orb.y);
					
					array_push(_drawnLinks, [id, _orb, _dist]);
				}
			}
		}
	}
}

if(array_length(_drawnLinks) > 0) {
	global.boss.blockingLinksRef = _drawnLinks;
}

draw_surface(script_getDebrisSurface(), 0, 0);