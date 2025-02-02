function script_createSpeechBubble(xx, yy, messageText, durationSet, arrowOriginX = x, arrowOriginY = y - (sprite_height / 2) - 25){
	var _bubble = instance_create_layer(xx, yy, "Instances", obj_speechBubble);
	_bubble.bubbleMessage = messageText;
	_bubble.sourceId = id; // guess the caller
	
	_bubble.originX = arrowOriginX;
	_bubble.originY = arrowOriginY;
	
	_bubble.textLength = string_length(messageText);
	_bubble.textAddTimerMax = round(40 / _bubble.textLength);
	
	_bubble.duration = durationSet + _bubble.textLength * 3;
	
	return _bubble;
}