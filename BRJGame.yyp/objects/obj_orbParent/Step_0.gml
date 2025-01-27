x = clamp(x + xChange, -9999, 9999);
y = clamp(y + yChange, 0, room_height);

xChange *= speedDecay;
yChange *= speedDecay;