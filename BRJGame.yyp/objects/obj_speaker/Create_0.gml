depth = -y;

dialogues = [
"All of this ugly tutorial text!",
"Why didn't the programmer just use...",
"these nifty speech bubbles?!",
"Why are they making me say this now",
"instead of...",
"This really doesn't make any sense.",
"But while you're here-",
"It's important you remember-",
"Complete your rings WHILE the boss is inside.",
"A ring is a closed loop of orbs!",
"I read all about closed loops.",
"Back in mer-university.",
"Very important stuff... Boss inside...",
"PS, if you want the fight to end faster",
"just hit \"end\" on your keyboard",
"and f1, f2, and f3 spawn bosses-",
"You know, just for fun...",
"and uh...",
"What was I talking about?"
];

interactionRadius = 170;
dialogueIndex = 0;

interact = function() {
	instance_destroy(obj_speechBubble); 
	
	if(dialogueIndex > array_length(dialogues) - 1) {
		dialogueIndex = 0;
		exit;
	}
	
	script_createSpeechBubble(x + 106, y + 150, dialogues[dialogueIndex], 120000, x + 40, y + 40);
	dialogueIndex++;
}