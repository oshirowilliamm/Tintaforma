function inicia_efeito_squash()
{
    //tamanho do player
    xscale = 1;
    yscale = 1;
}

function efeito_squash(_xscale, _yscale)
{
    xscale = _xscale;
    yscale = _yscale;   
}

function retorna_squash(_qtd = .1)
{
    xscale = lerp(xscale, 1, _qtd);
    yscale = lerp(yscale, 1, _qtd);
}

function desenha_efeito_squash()
{
    draw_sprite_ext(sprite_index, image_index, x, y, xscale, yscale, image_angle, image_blend, image_alpha);
}