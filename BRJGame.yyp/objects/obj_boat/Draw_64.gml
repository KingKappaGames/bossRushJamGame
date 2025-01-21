if(active) {
	draw_set_alpha(clamp(transitionTime / transitionTimeMax, 0, 1));
	draw_set_color(c_black);
	draw_rectangle(0, 0, view_wport[0], view_hport[0], false);
	draw_set_color(c_white);
	draw_set_alpha(1);
}