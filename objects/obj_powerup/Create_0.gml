alvo = noone

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
    var _qtd = random_range(20, 40);
    repeat (_qtd) 
    {
    	var _part = instance_create_depth(x, y, depth - 1, obj_part_powerup);
        
        //setando as variaveis das particulas
        _part.speed = random_range(2, 5);
        _part.direction = random_range(0, 359);
        _part.image_blend = choose(#80CAF5, #6E92E2, #6E4EC2, #6038A7, #EEE658, #F9A95F);
        _part.alvo = alvo;
    }
}

destruindo = function()
{
    //destruindo
    if (alvo) 
    {
        image_alpha -= .008;
        
        if (image_alpha <= 0) instance_destroy();
    }
}