//efeitos
inicia_efeito_squash();
inicia_efeito_brilho();

//velocidade e aplica_velocidade
max_hspd = 2;
hspd = 0;
max_vspd = 5;
vspd = 0;
grav = .3;

//verifica se ta colidindo com o chao
chao = false;
chao_tinta = false;
layer_tinta = layer_tilemap_get_id("Tile_Tinta");

//variaveis de estado
estado = noone;
powerup_tinta = false;

dir = 1; //direção para espelhar o player

colisao = [layer_tilemap_get_id("Tile_Level"), obj_colisor]; //colisoes do player

chaves = 0; //quantidade de chaves q tenho


//metodos de movimentação
inputs = function()
{
    left    = keyboard_check(ord("A"));
    right   = keyboard_check(ord("D"));
    jump    = keyboard_check_pressed(vk_space);
    tinta   = keyboard_check_pressed(ord("E"));
    
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
            
            //efeito squash
            efeito_squash(.2, 1.8);
        }
    }
    
    //limitando vspd
    vspd = clamp(vspd, -max_vspd, max_vspd);
    
    ajusta_escala();
}

movimento = function()
{
    //aplica_velocidade e colisão
    move_and_collide(hspd, 0, colisao, 4); //horizontal
    move_and_collide(0, vspd, colisao, 12); //vertical
}

checa_chao = function()
{
    chao = place_meeting(x, y + 1, colisao);
    chao_tinta = place_meeting(x, y + 1, layer_tinta);
}

ajusta_escala = function()
{
    if (hspd != 0) dir = sign(hspd);
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

troca_estado_animacao = function(_estado)
{
    if (image_index > image_number - 1)
    {
        estado = _estado;
    }
}



//estados de movimentação
estado_idle = function()
{
    aplica_velocidade();
    
    troca_sprite(spr_player_idle);
    
    //mudando estado para run
    if (right xor left) estado = estado_run;
    
    //mudando estado para jump
    if (jump) estado = estado_jump;
    if (!chao) estado = estado_jump;
    
    //mudando estado para tinta
    if (tinta && powerup_tinta && chao_tinta) 
    {
        estado = estado_tinta_entrando;
    }
    
    //metodos especiais
    abre_porta();
}

estado_run = function()
{
    aplica_velocidade();
    
    troca_sprite(spr_player_run);
    
    //mudando estado para idle
    if (hspd == 0) estado = estado_idle;
    
    //mudando estado para jump
    if (jump) estado = estado_jump;
    if (!chao) estado = estado_jump;
    
    //mudando estado para tinta
    if (tinta && powerup_tinta && chao_tinta) 
    {
        estado = estado_tinta_entrando;
    }
    
    //metodos especiais
    abre_porta();
}

estado_jump = function()
{
    aplica_velocidade();
    
    //sprite pulando cima
    if (vspd < 0)
    {
        troca_sprite(spr_player_jump_cima);
        
        //removendo a colisão oneway
        if (array_contains(colisao, obj_oneway))
        {
            var _pos = array_get_index(colisao, obj_oneway);
            array_delete(colisao, _pos, 1);
        }
    }
    //sprite pulando baixo
    else
    {
        troca_sprite(spr_player_jump_baixo);
        
        //adicionando a colisão oneway
        if (!place_meeting(x, y, obj_oneway))
        {
            if (!array_contains(colisao, obj_oneway))
            {
                array_push(colisao, obj_oneway);
            }
        }
    }
    
    //saindo do estado
    if (chao)
    {
        //criando particula de pouso
        var _part = instance_create_depth(x, y, depth - 1, obj_part_player);
        _part.sprite_index = spr_pouso_particula;
        
        //efeito squash
        efeito_squash(1.2, .5);
        
        estado = estado_idle;
    }
}



//estados powerup
estado_powerup_inicio = function()
{
    hspd = 0;
    vspd = 0;
    troca_sprite(spr_player_powerup_inicio);
    troca_estado_animacao(estado_powerup_meio);
}

estado_powerup_meio = function()
{
    hspd = 0;
    vspd = 0;
    troca_sprite(spr_player_powerup_meio);
    
    //saindo do estado se n tem mais particulas entrando em mim
    if (!instance_exists(obj_part_powerup))
    {
        estado = estado_powerup_fim;
    }
}

estado_powerup_fim = function()
{
    hspd = 0;
    vspd = 0;
    troca_sprite(spr_player_powerup_fim);
    troca_estado_animacao(estado_idle);
}



//estados tinta
estado_tinta_entrando = function()
{
    troca_sprite(spr_player_tinta_entrar);
    
    //zerando velocidade
    hspd = 0;
    
    //criando particula de tinta entrando
    if (!instance_exists(obj_part_player))
    {
        var _part = instance_create_depth(x, y, depth - 1, obj_part_player);
        _part.sprite_index = spr_tinta_entrar_part;
    }
    
    
    troca_estado_animacao(estado_tinta_loop);
}

estado_tinta_loop = function()
{
    troca_sprite(spr_player_tinta_loop);
    mask_index = spr_player_tinta_loop;
    
    //ativando movimento
    aplica_velocidade();
    
    //limitando o movimento no chao de tinta
    var _x = x + (hspd * 11);
    if (!place_meeting(_x, y + 1, layer_tinta))
    {
        hspd = 0;
    }
    
    //saindo da tinta quando eu apertar o botao
    if (tinta) 
    {
        //só saio se n tiver uma colisão em cima de mim
        if (!place_meeting(x, y - 10, colisao))
        {
            //particula de tinta entrando
            var _part = instance_create_depth(x, y, depth - 1, obj_part_player);
            _part.sprite_index = spr_tinta_sair_part;
            
            estado = estado_tinta_saindo;
        }
    }
}

estado_tinta_saindo = function()
{
    troca_sprite(spr_player_tinta_sair);
    mask_index = spr_player_idle;
    
    //zerando velocidade
    hspd = 0;
    
    troca_estado_animacao(estado_idle);
}



//iniciando meu estado
estado = estado_idle;



//outros metodos
abre_porta = function()
{
    //colidindo com a porta
    var _porta = instance_place(x + hspd, y, obj_porta);
    
    if (_porta)
    {
        //se tem chaves e a porta esta parada
        if (chaves > 0 && _porta.estado == _porta.estado_parado)
        {
            //faz a porta subir
            _porta.estado = _porta.estado_subindo;
            
            //tirando a chave
            chaves--;
        }
    }
}



#region DEBUGS
    
    view_player = false;
    
    roda_debug = function()
    {
        show_debug_overlay(1);
        
        view_player = dbg_view("Player", true, 20, 80);
        
        //watches
        dbg_watch(ref_create(id, "vspd"), "vspd"); //vspd
        dbg_watch(ref_create(id, "y"), "y"); //y
        
        //sliders
        dbg_slider(ref_create(id, "max_vspd"), 0, 20, "max_vspd", .1); 
        dbg_slider(ref_create(id, "grav"), 0, 1, "grav", .01);
        
        //powerup tinta
        dbg_checkbox(ref_create(id, "powerup_tinta"), "Powerup Tinta"); 
        
        //draw mask
        dbg_checkbox(ref_create(id, "draw_mask"), "Máscara de Colisão");
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
    
    draw_mask = false
    desenha_mascara_colisao = function()
    {
        if (draw_mask)
        {
            draw_set_colour(c_fuchsia);
            
            //fundo
            draw_set_alpha(.2);
            draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, 0);
            
            //out
            draw_set_alpha(1);
            draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, 1);
            
            draw_set_colour(-1);
            
        }
    }
    
#endregion