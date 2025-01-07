if(gameState == "gameOver") {
	gameStateTimer--;
	if(gameStateTimer <= 0) {
		setGameState("respawn");
	}
} else if(gameState == "respawn") {
	if(mouse_check_button_released(mb_left) || mouse_check_button_released(mb_right)) {
		setGameState("fight");
	}
} else if(gameState == "victory") {
	gameStateTimer--;
	if(gameStateTimer <= 0) {
		setGameState("");
	}
}










if(keyboard_check_released(ord("F"))) {
	window_set_fullscreen(!window_get_fullscreen());
}