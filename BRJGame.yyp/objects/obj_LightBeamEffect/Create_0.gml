effectScale = 1;
effectColor = c_white;
effectTimeScale = 1;
effectAge = 0;
effectAgePercent = 0;

effectDuration = 180;
effectAlpha = 1;
beamWidth = 0;

augmentEffect = function(scaleSet = 1, timeScaleSet = 1, colorSet = c_white, alphaSet = 1, volume = 1) {
	effectScale = scaleSet;
	effectTimeScale = timeScaleSet;
	effectColor = colorSet;
	effectAlpha = alphaSet;
}