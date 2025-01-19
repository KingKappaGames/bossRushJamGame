/// @description 

if(!menu_up)
{
	exit;
};

//Background

draw_sprite_ext(menu_background, frame, screen_centerx, screen_centery, background_scaler, background_scaler/2, 0, c_white, 1); 
frame += anim_speed;


if(slot_1 != noone)
{
	draw_sprite(slot_1, 0, slot_1_x, slot_1_y);
};
if(slot_2 != noone)
{
	draw_sprite(slot_2, 0, slot_2_x, slot_2_y);
};
if(slot_3 != noone)
{
	draw_sprite(slot_3, 0, slot_3_x, slot_3_y);
};
if(slot_4 != noone)
{
	draw_sprite(slot_4, 0, slot_4_x, slot_4_y);
};
if(slot_5 != noone)
{
	draw_sprite(slot_5, 0, slot_5_x, slot_5_y);
};



draw_sprite(button_select, 0, selectorx, selectory);

//Overlay
if(current_menu == "Main Menu")
{
	//Boss Selector
	draw_sprite(boss_overlay, 0, boss_slotx + 20, boss_sloty - 13); // manual shifting dgaf
	draw_sprite(button_arrows, 0, boss_slotx, boss_sloty - 10);
	//Difficulty Selector
	draw_sprite(dif_overlay, 0, dif_slotx, dif_sloty);
	draw_sprite(button_arrows, 0, dif_slotx, dif_sloty);
	
};
if(current_menu == "Settings")
{
	//Music Selector
	draw_sprite(music_overlay, 0, music_slotx, music_sloty); 
	draw_sprite(button_arrows, 0, music_slotx, music_sloty);
	//SFX Selector
	draw_sprite(sfx_overlay, 0, sfx_slotx, sfx_sloty); 
	draw_sprite(button_arrows, 0, sfx_slotx, sfx_sloty);
	
};











//Clear Slots
slot_1 = noone;
slot_2 = noone;
slot_3 = noone;
slot_4 = noone;
slot_5 = noone;
slot_6 = noone;




