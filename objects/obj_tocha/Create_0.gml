//criando as particulas
ps = part_system_create(ps_brilho_chamas);

//posicionando as particulas em mim
part_system_position(ps, x, y);

//criando a sprite da tocha
layer_sprite_create("Decoracoes", x, y, sprite_index);