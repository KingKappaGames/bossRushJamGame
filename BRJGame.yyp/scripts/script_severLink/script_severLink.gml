function script_severLink(orb1, orb2){
	var _orb1Links = orb1.connections;
	var _orb2Links = orb2.connections;
		
	for(var _checkI = array_length(_orb1Links) - 1; _checkI >= 0; _checkI--) { // adding distance into the connections array is a disaster but oh well bro
		if(_orb1Links[_checkI][0] == orb2) {
			array_delete(_orb1Links, _checkI, 1);
			break;
		}
	}
	
	for(var _checkI = array_length(_orb2Links) - 1; _checkI >= 0; _checkI--) {
		if(_orb2Links[_checkI][0] == orb1) {
			array_delete(_orb2Links, _checkI, 1);
			break;
		}
	}
	
	if(array_length(_orb1Links) == 0) {
		orb1.linked = false;
	}
	if(array_length(_orb2Links) == 0) {
		orb2.linked = false;
	}
}