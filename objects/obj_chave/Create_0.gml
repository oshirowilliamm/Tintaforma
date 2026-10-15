segue_player = false;
abre_porta = false;

alvo = noone;
porta_alvo = noone;
numero = 0;



abrindo_porta = function()
{
    if (!abre_porta) return;
    
    segue_player = false;
    
    //indo ate a porta
    if (instance_exists(porta_alvo))
    {
        tween(id, "x", porta_alvo.x,, 100);
        tween(id, "y", porta_alvo.y - 15,, 100);
    }
    
    //abrindo a porta
    var _dist = abs(x - porta_alvo.x);
    
    if (_dist < .5)
    {
        porta_alvo.estado = porta_alvo.estado_subindo;
        toca_som(snd_porta);
        
        instance_destroy();
        screenshake(20);
    }
    
    exit;
}

seguindo = function()
{
    if (segue_player && instance_exists(alvo))
    {
        //seguindo o player horizontalmente
        var _dist = abs(x - alvo.x);
        var _margem = (15 * numero) * alvo.dir;
        
        if (_dist != _margem)
        {
            tween(id, "x", alvo.x - _margem);
        }
        
        //seguindo o player verticalmente
        var _sinwave = 5 * sin((3 + numero * .1) * current_time / 1000);
        
        tween(id, "y", alvo.y - 15 + _sinwave);
    }
}

