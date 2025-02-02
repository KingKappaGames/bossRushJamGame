if(instance_exists(global.player)) {
	if(point_distance(x, y, global.player.x, global.player.y) < interactionRadius) {	
		if(mouse_check_button_released(mb_left)) {
			interact();
		}
	} else {
		dialogueIndex = 0;
		if(instance_exists(obj_speechBubble)) {
			instance_destroy(obj_speechBubble);
		}
	}
}

if(camera_get_view_x(view_camera[0]) > -5) {
	instance_destroy();
}