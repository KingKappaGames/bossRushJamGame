function script_createOrbProjectile(xx, yy, horizontalDirection, shotSpeed, heightMax, duration = -1){
	var _shotOrb = instance_create_layer(xx, yy, "Instances", obj_orbLobbed);
	
	_shotOrb.xChange = dcos(horizontalDirection) * shotSpeed;
	_shotOrb.yChange = -dsin(horizontalDirection) * shotSpeed;
	
	if(duration == -1) {
		duration = heightMax;
	}
	
	_shotOrb.maxFlightDuration = duration;
	_shotOrb.flightDuration = _shotOrb.maxFlightDuration;

	_shotOrb.flightMaxHeight = heightMax;
	
	_shotOrb.image_blend = make_color_rgb(irandom(255), irandom(255), irandom(255));
}