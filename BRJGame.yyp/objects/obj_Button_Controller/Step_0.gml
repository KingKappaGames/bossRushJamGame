/// @description 

if(keyboard_check_released(vk_right))
{
	with array_menu_buttons[selector]
	{
		selected = false;
	};
	selector++;
	
}
else if(keyboard_check_released(vk_left))
{
	with array_menu_buttons[selector]
	{
		selected = false;
	};
	selector--;
};
if(selector < 0 || selector > (array_length(array_menu_buttons) - 1))
{
	selector = 0;
};
var obj_to_select = array_menu_buttons[selector];
if(!mouse_moving)
{
	
	
	with obj_to_select
	{
		selected = true;
	};
	
}
else
{
	with obj_to_select
	{
		selected = false;
	};
};
	
