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
	
	
	
	switch current_menu
	{
		
		case "Main Menu":
		
			if(audio_group_is_loaded(ag_Music))
			{
				if(!audio_is_playing(snd_mainMenuSong))
				{
					audio_play_sound(snd_mainMenuSong, 10, true);
				};
			};
				
			slot_1 = button_start;
			slot_2 = button_settings;
			slot_3 = button_quit;
			slot_4 = button_boss_select;
			slot_5 = button_difficulty;
			
			max_options = 5;//Max amount of buttons in this page
			
			
			if(selector > max_options)
			{
				selector = 1;
			};
			if(selector < 1)
			{
				selector = max_options;
			};
			
			
			
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
				
				
				case 4:
				
					selectorx = slot_4_x;
					selectory = slot_4_y;
					
					
					//Cycle through bosses
					if(key_up)
					{
						bselect++;	
						if(bselect > array_length(boss_array) - 1)
						{
							bselect = 0;
						};
					};
					if(key_down)
					{
						bselect--;	
						if(bselect < 0)
						{
							bselect = array_length(boss_array) - 1;
						};
						
					};
					global.boss_selected = boss_array[bselect];
					
					boss_overlay = boss_array[bselect];
					
				
				break;
				
				case 5:
				
					selectorx = slot_5_x;
					selectory = slot_5_y;
					
					if(key_up)
					{
						dselect++;
					};
					if(key_down)
					{
						dselect--;
					};
					dselect = clamp(dselect, 0, array_length(dif_array) - 1);
					
					global.difficulty = dselect; //Set global difficulty
					
					dif_overlay = dif_array[dselect];
				
				
				break;
				
				
				
			};
			
		
		break;
		
		
		
		case "Pause Menu":
		
			slot_1 = button_resume;
			slot_2 = button_settings;
			slot_3 = button_quit;
		
			
			max_options = 3;
			if(selector > max_options)
			{
				selector = 1;
			};
			if(selector < 1)
			{
				selector = max_options;
			};
			
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
			slot_2 = button_volume;
			slot_3 = button_sfx;
		
			
		
			max_options = 3;
			if(selector > max_options)
			{
				selector = 1;
			};
			if(selector < 1)
			{
				selector = max_options;
			};
			
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
					cur_music_volume = clamp(cur_music_volume, 0, 1);
					
					if(cur_music_volume == 0)
					{
						mselect = 0;
					};
					if(cur_music_volume > 0 && cur_music_volume < .5)
					{
						mselect = 1;
					};
					if(cur_music_volume >= .5 && cur_music_volume < 1)
					{
						mselect = 2;
					};
					if(cur_music_volume == 1)
					{
						mselect = 3;
					};
					music_overlay = volume_array[mselect];
					
					
				break;
				
				case 3:
				
					selectorx = slot_3_x;
					selectory = slot_3_y;
					if(key_down)
					{
						cur_sfx_volume -= volume_value;
						sselect--;
				
					};
					if(key_up)
					{
						cur_sfx_volume += volume_value;
						sselect++;
						
					};
					cur_sfx_volume = clamp(cur_sfx_volume, 0, 1);
					
					
					if(cur_sfx_volume == 0)
					{
						sselect = 0;
					};
					if(cur_sfx_volume > 0 && cur_sfx_volume < .5)
					{
						sselect = 1;
					};
					if(cur_sfx_volume >= .5 && cur_sfx_volume < 1)
					{
						sselect = 2;
					};
					if(cur_sfx_volume == 1)
					{
						sselect = 3;
					};
					sfx_overlay = volume_array[sselect];
					
					
					
				break;
				
			};
		
		break;
		
		
		
	};
	
	
	
	
};

