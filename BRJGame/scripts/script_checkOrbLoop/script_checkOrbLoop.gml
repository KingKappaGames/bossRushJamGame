///@param initalOrb The orb to check currently
///@param seedOrb The orb to use as the root orb for the chain
function script_checkOrbLoop(checkOrb, seedOrb, previousOrb = noone, currentChainIds = 0, chainLength = 0) { // from an internal perspective this function runs for every viable orb check, meaning it doesn't run for duplicates or non connections. This means that every time the function runs you can be sure to add your chains with this orb, it's whether it keeps going that is up for debate.
	if(instance_exists(checkOrb)) {
		if(currentChainIds == 0) {
			currentChainIds = [];
		} else {
			array_push(currentChainIds, checkOrb);
		}
		
		chainLength++;
		if(checkOrb == seedOrb) {
			if(chainLength > 1) { // 2 and 1 and 0 orbs is not a chain...
				return currentChainIds;
			}
		}
		
		for(var _i = array_length(checkOrb.connections) - 1; _i >= 0; _i--) {
			var _orb = checkOrb.connections[_i][0];
			
			if(previousOrb != _orb) { // don't chain back to a path you've already taken
				var _result = script_checkOrbLoop(_orb, seedOrb, checkOrb, variable_clone(currentChainIds), chainLength);
				if(_result != -1) {
					return _result;
				}
			}
		}
		
		return -1;
	}
	
	return -1;
}