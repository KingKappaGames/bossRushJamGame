image_blend = c_blue;

duration = 120 + irandom(210);

orbActivateNet = function() {
	with(obj_attackWebNode) {
		if(id != other.id) {
			var _hitId = collision_line(x, y, other.x, other.y, obj_player, false, true); // (player!)
			
			var _webDir = point_direction(x, y, other.x, other.y);
			part_type_orientation(global.webLineSnap, _webDir, _webDir, .3, 18, 0);
			repeat(point_distance(x, y, other.x, other.y) / 10) {
				var _lineProgress = random(1);
				part_particles_create(global.partSys, lerp(x, other.x, _lineProgress), lerp(y, other.y, _lineProgress), global.webLineSnap, 1);
			}
			
			if(instance_exists(_hitId)) {
				global.player.takeHit(8, 2, irandom(360), 40);
			}
		}
	}
	
	instance_destroy();
}