//velocidade e aplica_velocidade
max_hspd = 2;
hspd = 0;
max_vspd = 5;
vspd = 0;
grav = .3;
chao = false;

//variaveis de estado
estado = noone;


//metodos de movimentação
inputs = function()
{
    left    = keyboard_check(ord("A"));
    right   = keyboard_check(ord("D"));
    jump    = keyboard_check_pressed(vk_space);
    
    keyboard_set_map(vk_left, ord("A"));
    keyboard_set_map(vk_right, ord("D"));
}

aplica_velocidade = function()
{
    inputs();
    checa_chao();
    
    //velocidade horizontal
    hspd = (right - left) * max_hspd;
    
    //velocidade vertical (gravidade)
    if (!chao)
    {
        vspd += grav;
    }
    else
    {
        vspd = 0;
        y = round(y);
        
        //pulo
        if (jump)
        {
            vspd = -max_vspd;
            
            //criando particula de pulo
            var _part = instance_create_depth(x, y, depth - 1, obj_part_player);
            _part.sprite_index = spr_pulo_particula;
        }
    }
    
    ajusta_escala();
}

movimento = function()
{
    //aplica_velocidade e colisão
    move_and_collide(hspd, 0, obj_parede, 4); //horizontal
    move_and_collide(0, vspd, obj_parede, 12); //vertical
}

checa_chao = function()
{
    chao = place_meeting(x, y + 1, obj_parede);
}

ajusta_escala = function()
{
    if (hspd != 0) image_xscale = sign(hspd);
}

//metodos de estado
troca_sprite = function(_sprite)
{
    //mudando a sprite e começando no frame 0
    if (sprite_index != _sprite)
    {
        sprite_index = _sprite;
        image_index = 0;
    }
}

//estados de movimentação
estado_idle = function()
{
    aplica_velocidade();
    
    troca_sprite(spr_player_idle);
    
    //mudando estado para run
    if (right xor left)
    {
        estado = estado_run;
    }
    
    //mudando estado para jump
    if (jump) estado = estado_jump;
    if (!chao) estado = estado_jump;
}

estado_run = function()
{
    aplica_velocidade();
    
    troca_sprite(spr_player_run);
    
    //mudando estado para idle
    if (hspd == 0)
    {
        estado = estado_idle;
    }
    
    //mudando estado para jump
    if (jump) estado = estado_jump;
    if (!chao) estado = estado_jump;
}

estado_jump = function()
{
    aplica_velocidade();
    
    //sprite pulando cima
    if (vspd < 0)
    {
        troca_sprite(spr_player_jump_cima);
    }
    //sprite pulando baixo
    else
    {
        troca_sprite(spr_player_jump_baixo);
    }
    
    //saindo do estado
    if (chao)
    {
        //criando particula de pouso
        var _part = instance_create_depth(x, y, depth - 1, obj_part_player);
        _part.sprite_index = spr_pouso_particula;
        
        estado = estado_idle;
    }
}

//estados powerup
estado_powerup_inicio = function()
{
    troca_sprite(spr_player_powerup_inicio);
    
    if (image_index > image_number - 1)
    {
        estado = estado_powerup_meio;
    }
}

estado_powerup_meio = function()
{
    troca_sprite(spr_player_powerup_meio);
    
    if (image_index > image_number - 1)
    {
        estado = estado_powerup_fim;
    }
}

estado_powerup_fim = function()
{
    troca_sprite(spr_player_powerup_fim);
    
    if (image_index > image_number - 1)
    {
        estado = estado_idle;
    }
}

//estados tinta
estado_tinta_entrando = function()
{
    troca_sprite(spr_player_tinta_entrar);
    
    if (image_index > image_number - 1)
    {
        estado = estado_tinta_saindo;
    }
}

estado_tinta_saindo = function()
{
    troca_sprite(spr_player_tinta_sair);
    
    if (image_index > image_number - 1)
    {
        estado = estado_idle;
    }
}

//iniciando meu estado
estado = estado_idle;



#region DEBUGS
    
    view_player = false;
    
    roda_debug = function()
    {
        show_debug_overlay(1);
        
        view_player = dbg_view("Player", true, 20, 80);
        
        //watches
        dbg_watch(ref_create(id, "vspd"), "vspd");
        dbg_watch(ref_create(id, "y"), "y");
        
        //sliders
        dbg_slider(ref_create(id, "max_vspd"), 0, 20, "max_vspd", .1);
        dbg_slider(ref_create(id, "grav"), 0, 1, "grav", .01);
    }
    
    ativa_debug = function()
    {
        //se n ta no modo debug, desativa 
        if (!DEBUG_MODE) return;
        
        if (keyboard_check_pressed(vk_tab))
        {
            //alterando o valor do global.debug
            global.debug = !global.debug;
            
            if (global.debug)
            {
                //rodando o debug do player
                roda_debug();
            }
            else
            {
                show_debug_overlay(0);
                //se o view ta ativo, deleta
                if (dbg_view_exists(view_player))
                {
                    dbg_view_delete(view_player);
                }
            }
        }
    }
    
#endregion