/// @description 
draw_self();



//Draw Text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_menu);
draw_set_color(c_grey);
draw_text(x, y, Text);

//Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_normal);
draw_set_color(c_white);

//Selector Icon
if(selected)
{
	image_index = 1;
}
else
{
	image_index = 0;
};

