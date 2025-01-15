draw_set_color(c_black);
draw_text_ext_transformed(30, room_height / 8, commandString, 20, 420, 5, 5, 0);

if(acceptInput == 1) {
	draw_text_transformed(room_width / 2, room_height / 30, "DEBUG CONSOLE", 4, 4, 0);
}

if(acceptInput == 1) {
	draw_text_transformed(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), string(mouse_x) + "," + string(mouse_y), 2, 2, 0);
}

if(instance_exists(idOutput)) {
	if(is_array(variableOutput)) {
		draw_set_halign(fa_center);
		for(var _varI = array_length(variableOutput) - 1; _varI >= 0; _varI--) {
			if(variable_instance_exists(idOutput, variableOutput[_varI])) {
				draw_text_transformed(240, 30 + 20 * _varI, variableOutput[_varI] + ": " + string(variable_instance_get(idOutput, variableOutput[_varI])), 3, 3, 0);
			} else {
				array_delete(variableOutput, _varI, 1);
			}
		}
		draw_set_halign(fa_left);
	} else {
		idOutput = 0;
		variableOutput = 0;
	}
} else {
	idOutput = 0;
	variableOutput = 0;
}

draw_set_color(c_white);