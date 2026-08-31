function inicia_efeito_brilho()
{
    xscale  = 1;
    yscale  = 1;
    dir     = 0;
    
    alpha_brilho    = 0;
    cor_brilho      = c_white;
}

function aplica_efeito_brilho(_cor = c_white, _intensidade = 1)
{
    alpha_brilho    = _intensidade;
    cor_brilho      = _cor;
}

function retorna_efeito_brilho(_spd = .1)
{
    alpha_brilho = lerp(alpha_brilho, 0, _spd);
}

function desenha_efeito_brilho()
{
    if (alpha_brilho <= 0) return;
    
    shader_set(sh_muda_cor);
    draw_sprite_ext(sprite_index, image_index, x, y, xscale * dir, yscale, image_angle, cor_brilho, alpha_brilho);
    shader_reset();
}