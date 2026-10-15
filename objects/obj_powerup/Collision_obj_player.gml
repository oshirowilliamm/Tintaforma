if (alvo == noone)
{
    //colocando o player no estado de powerup
    other.estado = other.estado_powerup_inicio;
    
    //avisando q o player é o alvo
    alvo = other.id;
    
    //ações
    movendo();
    explosao();
    
    //avisando o player que pode usar o powerup
    variable_global_set(powerup, true);
    
    //som
    toca_som(snd_powerup);
}