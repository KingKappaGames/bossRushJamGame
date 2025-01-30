function script_createBullet(damage, xx, yy, bulletDirection, bulletSpeed, hitsPlayer = true, projectileType = obj_bullet, duration = -1){
	var _bullet = instance_create_layer(xx, yy, "Instances", projectileType);
	
	_bullet.xChange = dcos(bulletDirection) * bulletSpeed;
	_bullet.yChange = -dsin(bulletDirection) * bulletSpeed;
	_bullet.currentSpeed = bulletSpeed;
	_bullet.currentDirection = bulletDirection;
	
	_bullet.damage = damage;
	_bullet.hostile = hitsPlayer;
	
	if(duration != -1) {
		_bullet.duration = duration;
	}
}