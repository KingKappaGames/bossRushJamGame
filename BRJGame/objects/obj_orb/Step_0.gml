x = clamp(x + xChange, 0, room_width);
y = clamp(y + yChange, 0, room_height);

xChange *= speedDecay;
yChange *= speedDecay;