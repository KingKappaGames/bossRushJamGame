/* menu list:
0 menu clear
1 pause menu
2 inventory
3 perk screen
4 vista scene
5 quest book
*/
function script_OpenMenuItem(requestedMenuObject){
	if(obj_DebugManager.acceptInput == 0) {
		var _menuAlreadyOpen = instance_exists(obj_MenuParent);
		
		var _menuOpened = 0;
		
		if(requestedMenuObject == 0) {
			//close open menu if exists
			if(_menuAlreadyOpen) {
				instance_destroy(obj_MenuParent);
			}
		} else {
			if(!_menuAlreadyOpen) {
				//create requested menu and log the index of it
				var _createX = camera_get_view_x(view_camera[0]);
				var _createY = camera_get_view_y(view_camera[0]);
				if(requestedMenuObject == obj_PauseMenu) {
					_createX += 240;
					_createY += 135;
				}
				
				_menuOpened = instance_create_layer(_createX, _createY, "OverLayer", requestedMenuObject);
			} else {
				if(instance_exists(requestedMenuObject)) {
					//menu referenced already open, close it here to allow for undo button mechanics but don't close one menu for anothers asking to be made. I don't know how often that would come up but hey.
					instance_destroy(requestedMenuObject);
				}
			}
		}
	
		
	
		if(!instance_exists(obj_MenuParent)) { // if no menu open then hey it's go time
			script_setPauseState(0);
		}
	}
	
	keyboard_clear(vk_escape); // clear other close menu inputs on escape.. I'm using this system man...
}