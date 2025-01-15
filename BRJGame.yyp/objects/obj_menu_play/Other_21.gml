/// @description 

//Set to Game Room
global.is_paused = false;
room_goto(rm_grassyArena);

audio_stop_sound(snd_mainMenuSong); 
audio_play_sound(snd_bossGenericTheme, 10, true);