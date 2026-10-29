



metodo_generico = function(_player) {};

metodo_define_posicao = function(_player)
{   
    global.spawn_x = dest_x;
    global.spawn_y = dest_y;
    
    instance_destroy();
}

metodo_trava_player = function(_player)
{
    with (_player) 
    {
        visible = false;
    	hspd = 0;
        troca_estado(estado_sem_controle);
    }
}

metodo_retorna_player = function(_player)
{
    if (!instance_exists(obj_volta_player))
    {
        //criando o volta player
        var _obj = instance_create_depth(_player.x, _player.y, depth, obj_volta_player);
        
        //passando infos pro volta player
        _obj.dest_x = dest_x;
        _obj.dest_y = dest_y;
        _obj.sprite = _player.sprite_index;
        _obj.xscale = _player.dir;
        
        screenshake(30);
    }
}

//iniciando o metodo dependendo do modo escolhido
metodo_generico = variable_instance_get(id, modo);