/// @description 

if(!menu_up)
{
	exit;
};

//Background
draw_sprite_ext(menu_background, 0, screen_centerx, screen_centery, background_scaler, background_scaler/2, 0, c_white, 1); 



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


draw_sprite(button_select, 0, selectorx, selectory);


