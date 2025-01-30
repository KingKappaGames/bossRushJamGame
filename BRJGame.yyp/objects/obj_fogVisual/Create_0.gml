depth = -1001;

x = irandom_range(-room_width, room_width * 2);
y = room_height + 99;

var _dir = irandom_range(127, 143);
var _speed = random_range(.25, .33);

xflip = choose(-1, 1);
yflip = choose(-1, 1);

xChange = dcos(_dir) * _speed;
yChange = -dsin(_dir) * _speed;

image_index = irandom(image_number - 1);