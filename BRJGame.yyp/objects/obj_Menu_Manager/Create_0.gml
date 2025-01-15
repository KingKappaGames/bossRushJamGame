/// @description 



//Make sure sounds are loaded
if(!audio_group_is_loaded(ag_Music))
{
	audio_group_load(ag_Music);
};
if(!audio_group_is_loaded(ag_SFX))
{
	audio_group_load(ag_SFX);
};

//Sprites
menu_background = spr_menu_background;
button_overlay = spr_Select;
button_options = spr_Options;
button_paused = spr_Paused;
button_press = spr_Press;
button_quit = spr_Quit;
button_select = spr_Select;
button_settings = spr_Settings;
button_start = spr_Start;
button_back = spr_Back;



screen_centerx = display_get_gui_width()/2;
screen_centery = display_get_gui_height()/2;
screen_oc_left_x = screen_centerx - (display_get_gui_width()/4);
screen_oc_right_x = screen_centerx + (display_get_gui_width()/4);
screen_oc_lower = screen_centery + (display_get_gui_height()/4);
//Numpad 
slot_1_x = screen_oc_left_x;
slot_1_y = screen_oc_lower;
slot_2_x = screen_centerx;
slot_2_y = screen_oc_lower;
slot_3_x = screen_oc_right_x;
slot_3_y = screen_oc_lower;
slot_4_x = screen_oc_left_x;
slot_4_y = screen_centery;
slot_5_x = screen_centerx;
slot_5_y = screen_centery;
slot_6_x = screen_oc_right_x;
slot_6_y = screen_centery;


current_menu = "Main Menu"; //Main Menu ; Pause Menu ; Settings
selector = 1;
selected = noone;
selectorx = slot_1_x;
selectory = slot_1_y;
menu_up = false;
slot_1 = noone;
slot_2 = noone;
slot_3 = noone;
background_scaler = 12;

cur_music_volume = 1;
cur_sfx_volume = 1;
volume_value = .1;

key_left = -1;
key_right = -1;
key_up = -1;
key_down = -1;
key_enter = -1;












