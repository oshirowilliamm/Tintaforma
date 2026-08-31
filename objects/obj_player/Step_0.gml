movimento();
estado();
remove_colisao_oneway();

//efeitos
retorna_squash();
retorna_efeito_brilho();


//debug
ativa_debug();
if (keyboard_check_pressed(ord("R"))) cria_transicao_inicia(room);