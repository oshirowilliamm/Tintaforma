if (!segue_player && !abre_porta)
{
    //aumenta o contador de chaves
    other.minha_chaves[other.chaves] = id;
    other.chaves++;
    
    //pegando o numero da chave
    numero = other.chaves;
    
    //som
    toca_som(snd_chave);
    
    //seguindo o player
    segue_player = true;
    alvo = other.id;
}