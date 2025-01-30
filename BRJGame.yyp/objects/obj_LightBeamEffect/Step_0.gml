effectAge += effectTimeScale;
effectAgePercent = effectAge / effectDuration;

if(effectAge > effectDuration) {
	instance_destroy();
}

beamWidth = effectScale  * random_range(.8, 1.2) * clamp((1 - effectAgePercent) * 4, 0, 1); 