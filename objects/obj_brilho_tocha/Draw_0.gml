//escala do brilho fica variando
var _escala = random_range(.3, .32);

//desenhando brilho
gpu_set_blendmode(bm_add);
draw_sprite_ext(spr_brilho, 0, x, y, _escala, _escala, 0, c_white, .15);
gpu_set_blendmode(bm_normal);   