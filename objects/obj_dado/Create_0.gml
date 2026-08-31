estado = noone;
tempo = tempo_troca * FPS;
timer = tempo;

estado_azul = function()
{
    mask_index = sprite_index;
    
    //fica um tempo parado
    if (timer > 0)
    {
        timer--;
        
        //parado no primeiro frame
        image_index = 0;
    }
    //começa a animação
    else
    {
        //quando chegar no frame 8, vai pro prox estado
        if (image_index >= 8)
        {
            timer = tempo;
            estado = estado_roxo;
        }
    }
}

estado_roxo = function()
{
    mask_index = spr_vazio;
    
    //fica um tempo parado
    if (timer > 0)
    {
        timer--;
        
        //parado no frame 9
        image_index = 9;
    }
    //começa a animação
    else
    {
        //quando chegar no final da animação, volta pro outro estado
        if (image_index > image_number - 1)
        {
            timer = tempo;
            estado = estado_azul;
        }
    }
}


//definindo o estado inicial
estado = estado_azul;
if (estado_inicial == "estado_roxo") estado = estado_roxo;