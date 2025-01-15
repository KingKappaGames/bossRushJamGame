/// @description 



if(menu_up)
{
	
	if(key_left)
	{
		selector--;
	};
	if(key_right)
	{
		selector++;
	};
	if(selector > 3)
	{
		selector = 1;
	};
	if(selector < 1)
	{
		selector = 3;
	};
	
	
	switch current_menu
	{
		
		case "Main Menu":
		
			if(audio_group_is_loaded(ag_Music)) {
				if(!audio_is_playing(snd_mainMenuSong)) {
					audio_play_sound(snd_mainMenuSong, 10, true);
				}
			}
		
			slot_1 = button_start;
			slot_2 = button_settings;
			slot_3 = button_quit;
			
		
			switch selector
			{
				
				case 1:
				
					selectorx = slot_1_x;
					selectory = slot_1_y;
					if(key_enter)
					{
						room_goto(rm_grassyArena);
						menu_up = false;
					};
					
				break;
				
				case 2:
				
					selectorx = slot_2_x;
					selectory = slot_2_y;
					if(key_enter)
					{
						current_menu = "Settings";
					};
					
				break;
				
				case 3:
				
					selectorx = slot_3_x;
					selectory = slot_3_y;
					if(key_enter)
					{
						game_end();
					};
					
				break;
				
			};
			
		
		break;
		
		
		
		case "Pause Menu":
		
			slot_1 = button_start;
			slot_2 = button_settings;
			slot_3 = button_quit;
		
		
			switch selector
			{
				
				case 1:
				
					selectorx = slot_1_x;
					selectory = slot_1_y;
					if(key_enter)
					{
						obj_gameManager.menu_close = true;
						
					};
					
				break;
				
				case 2:
				
					selectorx = slot_2_x;
					selectory = slot_2_y;
					if(key_enter)
					{
						current_menu = "Settings";
					};
					
				break;
				
				case 3:
				
					selectorx = slot_3_x;
					selectory = slot_3_y;
					if(key_enter)
					{
						game_end();
					};
					
				break;
				
			};
		
		break;
		
		
		
		
		case "Settings":
		
			slot_1 = button_back;
			slot_2 = noone;//Music volume
			slot_3 = noone;//SFX Volume
		
		
			switch selector
			{
				
				case 1:
				
					selectorx = slot_1_x;
					selectory = slot_1_y;
					if(key_enter)
					{	
						if(room == rm_Main_Menu)
						{
							current_menu = "Main Menu";
						}
						else
						{
							current_menu = "Pause Menu";
						};
					};
					
				break;
				
				case 2:
				
					selectorx = slot_2_x;
					selectory = slot_2_y;
					if(key_down)
					{
						cur_music_volume -= volume_value;
					};
					if(key_up)
					{
						cur_music_volume += volume_value;
					};
					
				break;
				
				case 3:
				
					selectorx = slot_3_x;
					selectory = slot_3_y;
					if(key_down)
					{
						cur_sfx_volume -= volume_value;
					};
					if(key_up)
					{
						cur_sfx_volume += volume_value;
					};
					
				break;
				
			};
		
		break;
		
		
		
	};
	
	
	
	
};

