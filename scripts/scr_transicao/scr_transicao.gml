// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações


//Chame essa função para criar a transição
//Não esqueça de definir um destino válido
///@param {room} _destino room_destino da transição
function cria_transicao_inicia(_destino = noone)
{
    if (!room_exists(_destino)) 
    {
        show_message("defina um destino")
        return;
    }
    
    //Criando o objeto transição
    var _transicao = instance_create_depth(0, 0, 0, obj_transicao, { destino: _destino});
    
}

//Função de transição
//O objeto transição vai usar ela para criar a sequence de transição inicial
function fazendo_transicao(_sq = sq_transicao_1)
{
    //Criando a camada de transição se ela não existe
    if (!layer_exists("transicao"))
    {
        layer_create(-100, "transicao");    
    }
    
    
    //Pegando a posição da câmera para criar a transição no local correto
    var _cam_x = camera_get_view_x(view_camera[0]);
    var _cam_y = camera_get_view_y(view_camera[0]);

    layer_sequence_create("transicao", _cam_x, _cam_y, _sq);
}


//Destruindo a sequencia da transição no final dela
function destruindo_layer_transicao()
{
    if (layer_exists("transicao"))
    {
        layer_destroy("transicao");
    }
}