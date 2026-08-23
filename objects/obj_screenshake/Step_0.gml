//tremendo
if (shake > 0.2)
{
    var _x = random_range(shake, -shake);
    var _y = random_range(shake, -shake);
    
    //tremendo a viewport
    view_set_xport(view_current, _x);
    view_set_yport(view_current, _y);
}
else
{
    //resetando a tela
    shake = 0;
    view_set_xport(view_current, 0);
    view_set_yport(view_current, 0);
}

//parando de tremer
shake = lerp(shake, 0, .1);