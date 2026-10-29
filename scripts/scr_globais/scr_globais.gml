//variaveis de powerup
global.powerup_tinta = false; 
global.powerup_run   = false;

//spawn do player no hub world
global.spawn_x = 56;
global.spawn_y = 576;
global.room_atual = rm_mundo;

global.save_atual = 1;

//função para salvar o jogo
function save_game()
{
    //struct dos meus dados
    var _powerups =
    {
        powerup_tinta: global.powerup_tinta,
        powerup_run: global.powerup_run,
    };
    
    var _player =
    {
        spawn_x: global.spawn_x,
        spawn_y: global.spawn_y,
        room_atual: global.room_atual,
    };
    
    var _struct =
    {
        powerups: _powerups,
        player: _player,
    }
    
    //convertendo a struct em string 
    var _data = json_stringify(_struct);
    
    //criando o buffer
    var _buff = buffer_create(0, buffer_grow, 1);
    
    //colocando o texto dentro do buffer
    buffer_write(_buff, buffer_string, _data);
    
    //salvando o buffer
    buffer_save(_buff, string("saveteste{0}.json", global.save_atual));
    
    //deletando o buffer dps de ter usado ele
    buffer_delete(_buff);
}

//função para carregar o jogo
function load_game()
{
    //carregando o buffer
    var _arquivo = string("saveteste{0}.json", global.save_atual);
    var _buff = buffer_load(_arquivo);
    
    //se eu consegui carregar o arquivo
    if (_buff == -1) return;
    
    //convertendo o arquivo pra texto
    var _string = buffer_read(_buff, buffer_string);
    
    //convertendo o json pra struct
    var _struct = json_parse(_string);
    
    //passando as infos para as variaveis globais
    global.powerup_tinta = _struct.powerups.powerup_tinta;
    global.powerup_run = _struct.powerups.powerup_run;
    global.spawn_x = _struct.player.spawn_x;
    global.spawn_y = _struct.player.spawn_y;
    global.room_atual = _struct.player.room_atual;
    
    //deletando o buffer dps de ter usado ele
    buffer_delete(_buff);
}