metodo_generico = function(_player)
{
    if (!instance_exists(obj_volta_player))
    {
        var _obj = instance_create_depth(_player.x, _player.y, depth, obj_volta_player);
        _obj.dest_x = 432;
        _obj.dest_y = 384;
        
        screenshake(20);
    }
}