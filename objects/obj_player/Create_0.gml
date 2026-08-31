//efeitos
inicia_efeito_squash();
inicia_efeito_brilho();

//velocidade e aplica_velocidade
max_hspd = 2;
hspd = 0;
max_vspd = 5;
vspd = 0;
grav = .3;

//variaveis para pulo duplo
qtd_pulo = 1;
qtd_pulo_atual = qtd_pulo;

//variaveis para coyote jump
coyote_tempo = FPS * .1;
coyote_timer = coyote_tempo;

//variaveis do buffer do pulo
buffer_tempo = 10;
buffer_timer = 0;

//variaveis do corner correction
corner_pixels = 8;

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

//variaveis para sprite
lista_sprite = [spr_player_para, spr_player_idle];
indice = 0;


//metodos de movimentação
inputs = function()
{
    left    = keyboard_check(ord("A"));
    right   = keyboard_check(ord("D"));
    jump    = keyboard_check_pressed(vk_space);
    jump_r  = keyboard_check_released(vk_space);
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
        if (jump || buffer_timer)
        {
            vspd = -max_vspd;
            
            buffer_timer = 0;
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

transicao_sprites = function()
{
    troca_sprite(lista_sprite[indice]);
    
    //quando acabar a animação, muda pra sprite normal
    if (image_index > image_number - 1)
    {
        var _qtd = array_length(lista_sprite) - 1;
        
        if (indice < _qtd) indice++;
    }
}

troca_estado = function(_estado, _sprites)
{
    estado = _estado;
    indice = 0;
    lista_sprite = _sprites;
}



//metodos para pulo
troca_estado_pulo = function()
{
    if (jump || buffer_timer) 
    {
        troca_estado(estado_jump, [spr_player_jump_inicia, spr_player_jump_cima]);
        
        //criando particula de pulo
        var _part = instance_create_depth(x, y, depth - 1, obj_part_player);
        _part.sprite_index = spr_pulo_particula;
        
        //efeito squash
        efeito_squash(.2, 1.8);
    }
    if (!chao)
    {
        troca_estado(estado_jump, [spr_player_jump_inicia, spr_player_jump_cima]);
    }
}

bater_teto = function()
{
    //pegando as colisões fora o oneway
    var _colisoes = [obj_colisor, layer_tilemap_get_id("Tile_Level")];
    
    //se eu bater no teto
    if (place_meeting(x, y + vspd, _colisoes)) 
    {
        var _corner = corner_correction(_colisoes);
        
        //zerando o vspd se ele não teve um corner correction
        if (!_corner) vspd = 0;
    }
}

pulo_controlado = function()
{
    //se parar de apertar o botão de pular, para de subir
    if (jump_r)
    {
        vspd *= .5;
    }
}

pulo_duplo = function()
{
    if (qtd_pulo_atual > 0 && jump)
    {
        //mudando sprite
        indice = 0;
        lista_sprite = [spr_player_jump_inicia, spr_player_jump_cima];
        
        //pulando
        vspd = -max_vspd;
        qtd_pulo_atual--;
    }
}

coyote_jump = function()
{
    checa_chao();
    
    //não toquei no chão
    if (!chao) 
    {
        coyote_timer--;
    }
    //toquei no chão
    else
    {
        coyote_timer = coyote_tempo;
    }
}

pula_coyote_jump = function()
{
    if (coyote_timer > 0 && jump) 
    {
        //mudando sprite
        indice = 0;
        lista_sprite = [spr_player_jump_inicia, spr_player_jump_cima];
        
        //pulando
        vspd = -max_vspd;
        qtd_pulo_atual--;
        
        //criando particula de pulo
        var _part = instance_create_depth(x, y, depth - 1, obj_part_player);
        _part.sprite_index = spr_pulo_particula;
        
        //efeito squash
        efeito_squash(.2, 1.8);
        
        //zerando o coyote timer
        coyote_timer = 0;
    }
}

buffer_jump = function()
{
    inputs();
    checa_chao();
    
    //não toquei no chão
    if (!chao) 
    {
        //pulando no meio do ar
        if (jump) buffer_timer = buffer_tempo;
        
        //diminuindo o buffer
        if (buffer_timer > 0) buffer_timer--;
    }
}

corner_correction = function(_colisoes)
{
    //se estou indo pra cima
    if (vspd < 0)
    {
        //se estou indo pra direita
        //checando todos os pixels da minha borda
        for (var i = 0; i < corner_pixels; i++)
        {
            //vendo se esse pixel está livre
            var _livre = !place_meeting(x + i, y + vspd, _colisoes);
            
            //se estiver livre, eu movo o player até ele
            if (_livre)
            {
                show_debug_message("corner correction");
                
                x = lerp(x, x + i, .2);
                return true;
            }
        }
        
        //se estou indo pra esquerda
        //checando todos os pixels da minha borda
        for (var i = 0; i < corner_pixels; i++)
        {
            //vendo se esse pixel está livre
            var _livre = !place_meeting(x - i, y + vspd, _colisoes);
            
            //se estiver livre, eu movo o player até ele
            if (_livre)
            {
                show_debug_message("corner correction");
                
                x = lerp(x, x - i, .2);
                return true;
            }
        }
    }
    
    return false;
}



//estados de movimentação
estado_idle = function()
{
    aplica_velocidade();
    
    transicao_sprites();
    
    //mudando estado para run
    if (right xor left)
    { 
        troca_estado(estado_run, [spr_player_inicia, spr_player_run]);
    }
    
    //mudando estado para jump
    troca_estado_pulo();
    
    //mudando estado para tinta
    if (tinta && powerup_tinta && chao_tinta) 
    {
        troca_estado(estado_tinta_entrando, [spr_player_tinta_entrar]);
    }
    
    //metodos especiais
    abre_porta();
}

estado_run = function()
{
    aplica_velocidade();
    
    transicao_sprites();
    
    //mudando estado para idle
    if (hspd == 0) 
    {
        troca_estado(estado_idle, [spr_player_para, spr_player_idle]);
    }
    
    //mudando estado para jump
    troca_estado_pulo();
    
    //mudando estado para tinta
    if (tinta && powerup_tinta && chao_tinta) 
    {
        troca_estado(estado_tinta_entrando, [spr_player_tinta_entrar]);
    }
    
    //metodos especiais
    abre_porta();
}

estado_jump = function()
{ 
    static _inicio_pulo = true;
    
    //verificando se estou no inicio do pulo
    if (_inicio_pulo)
    {
        qtd_pulo_atual--;
        
        _inicio_pulo = false;
    }
    
    aplica_velocidade();
    pulo_duplo();
    pula_coyote_jump();
    bater_teto();
    
    //sprite pulando cima
    if (vspd < 0)
    {
        transicao_sprites();
        
        //removendo a colisão oneway
        if (array_contains(colisao, obj_oneway))
        {
            var _pos = array_get_index(colisao, obj_oneway);
            array_delete(colisao, _pos, 1);
        }
        
        pulo_controlado();
    }
    //sprite pulando baixo
    else
    {
        indice = 0;
        lista_sprite = [spr_player_jump_comeca_queda, spr_player_jump_baixo];
        transicao_sprites();
        
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
        
        //avisando que pode iniciar o pulo novamente
        _inicio_pulo = true;
        
        //resetando quantidade de pulos
        qtd_pulo_atual = qtd_pulo;
        
        troca_estado(estado_idle, [spr_player_pousando, spr_player_idle]);
    }
}



//estados powerup   
estado_powerup_inicio = function()
{
    hspd = 0;
    vspd = 0;
    troca_sprite(spr_player_powerup_inicio);
    
    //trocando de estado no fim da animação
    if (image_index > image_number - 1)
    {
        troca_estado(estado_powerup_meio, [spr_player_powerup_meio]);
    }
}

estado_powerup_meio = function()
{
    hspd = 0;
    vspd = 0;
    transicao_sprites();
    
    //saindo do estado se n tem mais particulas entrando em mim
    if (!instance_exists(obj_part_powerup))
    {
        troca_estado(estado_powerup_fim, [spr_player_powerup_fim]);
    }
}

estado_powerup_fim = function()
{
    hspd = 0;
    vspd = 0;
    transicao_sprites();
    
    //trocando de estado no fim da animação
    if (image_index > image_number - 1)
    {
        troca_estado(estado_idle, [spr_player_idle]);
    }
}



//estados tinta
estado_tinta_entrando = function()
{
    transicao_sprites();
    
    //zerando velocidade
    hspd = 0;
    
    //criando particula de tinta entrando
    if (!instance_exists(obj_part_player))
    {
        var _part = instance_create_depth(x, y, depth - 1, obj_part_player);
        _part.sprite_index = spr_tinta_entrar_part;
    }
    
    //trocando de estado no fim da animação
    if (image_index > image_number - 1)
    {
        troca_estado(estado_tinta_loop, [spr_player_tinta_inicia, spr_player_tinta_loop]);
    }
}

estado_tinta_loop = function()
{
    transicao_sprites();
    mask_index = spr_player_tinta_loop;
    
    //ativando movimento
    aplica_velocidade();
    vspd = 0;
    
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
            
            troca_estado(estado_tinta_saindo, [spr_player_tinta_saindo, spr_player_tinta_sair]);
        }
    }
}

estado_tinta_saindo = function()
{
    mask_index = spr_player_idle;
    
    //zerando velocidade
    hspd = 0;
    
    //trocando de estado no fim da animação
    if (image_index >= image_number - 1 && sprite_index == spr_player_tinta_sair)
    {
        troca_estado(estado_idle, [spr_player_idle]);
    }
    
    transicao_sprites();
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

remove_colisao_oneway = function()
{
    if (instance_place(x, y, obj_oneway))
    {
        if (array_contains(colisao, obj_oneway))
        {
            var _index = array_get_index(colisao, obj_oneway);
            array_delete(colisao, _index, 1);
        }
    }
}

restart = function()
{
    if (keyboard_check_pressed(ord("R"))) 
    {
        cria_transicao_inicia(room);
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