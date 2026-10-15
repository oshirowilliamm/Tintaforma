var _dist = point_distance(x, y, dest_x, dest_y);

//se ainda n cheguei no dest
if (_dist > 2)
{
    //criando o rastro do player
    instance_create_depth(x, y, -100, obj_rastro_player);
    
    //camera me seguindo
    camera_set_view_target(view_camera[0], id);
    
    //indo ate o destino
    x = lerp(x, dest_x, .1);
    y = lerp(y, dest_y, .1);
}
//se ja cheguei
else
{
    if (instance_exists(obj_player))
    {
        with (obj_player) 
        {
            //camera me seguindo
            camera_set_view_target(view_camera[0], id);
            
            //colocando o player no dest
        	x = other.dest_x;
            y = other.dest_y;
            
            //permitindo ele se mover
            troca_estado(estado_idle);
        }
        
        //destruindo o obj_volta_player
        instance_destroy();
    }
}