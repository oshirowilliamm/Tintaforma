if (!alvo) exit;

//alternando opacidade
image_alpha = speed / 6;

//se esticando 
image_xscale = lerp(image_xscale, speed * 5, .1);
image_angle = direction;


//explodindo
if (!spd_zerada)
{
    //perdendo velocidade
    speed -= .08;
    
    //avisando que estou voltando
    if (speed <= 0)
    {
        spd_zerada = true;
        
        //definindo a direção
        var _x = alvo.x + random_range(-5, 5);
        var _y = alvo.y - 12 + random_range(-5, 5);
        direction = point_direction(x, y, _x, _y);
    }
}    
//indo até o player
else
{
    //aplicando velocidade
    speed += .3;
    
    var _player = instance_place(x, y, alvo);
    
    //se destruindo
    if (_player)
    {
        //efeitos no player
        with (_player) 
        {
            //squash
            if (variable_global_exists("efeito_squash"))
            {
                var _escala = random_range(-.1, .3);
                efeito_squash(1 + _escala, 1 + _escala);
            }
            
            //brilho
            if (variable_global_exists("aplica_efeito_brilho"))
            {
                aplica_efeito_brilho(, .8);
            }
        }
        
        //efeito de screenshake
        if (variable_global_exists("screenshake"))
        {
            screenshake(5);
        }
        
        instance_destroy(id);
    }
}
