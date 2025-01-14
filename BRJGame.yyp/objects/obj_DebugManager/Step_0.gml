if(acceptInput == 1) {
	if(mouse_check_button_released(mb_left)) {
		idSelect = instance_nearest(mouse_x, mouse_y, obj_bossRoller);
		if(idSelect != noone) {
			script_createTextPop(idSelect.x, idSelect.y, $"Selected! {object_get_name(idSelect.object_index)}", 120);
		}
	}
	if(mouse_check_button_released(mb_right)) {
		idSelect = instance_nearest(mouse_x, mouse_y, all);
		if(idSelect != noone) {
			script_createTextPop(idSelect.x, idSelect.y, $"Selected! {object_get_name(idSelect.object_index)}", 120);
		}
	}
	
	if(keyboard_check_released(vk_enter)) {
		parseCommand();
	}
	
	if(keyboard_check_released(vk_up)) {
		commandString = commandStringPrevious;
	}
	
	//commandString = get_string_async("Enter debug command please.", "");
	//when ready do parse command script but this keeps running prematurely
	if(keyboard_check_pressed(vk_backspace)) {
		commandString = string_delete(commandString, string_length(commandString), 1);
	} else if(keyboard_check_pressed(keyboard_lastkey)) {
		var _uni = real(keyboard_lastkey);
		//gameMsg(_uni); // if you are a lost soul looking for the ascii or whatever code this is (uni? But what?) then activate this and find out with the debug console. EZ PZ
		if((_uni > 47 && _uni < 58) || (_uni > 64 && _uni < 91) || _uni == 32 || _uni == 189 || _uni == 190) {
			if(_uni == 189) {
				if(keyboard_check(vk_shift)) {
					commandString = string_insert("_", commandString, string_length(commandString) + 1);
				} else {
					commandString = string_insert("-", commandString, string_length(commandString) + 1);
				}
			} else if(_uni == 190) {
				commandString = string_insert(".", commandString, string_length(commandString) + 1);
			} else {
				if(keyboard_check(vk_shift)) {
					commandString = string_insert(chr(keyboard_lastkey), commandString, string_length(commandString) + 1);
				} else {
					commandString = string_insert(string_lower(chr(keyboard_lastkey)), commandString, string_length(commandString) + 1);
				}
			}
		}
	}
}