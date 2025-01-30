event_inherited();

surface_set_target(script_getDebrisSurface());
gpu_set_blendmode_ext(bm_src_color, bm_dest_alpha); // why is gpu max just making everything black I don't udnerstand, unless it's adding to each channel ind giving a low max in each channel aka dark grey??
draw_set_alpha(.24);
draw_ellipse(x + room_width * .25 - 34 + irandom_range(-16, 16), y - 22 + irandom_range(-8, 8), x + room_width * .25 + 34 + irandom_range(-16, 16), y + 13 + irandom_range(-8, 8), false);
draw_set_alpha(1);
gpu_set_blendmode(bm_normal);
surface_reset_target();