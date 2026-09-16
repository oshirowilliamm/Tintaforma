#macro DEBUG_MODE false
#macro normal:DEBUG_MODE false
#macro debug:DEBUG_MODE true

#macro FPS game_get_speed(gamespeed_fps)

global.debug = false;



//cores
scribble_color_set("txt_yellow", #FFCA00);



//funcoes
function toca_som(snd, _pitch = 0)
{
    var _p = random_range(1 - _pitch, 1 + _pitch);
    audio_play_sound(snd, 0, 0,,, _p);
}