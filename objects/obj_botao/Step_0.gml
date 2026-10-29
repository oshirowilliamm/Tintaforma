var _mouse_sobre    = position_meeting(mouse_x, mouse_y, id);
var _mouse          = mouse_check_button(mb_left);
var _mouse_released = mouse_check_button_released(mb_left);


if (_mouse_sobre)
{
    if (_mouse)
    {
        tween(id, "image_xscale", xscale - .2, tween_animation.flat);
        tween(id, "image_yscale", yscale - .2, tween_animation.flat);
        tween(id, "image_alpha", .9, tween_animation.flat);
        sprite = spr_player_run;
    }
    else
    {
        tween(id, "image_xscale", xscale + .2);
        tween(id, "image_yscale", yscale + .2);
        tween(id, "image_alpha", .9);
        sprite = spr_player_run;
    }
    
    if (_mouse_released)
    {
        global.save_atual = indice;
        load_game();
        cria_transicao_inicia(global.room_atual);
    }
}
else
{
    tween(id, "image_xscale", xscale);
    tween(id, "image_yscale", yscale);
    tween(id, "image_alpha", .7);
    sprite = spr_player_idle;
}