if(room == rm_Main_Menu)
{
	x = room_width / 2;
	y = room_height / 2;
	camera_set_view_pos(view_camera[0], x - camera_get_view_width(view_camera[0]) / 2, y - camera_get_view_height(view_camera[0]) / 2); // cameras always have a half screen off set! (but you weren't using cameras anyway so it didn't have any impact)
	
	var _playButton = instance_create_layer(x - sprite_width * .25, y + sprite_height * .3, "Instances", obj_menu_play); // place buttons relative to menu usually
	var _quitButton = instance_create_layer(x + sprite_width * .25, y + sprite_height * .3, "Instances", obj_menu_quit);

};