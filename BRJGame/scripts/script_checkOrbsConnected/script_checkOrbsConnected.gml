function script_checkOrbsConnected(firstOrb, secondOrb){
	if(instance_exists(firstOrb) && instance_exists(secondOrb)) {
		if(firstOrb != secondOrb) {
			if(!array_contains(firstOrb.connections, secondOrb) && !array_contains(secondOrb.connections, firstOrb)) { // bit redundant to check both but hey
				return false;
			} else {
				return true;
			}
		} else {
			return -1; // being the same orb also (-1)?
		}
	} else {
		return -1; // one or both orbs don't exist (-1)
	}
}