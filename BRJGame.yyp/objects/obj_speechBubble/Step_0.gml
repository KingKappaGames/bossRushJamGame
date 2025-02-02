if(textAddTimer <= 0) {
	if(textAddPos <= textLength) {
		displayMessage += string_char_at(bubbleMessage, textAddPos);
		textAddPos++;
		textAddTimer = textAddTimerMax;
		
		messageWidth = string_width(displayMessage);
		
		//im just now realising that if you represented your type writer effect as a message display % then you could specify the time more concretely and remove any issue with 0 typing delay because it would display multiple characters to keep up, it does create issues with updates and string width not having a distinct place to display and having to recalculate every frame probably... Hm.
	}
} else {
	textAddTimer--;
}

duration--;
if(duration <= 0) {
	instance_destroy();
}