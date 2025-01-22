var _alphaFlash = 1;
if(immunityFrames > 0) {
	_alphaFlash = .4 + round(current_time % 250 / 250) * .6; // flashing while immune
}

draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, image_angle + 90, image_blend, image_alpha * _alphaFlash);
draw_set_alpha(1);
draw_set_color(c_white); // undo hit and immune visual effects

draw_circle_color(x, y, 10 - (Health / HealthMax) * 10, c_red, #880000, false);

#region leg stuff
var _legPos = 0;
var _legPosGoal = 0;
var _legOrigin = 0;
var _legBeginX = 0;
var _legBeginY = 0;

var _thighSpriteWidth = sprite_get_height(spr_spiderPlayerThigh);
var _footSpriteHeight = sprite_get_height(spr_spiderPlayerFoot);

var _legOrder = variable_clone(legPositions);

for(var _i = 0; _i < 8; _i++) {
	_legOrder[_i][0] = _i; // set the x value (useless here so overwriting) to the index of the leg
}

array_sort(_legOrder, function(elm1, elm2)
{
    return elm1[1] - elm2[1]; // sort the position array by position 1 (y value) (thus giving you a sorted list of which indexs go in what order
});

var _legDrawI = -1;
for(var _legI = 0; _legI < 8; _legI++) {
	_legDrawI = _legOrder[_legI][0]; // set the leg index based on the next to draw order and the index stored in the array
	_legPos = legPositions[_legDrawI];
	_legPosGoal = legPositionGoals[_legDrawI];
	_legOrigin = legOrigins[_legDrawI];

	var _distFoot = point_distance(x, y, _legPos[0], _legPos[1]);
	var _footJointDist = sqrt(abs(sqr(legSegLen) - sqr(_distFoot / 2))); // abs does nothing here in theory but if you ever get a negative number (which again you shouldn't but hey) it'll make it positive. Presumably this negative number would be tiny and the difference would be unnoticable. Ergo abs is the easiest way to prevent the negative besides clamp with is ugly

	var _legMidX = (_legOrigin[0] + _legPos[0]) / 2;
	var _legMidY = (_legOrigin[1] + _legPos[1]) / 2 - _footJointDist;
	
	var _kneeDir = point_direction(_legOrigin[0], _legOrigin[1], _legMidX, _legMidY);
	var _footDir = point_direction(_legMidX, _legMidY, _legPos[0], _legPos[1]);
	var _kneeDist = point_distance(_legOrigin[0], _legOrigin[1], _legMidX, _legMidY);
	var _footDist = point_distance(_legMidX, _legMidY, _legPos[0], _legPos[1]);
	
	var _footWidth = -dcos(_footDir);
	
	var _footFacingDir = _footWidth / 2 + sign(_footWidth) / 2;
	
	draw_sprite_ext(spr_spiderPlayerFoot, 0, _legMidX, _legMidY, _footFacingDir, _footDist / _footSpriteHeight, _footDir + 90, c_white, 1);
	draw_sprite_ext(spr_spiderPlayerThigh, 0, _legOrigin[0], _legOrigin[1], _kneeDist / _thighSpriteWidth, 1, _kneeDir, c_white, 1);
}
#endregion

if(instance_exists(orbLinkFromId)) {
	draw_line_width_color(orbLinkFromId.x, orbLinkFromId.y, handX, handY, 3, c_white, c_ltgray);
}