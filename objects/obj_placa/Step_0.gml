//criando a caixa de dialogo quando o player encostar
if (place_meeting(x, y, obj_player))
{
    if (!instance_exists(dialogo))
    {
        dialogo = instance_create_layer(x, y, "Dialogo", obj_caixa_dialogo);
        dialogo.texto = texto;
    }
}
//destruindo a caixa de dialogo
else
{
    if (instance_exists(dialogo))
    {
        dialogo.destroi = true;
    }
}