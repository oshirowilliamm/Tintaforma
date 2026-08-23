alvo = noone
destruir = false;

movendo = function()
{
    //so acontece algo se tem algum alvo
    if (!alvo) return;
    
    //pegando o destino
    var _dest_x = alvo.x
    var _dest_y = alvo.y - 40;
    
    //indo ate a cabeça do player
    x = _dest_x;
    y = _dest_y;
}

explosao = function()
{
    //criando as particulas
    repeat (20) 
    {
    	var _part = instance_create_depth(x, y, depth - 1, obj_part_powerup);
        
        //setando as variaveis das particulas
        _part.speed = random_range(2, 5);
        _part.direction = random_range(0, 359);
        _part.alvo = alvo;
    }
}

destruindo = function()
{
    //verificando se pode destruir
    if (instance_exists(obj_player))
    {
        if (obj_player.estado == obj_player.estado_powerup_fim)
        {
            destruir = true;
        }    
    }
    
    //destruindo
    if (destruir) 
    {
        image_alpha -= .1;
        
        if (image_alpha <= 0) instance_destroy();
    }
}