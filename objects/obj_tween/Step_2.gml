
//Se meu alvo não existe, eu me destruo
if (!is_struct(object) && !instance_exists(object)) {instance_destroy(); exit;}

// Guarda se fui chamado neste frame e zera para o próximo
chamado_anterior = chamado;
chamado          = false;

percent += 1/time;
percent = clamp(percent, 0, 1);
position = animcurve_channel_evaluate(anim_curve, percent);

if (percent < 1)
{
    object[$ variable_name] = base + (value - base) * position;
}
else
{
    object[$ variable_name] = value;

    // Terminou a ida de um tween com retorno: inverte e começa a volta
    if (retorno && !voltando)
    {
        voltando = true;
        base     = value;
        value    = origem;
        percent  = 0;
        exit;
    }

    if (callback != -1)
    {
        var _dono = method_get_self(callback);
        if (_dono == undefined || is_struct(_dono) || instance_exists(_dono)) callback();
    }
    instance_destroy();
}