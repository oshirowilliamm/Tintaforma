if (alvo == noone)
{
    other.estado = other.estado_powerup_inicio;
    alvo = other.id;
    movendo();
    explosao();
}