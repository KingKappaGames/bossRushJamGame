event_inherited();

surface_set_target(script_getDebrisSurface());
gpu_set_blendmode_ext(bm_src_color, bm_dest_alpha); // why is gpu max just making everything black I don't udnerstand, unless it's adding to each channel ind giving a low max in each channel aka dark grey??
draw_set_alpha(.3);
draw_ellipse(x - 34 + irandom_range(-10, 10), y - 22 + irandom_range(-8, 8), x + 34 + irandom_range(-10, 10), y + 13 + irandom_range(-8, 8), false);
draw_set_alpha(1);
gpu_set_blendmode(bm_normal);
surface_reset_target();