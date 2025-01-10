function script_createTextPop(xSet, ySet, text, durationSet = 60){
	var _text = instance_create_layer(xSet, ySet, "Instances", obj_textPop);
	_text.displayText = text;
	_text.duration = durationSet;
}