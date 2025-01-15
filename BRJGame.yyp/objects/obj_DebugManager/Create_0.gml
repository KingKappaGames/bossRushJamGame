acceptInput = 0;

highlightedVariable = 0;

commandString = "";
commandStringPrevious = "";

idSelect = 0;

idOutput = 0;
variableOutput = 0;

parseCommand = function() {
	#region getting the command string and turning it into chunks
	var _beginChunk = 1;
	var _endChunk = 1;
	var _chunkArray = [];
	var _chunkArrayPos = 0;
	
	if(commandString != "") {
		commandStringPrevious = commandString;
	
		if(!string_ends_with(commandString, " ")) {
			commandString = string_concat(commandString, " "); // add ending string to mark cut off
		}
	
		var _len = string_length(commandString);
		for(var _i = 1; _i <= _len; _i++) {
			if(string_char_at(commandString, _i) == " ") {
				_chunkArray[_chunkArrayPos] = string_copy(commandString, _beginChunk, _endChunk - 1);
				_beginChunk = _i + 1;
				_endChunk = 1;
				_chunkArrayPos++;
			} else {
				_endChunk++;
			}
		}
	
		var _chunkCount = array_length(_chunkArray);
		#endregion
	
		#region using the chunks generated to run keyword functions
	
		for(var _i = 0; _i < _chunkCount; _i++) {
			if(_chunkArray[_i] == "id") {
				_chunkArray[_i] = idSelect;
			} else if(_chunkArray[_i] == "manager") {
				_chunkArray[_i] = global.gameManager;
			} else if(_chunkArray[_i] == "menuManager") {
				_chunkArray[_i] = instance_find(obj_Menu_Manager, 0);
			}
		}
	
		if(_chunkArray[0] == "restart") {
			room_goto(room);
		} else if(_chunkArray[0] == "tag") {
			var _id = _chunkArray[1];
			if(instance_exists(_id)) {
				if(_chunkCount > 2) {
					if(_id == idOutput && is_array(variableOutput)) {
						array_delete(_chunkArray, 0, 2);
						variableOutput = array_concat(variableOutput, _chunkArray);
					} else {
						idOutput = _id;
						variableOutput = [];
						array_copy(variableOutput, 0, _chunkArray, 2, _chunkCount - 2);
					}
				}
			}
		} else if(_chunkArray[0] == "tagsClear" || _chunkArray[0] == "tagClear" || _chunkArray[0] == "tagclear") {
			idOutput = 0;
			variableOutput = 0;
		} else if(_chunkArray[0] == "set") {
			if(_chunkCount == 4) {
				var _id = (_chunkArray[1]);
				if(instance_exists(_id)) {
					if(variable_instance_exists(_id, _chunkArray[2])) {
						if(string_digits(_chunkArray[3]) != "") {
							var _neg = 1;
							if(string_pos("-", _chunkArray[3]) != 0) {
								_neg = -1;
							}
							variable_instance_set(_id, _chunkArray[2], _neg * real(string_digits(_chunkArray[3])));
						} else {
							variable_instance_set(_id, _chunkArray[2], _chunkArray[3]);
						}
					}
				}
			}
		
		} else if(_chunkArray[0] == "delete") {
			if(_chunkCount == 2) {
				var _id = (_chunkArray[1]);
				if(!is_string(_id)) {
					if(instance_exists(_id)) {
						instance_destroy(_id, false);
					}
				}
			}
		} else if(_chunkArray[0] == "output") {
			var _id = _chunkArray[1];
			if(instance_exists(_id)) {
				if(_chunkCount == 3) {
					show_debug_message("Debug output!: " + string(variable_instance_get(_id, string(_chunkArray[2]))));
				}
			}
		}
		// else other such commands... Cool!
		#endregion
	
		commandString = "";
	} else {
		gameMsg("No command~");
	}
}