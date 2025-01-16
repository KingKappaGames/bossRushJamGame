/// @description 


//show_debug_message(menu_up);

if(menu_up)
{
	
	key_left = keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left);
	key_right = keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right);
	key_up = keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up);
	key_down = keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down);
	key_enter = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || mouse_check_button_released(mb_left);

}
else
{
	
	selector = 1;
	key_enter = false;
	bselect = 0; //Boss Selector Panel - Reset on menu close
	mselect = 0; //Music Volume - Reset on menu close
	sselect = 0; //SFX Volume - Reset on menu close
	
	if(current_menu == "Settings" && room != rm_Main_Menu)
	{
		current_menu = "Pause Menu";
	};
	
};


audio_group_set_gain(ag_Music, cur_music_volume, 50);
audio_group_set_gain(ag_SFX, cur_sfx_volume, 50);





