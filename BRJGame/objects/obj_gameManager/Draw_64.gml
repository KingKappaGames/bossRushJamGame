draw_set_halign(fa_center);
if(gameState == "gameOver") {
	draw_text_transformed(view_wport[0] / 2, + view_hport[0] / 2, gameStateText, 4, 4, 2 * dsin(current_time));
} else if(gameState == "respawn") {
	draw_text_transformed(view_wport[0] / 2 + irandom_range(-1, 1), view_hport[0] / 2 + irandom_range(-1, 1), gameStateText, 4, 4, 0);
}
draw_set_halign(fa_left);




/* // version using room coords...
if(gameState == "gameOver") {
	draw_text_transformed(camera_get_view_x(view_camera[0]) + view_wport[0] / 2, camera_get_view_y(view_camera[0]) + view_hport[0] / 2, gameStateText, 2, 2, 2 * dsin(current_time));
} else if(gameState == "respawn") {
	draw_text_transformed(camera_get_view_x(view_camera[0]) + view_wport[0] / 2 + irandom_range(-1, 1), camera_get_view_y(view_camera[0]) + view_hport[0] / 2 + irandom_range(-1, 1), gameStateText, 2, 2, 0);
}