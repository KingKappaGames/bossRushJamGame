draw_self();

if(!instance_exists(obj_speechBubble)) {
	if(point_distance(x, y, global.player.x, global.player.y) < interactionRadius) {	
		draw_text(x, y - 50, "Click to talk");
	}
}