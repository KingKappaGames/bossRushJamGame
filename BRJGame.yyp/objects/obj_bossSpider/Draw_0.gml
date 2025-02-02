event_inherited();

var _legPos = 0;
var _legPosGoal = 0;
var _legOrigin = 0;
var _legBeginX = 0;
var _legBeginY = 0;
var _stepDistance = 0;

var _thighSpriteWidth = sprite_get_width(spr_spiderThigh);
var _footSpriteHeight = sprite_get_width(spr_spiderFoot);

var _healthColor = make_color_rgb(255, 255 * (Health / HealthMax), 255 * (Health / HealthMax));

var _legOrder = variable_clone(legPositions);

for(var _i = 0; _i < 8; _i++) {
	_legOrder[_i][0] = _i; // set the x value (useless here so overwriting) to the index of the leg
}

array_sort(_legOrder, function(elm1, elm2)
{
    return elm1[1] - elm2[1]; // sort the position array by position 1 (y value) (thus giving you a sorted list of which indexs go in what order
});

shader_set(shd_frozenHue); // SET SHADER FOR GREY SCALE WHEN FROZEN
shader_set_uniform_f((shader_get_uniform(shd_frozenHue, "u_GrayscaleAmount")), clamp((1 - frozenSpeedMult) * 2, 0, 1)); // twice as greyscale'd as value

var _legDrawI = -1;
for(var _legI = 0; _legI < 8; _legI++) {
	_legDrawI = _legOrder[_legI][0]; // set the leg index based on the next to draw order and the index stored in the array
	
	_legPos = [legPositions[_legDrawI][0], legPositions[_legDrawI][1]]; // rebuild the array to break reference
	_legPosGoal = legPositionGoals[_legDrawI];
	_legOrigin = legOrigins[_legDrawI];
	_stepDistance = max(legStepDistances[_legDrawI], 20); // 20 here is just a filler value to avoid 0s (divide by 0 errors..)
	
	var _stepHeight = dsin(180 * (point_distance(_legPos[0], _legPos[1], _legPosGoal[0], _legPosGoal[1]) / _stepDistance)) * _stepDistance;
	_legPos[1] -= _stepHeight * .4;

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
	
	if(_legOrigin[1] < _legPos[1]) { // if foot below, on screen, base draw foot second
		draw_sprite_ext(spr_spiderThigh, 0, _legOrigin[0], _legOrigin[1], _kneeDist / _footSpriteHeight, 1, _kneeDir, _healthColor, 1);
		draw_sprite_ext(spr_spiderFoot, 0, _legMidX, _legMidY, _footFacingDir, _footDist / _footSpriteHeight, _footDir + 90, _healthColor, 1);
	} else { // else draw foot first (obscured by leg)
		draw_sprite_ext(spr_spiderFoot, 0, _legMidX, _legMidY, _footFacingDir, _footDist / _footSpriteHeight, _footDir + 90, _healthColor, 1);
		draw_sprite_ext(spr_spiderThigh, 0, _legOrigin[0], _legOrigin[1], _kneeDist / _footSpriteHeight, 1, _kneeDir, _healthColor, 1);
	}
}

shader_reset();


//slime stuff

//surface_set_target(script_getDebrisSurface());
//gpu_set_blendmode_ext(bm_src_color, bm_dest_alpha); // why is gpu max just making everything black I don't udnerstand, unless it's adding to each channel ind giving a low max in each channel aka dark grey??
//draw_set_alpha(.3);
//draw_ellipse(x - 20 + irandom_range(-10, 10), y - 12 + irandom_range(-8, 8), x + 20 + irandom_range(-10, 10), y + 12 + irandom_range(-8, 8), false);
//draw_set_alpha(1);
//gpu_set_blendmode(bm_normal);
//surface_reset_target();