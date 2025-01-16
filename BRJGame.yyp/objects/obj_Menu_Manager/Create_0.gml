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
menu_background = spr_menu_background;//Replace with the actual art
button_overlay = spr_Select;//Replace with the actual art
button_options = spr_Options;
button_paused = spr_Paused;
button_press = spr_Press;
button_quit = spr_Quit;
button_select = spr_Select;
button_settings = spr_Settings;
button_start = spr_Start;
button_back = spr_Back;//Replace with the actual art
button_boss_select = spr_Boss_Select;//Replace with the actual art
button_volume = spr_Music;//Replace with the actual art
button_sfx = spr_SFX;//Replace with the actual art
button_arrows = spr_updown_arrow; //Replace with the actual art
button_difficulty = spr_Difficulty; //Replace with the actual art
button_resume = spr_Resume; //Replace with the actual art

volume_mute = spr_mute;//Replace with the actual art
volume_low = spr_low;//Replace with the actual art
volume_mid = spr_mid;//Replace with the actual art
volume_high = spr_high;//Replace with the actual art
volume_array = [ volume_mute, volume_low, volume_mid, volume_high];
boss_1 = spr_temp_boss_1;//Replace with the actual art
boss_2 = spr_temp_boss_2;//Replace with the actual art
boss_3 = spr_temp_boss_3;//Replace with the actual art
//add more here
boss_array = [ boss_1, boss_2, boss_3];
//Add all the bosses to this array for the selector panel

dif_easy = spr_Easy; //Replace with the actual art
dif_medium = spr_Medium; //Replace with the actual art
dif_hard = spr_Hard; //Replace with the actual art
dif_array = [ dif_easy, dif_medium, dif_hard];


global.boss_selected = boss_1; 
//This variable is to give gameManager a readable variable to load the correct boss

global.difficulty = 0; //

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
slot_4 = noone;
slot_5 = noone;
slot_6 = noone;

//Change if you change it's button slot
boss_slotx = slot_4_x;
boss_sloty = slot_4_y;
music_slotx = slot_2_x;
music_sloty = slot_2_y;
sfx_slotx = slot_3_x;
sfx_sloty = slot_3_y;
dif_slotx = slot_5_x;
dif_sloty = slot_5_y;


dif_overlay = dif_easy;
boss_overlay = boss_1;
music_overlay = volume_high;
sfx_overlay = volume_high;

background_scaler = 12;
anim_speed = .5;
frame = 0;
max_options = 0;

bselect = 0; //Boss Selector Panel
mselect = 0; //Music Volume 
sselect = 0; //SFX Volume
dselect = 0; //Dificulty


cur_music_volume = 1;
cur_sfx_volume = 1;
volume_value = .1;

key_left = -1;
key_right = -1;
key_up = -1;
key_down = -1;
key_enter = -1;

///@desc janky function to clear button inputs not set per step when menus are closed
clearButtons = function() {
	key_enter = -1;
}








