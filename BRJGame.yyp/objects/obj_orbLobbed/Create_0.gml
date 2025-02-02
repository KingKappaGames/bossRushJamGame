trailPart = global.fluffPart;
sys = global.partSys;

maxFlightDuration = 999;
flightDuration = maxFlightDuration;

flightMaxHeight = 100;

xChange = 0;
yChange = 0;

audio_stop_sound(snd_orbFlying); // take this line out?
audio_play_sound(snd_orbFlying, 0, 0);