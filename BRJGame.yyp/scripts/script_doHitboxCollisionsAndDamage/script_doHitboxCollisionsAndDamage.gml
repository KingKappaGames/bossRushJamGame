function script_doHitboxCollisionsAndDamage() {
	var _hitBox = 0; // hit boxes / doing damage via attacks
	for(var _hitBoxCheck = array_length(attackTimings) - 1; _hitBoxCheck >= 0; _hitBoxCheck--) {
		_hitBox = attackTimings[_hitBoxCheck];
		if(stateTimer > stateTimerMax * _hitBox[0][0] && stateTimer < stateTimerMax * _hitBox[0][1]) {
			if(!attackHit) { // _hitbox[1-4] = width, height, xOff, yOff
				var _hit = collision_rectangle(x - _hitBox[3] * directionFacing - _hitBox[1], y - _hitBox[4] + _hitBox[2], x - _hitBox[3] * directionFacing + _hitBox[1], y - _hitBox[4] - _hitBox[2], obj_player, false, true);
				var _hitRect = instance_create_depth(x, y, -100, obj_debugHelper); 
				_hitRect.shape = "quadRect";
				_hitRect.quadLeft = x - _hitBox[3] * directionFacing - _hitBox[1];
				_hitRect.quadRight = x - _hitBox[3] * directionFacing + _hitBox[1]; // debug that doesn't even work in this project but should show the hitboxes in theory with the other object i use in all my projects
				_hitRect.quadTop = y - _hitBox[4] + _hitBox[2];
				_hitRect.quadBottom = y - _hitBox[4] - _hitBox[2];
			
				if(instance_exists(_hit)) {
					var _hitInfo = _hitBox[5];
					_hit.takeHit(_hitInfo[0], _hitInfo[1], dirToPlayer, _hitInfo[3]);
					attackHit = true;
					
					//audio_play_sound(snd_punch, 1, 0, 2);
				}
			}
		}
	}
}