if(!global.is_paused) {
	draw_set_halign(fa_center);
	if(gameState == "gameOver") {
		draw_text_transformed(view_wport[0] / 2, + view_hport[0] / 3, gameStateText, 5, 5, 2 * dsin(current_time));
	} else if(gameState == "respawn") {
		draw_text_transformed(view_wport[0] / 2 + irandom_range(-1, 1), view_hport[0] / 3 + irandom_range(-1, 1), gameStateText, 5, 5, 0);
	} else if(gameState == "victory") {
		draw_text_transformed(view_wport[0] / 2 + irandom_range(-1, 1), view_hport[0] / 3 + irandom_range(-1, 1), gameStateText, 5, 5, 0);
	} else if(gameState == "moveZone") {
		draw_text_transformed(view_wport[0] / 2, view_hport[0] / 10, gameStateText, 3.5, 3.5, 0);
	}
	draw_set_halign(fa_left);
}

if(room == rm_Main_Menu) {
	if(global.boss_selected > -1) {
		var _halign = draw_get_halign();
		var _bossName = array_get(["spider", "praying mantis", "rollie"], global.boss_selected);
		draw_set_halign(fa_left);
		draw_sprite_ext(spr_textBlurBG, 0, view_wport[0] * -.07, view_hport[0] * .21, string_width(_bossName) / sprite_get_width(spr_textBlurBG) + 2, 3, 0, c_white, 1);
		draw_text_transformed(view_wport[0] * .02, view_hport[0] * .29, _bossName, 1.2, 1.2, 0);
		draw_set_halign(_halign);
	}
}