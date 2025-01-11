function script_checkOrbsConnected(firstOrb, secondOrb){
	if(instance_exists(firstOrb) && instance_exists(secondOrb)) {
		if(firstOrb != secondOrb) {
			for(var _checkI = array_length(firstOrb.connections) - 1; _checkI >= 0; _checkI--) {
				if(firstOrb.connections[_checkI][0] == secondOrb) {
					return true;
				}
			}
			return false;
		} else {
			return -1; // being the same orb also (-1)?
		}
	} else {
		return -1; // one or both orbs don't exist (-1)
	}
}