function script_createWebStuckPoint(stuckId, orbPairArray){
	var _orb1 = orbPairArray[0];
	var _orb2 = orbPairArray[1];
	
	script_severLink(_orb1, _orb2); // cut the connections of these two orbs from each other
	
	var _fakeStickOrb = instance_create_layer(stuckId.x, stuckId.y, "Instances", obj_orb);
	_fakeStickOrb.fakeOrb = true;
	_fakeStickOrb.stuckToId = stuckId;
	
	_fakeStickOrb.linkOrb(_orb1); // fake stick point connected to each original orb
	_fakeStickOrb.linkOrb(_orb2); // reconnecting with cetral point
	
	global.bossStickingOrbs++;
}