//me desenhando
draw_sprite_ext(sprite_index, image_index, x, y, xscale * dir, yscale, image_angle, image_blend, image_alpha);

//me desenhando com brilho
desenha_efeito_brilho();


//debug
desenha_mascara_colisao();
//draw_text(x, y - 30, buffer_timer);