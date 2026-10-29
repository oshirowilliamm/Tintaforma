draw_self();
draw_set_font(fnt_game);
draw_set_halign(1);
draw_set_valign(1);



//player
draw_sprite_ext(sprite, current_time / 100, x - 100, y + 12, image_yscale, image_yscale, 0, c_white, image_alpha);

//texto
var _txt = string("Save {0}", indice);
var _xscale = image_yscale * .3;
var _yscale = image_yscale * .3;

draw_text_transformed(x, y, _txt, _xscale, _yscale, 0);



draw_set_font(-1);
draw_set_halign(-1);
draw_set_valign(-1);