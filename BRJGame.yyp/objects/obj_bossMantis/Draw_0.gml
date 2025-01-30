shader_set(shd_greyScale);
shader_set_uniform_f((shader_get_uniform(shd_greyScale, "u_GrayscaleAmount")), clamp((1 - frozenSpeedMult) * 2, 0, 1));

var _legPos = 0;
var _legPosGoal = 0;
var _legOrigin = 0;
var _stepDistance = 0;

var _thighSpriteWidth = sprite_get_width(spr_mantisLegSegment);
var _footSpriteHeight = sprite_get_width(spr_mantisLegSegment);

var _legOrder = variable_clone(legPositions);
array_push(_legOrder, [-1, y]);

for(var _i = 0; _i < 4; _i++) {
	_legOrder[_i][0] = _i; // set the x value (useless here so overwriting) to the index of the leg
}

array_sort(_legOrder, function(elm1, elm2)
{
    return elm1[1] - elm2[1]; // sort the position array by position 1 (y value) (thus giving you a sorted list of which indexs go in what order
});

shader_set(shd_greyScale); // SET SHADER FOR GREY SCALE WHEN FROZEN
shader_set_uniform_f((shader_get_uniform(shd_greyScale, "u_GrayscaleAmount")), clamp((1 - frozenSpeedMult) * 2, 0, 1)); // twice as greyscale'd as value

var _healthColor = make_color_rgb(255, 255 * (Health / HealthMax), 255 * (Health / HealthMax));

var _legDrawI = -1;
for(var _legI = 0; _legI < 5; _legI++) {
	_legDrawI = _legOrder[_legI][0]; // set the leg index based on the next to draw order and the index stored in the array
	
	if(_legDrawI == -1) { // BODY
		
		var _backAngle = state == "cast" ? backArmSwingAngle : dsin((current_time + 280) / 3) * 20;
		
		draw_sprite_ext(spr_mantisArms, 0, x + 8 * directionFacing, y - 25, image_xscale * directionFacing, image_yscale, _backAngle, _healthColor, 1);

		draw_sprite_ext(sprite_index, 0, x, y, image_xscale * directionFacing, image_yscale, image_angle, _healthColor, 1);

		draw_sprite_ext(sprite_index, 1, x + 19 * directionFacing, y - 29, image_xscale * headFacing, image_yscale, image_angle, _healthColor, 1);

		var _armImage = 1;
		if(state == "slashBasic") {
			if(armSwingStartTime < current_time) {
				_armImage = ((current_time - armSwingStartTime) / (armSwingEndTime - armSwingStartTime)) * (sprite_get_number(spr_mantisArms) - 2) + 1; // progression fraction
			}
		}
		
		var _frontAngle = state == "cast" ? frontArmSwingAngle : dsin(current_time / 3) * 20;
		
		draw_sprite_ext(spr_mantisArms, _armImage, x + 14 * directionFacing, y - 10, image_xscale * directionFacing, image_yscale, _frontAngle, _healthColor, 1);
	} else {
	
		_legPos = [legPositions[_legDrawI][0], legPositions[_legDrawI][1]]; // rebuild the array to break reference
		_legPosGoal = legPositionGoals[_legDrawI];
		_legOrigin = legOrigins[_legDrawI];
		_stepDistance = max(legStepDistances[_legDrawI], 20); // 20 here is just a filler value to avoid 0s (divide by 0 errors..)
	
		var _stepHeight = dsin(180 * (point_distance(_legPos[0], _legPos[1], _legPosGoal[0], _legPosGoal[1]) / _stepDistance)) * power(_stepDistance, .75);
		_legPos[1] -= _stepHeight;

		var _distFoot = point_distance(x, y, _legPos[0], _legPos[1]);
		var _footJointDist = sqrt(abs(sqr(legSegLen) - sqr(_distFoot / 2))); // abs does nothing here in theory but if you ever get a negative number (which again you shouldn't but hey) it'll make it positive. Presumably this negative number would be tiny and the difference would be unnoticable. Ergo abs is the easiest way to prevent the negative besides clamp with is ugly

		var _legMidX = (_legOrigin[0] + _legPos[0]) / 2;
		var _legMidY = (_legOrigin[1] + _legPos[1]) / 2 - _footJointDist;
	
		var _kneeDir = point_direction(_legOrigin[0], _legOrigin[1], _legMidX, _legMidY);
		var _footDir = point_direction(_legMidX, _legMidY, _legPos[0], _legPos[1]);
		var _kneeDist = point_distance(_legOrigin[0], _legOrigin[1], _legMidX, _legMidY);
		var _footDist = point_distance(_legMidX, _legMidY, _legPos[0], _legPos[1]);
	
		var _footWidth = -dcos(_footDir);
	
		//var _footFacingDir = _footWidth / 2 + sign(_footWidth) / 2;
	
		if(_legOrigin[1] < _legPos[1]) { // if foot below, on screen, base draw foot second
			draw_sprite_ext(spr_mantisLegSegment, 0, _legOrigin[0], _legOrigin[1], _kneeDist / _footSpriteHeight, 1, _kneeDir, _healthColor, 1);
			draw_sprite_ext(spr_mantisLegSegment, 0, _legMidX, _legMidY, _footDist / _footSpriteHeight, 1, _footDir, _healthColor, 1);
		} else { // else draw foot first (obscured by leg)
			draw_sprite_ext(spr_mantisLegSegment, 0, _legMidX, _legMidY, _footDist / _footSpriteHeight, 1, _footDir, _healthColor, 1);
			draw_sprite_ext(spr_mantisLegSegment, 0, _legOrigin[0], _legOrigin[1], _kneeDist / _footSpriteHeight, 1, _kneeDir, _healthColor, 1);
		}
	}
}

shader_reset();