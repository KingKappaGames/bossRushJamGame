event_inherited();

waveTrail = global.waveArcTrail;
projectileTrail = global.projectileTrail;

hitRadius = 16 + global.gameDifficultySelected;

angleChange = random_range(-3.2, 3.2) + random_range(-1.4, 1.4); // make the shot arc (roughly centered)

angleDecay = .993 + global.gameDifficultySelected / 500; // maintain curve the higher diff you are

audio_play_sound(choose(snd_airSlash, snd_airSlash2), 0, 0);