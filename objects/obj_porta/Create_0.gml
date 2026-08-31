estado = noone;

#region Criando as particulas
    
    //ps_porta_abrindo
    ps = part_system_create();
    part_system_draw_order(ps, true);
    
    //Emitter1
    ptype1 = part_type_create();
    part_type_shape(ptype1, pt_shape_smoke);
    part_type_size(ptype1, 1, 2, 0, 0);
    part_type_scale(ptype1, 0.1, 0.1);
    part_type_speed(ptype1, 0.1, 0.1, 0, 0);
    part_type_direction(ptype1, 80, 100, 0, 0);
    part_type_gravity(ptype1, 0, 270);
    part_type_orientation(ptype1, 0, 0, 0, 0, false);
    part_type_colour3(ptype1, $B2B2B2, $7F7F7F, $333333);
    part_type_alpha3(ptype1, 1, 0.824, 0.549);
    part_type_blend(ptype1, false);
    part_type_life(ptype1, 20, 30);
    
#endregion



estado_parado = function() {};

estado_subindo = function()
{
    //subindo
    y -= .5;
    
    //efeitos
    screenshake(3);
    x = xstart + random_range(-1, 1);
    
    //criando as particulas
    var _xpart = xstart + random_range(-sprite_width / 1.5, sprite_width / 1.5);
    var _ypart = ystart - sprite_height;
    part_particles_create(ps, _xpart, _ypart, ptype1, 1);
    
    //se subir o suficiente, eh destruido
    if (y < ystart - sprite_height) 
    {
        estado = estado_aberto;
        
        //alarme para destruir as particulas
        alarm[0] = FPS;
    }
}

estado_aberto = function() {};

estado = estado_parado;