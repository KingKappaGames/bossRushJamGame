function script_createBullet(damage, xx, yy, bulletDirection, bulletSpeed, hitsPlayer = true){
	var _bullet = instance_create_layer(xx, yy, "Instances", obj_bullet);
	
	_bullet.xChange = dcos(bulletDirection) * bulletSpeed;
	_bullet.yChange = -dsin(bulletDirection) * bulletSpeed;
	_bullet.currentDirection = bulletDirection;
	
	_bullet.damage = damage;
	_bullet.hostile = hitsPlayer;
}