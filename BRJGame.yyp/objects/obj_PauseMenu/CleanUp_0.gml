//reset all paused things
surface_free(pauseSurface);
buffer_delete(pauseSurfaceBuffer);

global.gameDifficultySelected = gameDifficultySelected;
global.gameScreenShakeSelected = gameScreenShakeSelected;
global.gameWindowResolutionSelected = gameWindowResolutionSelected;
global.gameFullscreenSelected = gameFullscreenSelected;

global.gameEffectVolume = gameEffectVolume;
global.gameMusicVolume = gameMusicVolume;

draw_set_font(fnt_normal);
//audio_stop_sound(snd_mainMenuSong);