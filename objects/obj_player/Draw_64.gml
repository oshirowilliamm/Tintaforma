if (chaves > 0)
{
    draw_set_halign(1);
    draw_set_valign(1);
    
    var _x = 40;
    var _y = 40;
    draw_sprite_ext(spr_chave_ui, 0, _x, _y, 4, 4, 0, c_white, 1);
    draw_text(_x + 40, _y, chaves);
    
    draw_set_halign(-1);
    draw_set_valign(-1);
}