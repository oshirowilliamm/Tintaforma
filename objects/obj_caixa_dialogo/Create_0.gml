scribble_anim_wave(.5, .1, .1);

image_alpha = 0;
image_xscale = 0;
image_yscale = 0;

texto = "";

//variaveis de controle
destroi = false;
desenha_texto = false;
alpha = 0;



iniciando = function()
{
    if (destroi) return;
    
    //aparecendo
    image_alpha = lerp(image_alpha, .8, .1);
    
    //crescendo
    image_xscale = lerp(image_xscale, 2.5, .1);
    image_yscale = lerp(image_yscale, 1, .1);
    
    //indo pra cima
    y = lerp(y, ystart - 25, .1);
    
    //se tiver subindo o suficiente, mostra o texto
    if (y <= ystart - 24) desenha_texto = true;
}

destruindo = function()
{
    if (!destroi) return;
    
    //diminuindo
    image_xscale = lerp(image_xscale, 0, .2);
    image_yscale = lerp(image_yscale, 0, .2);
    
    //se apagando
    image_alpha = lerp(image_alpha, 0, .2);
    
    //descendo
    y = lerp(y, ystart, .3);
    
    //apagando o texto
    desenha_texto = false;
    
    //se destruindo
    if (image_alpha <= .01)
    {
        instance_destroy();
    }
}

desenha_dialogo = function()
{
    if (!desenha_texto) return;
    
    var _margem = 5;
    var _x = x - sprite_width / 2 + _margem;
    var _y = y - sprite_height + 2;
    
    var _txt = scribble(texto);
    _txt.starting_format("fnt_game", c_white)
        .scale(.1)
        .wrap(sprite_width - _margem * 2)
        .draw(_x, _y);
}