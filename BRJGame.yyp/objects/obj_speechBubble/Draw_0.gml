//draw_circle(x - 30, y - 2, 24, false);
//draw_circle(x + 5, y + 8, 18, false);
//draw_circle(x + 14, y - 8, 21, false);
//draw_circle(x + 30, y - 3, 23, false);
draw_set_color(c_black);
draw_triangle(originX, originY, x - 10, y, x + 10, y, false);
draw_roundrect_ext(x - messageWidth / 2 - 20, y - 20, x + messageWidth / 2 + 20, y + 20, 20, 20, false);
draw_set_color(c_white);

draw_text(x - messageWidth / 2, y - 3, displayMessage);