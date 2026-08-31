/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

//Deixando o objeto persistente, isso garante que ao trocar de room
//Ele não vai ser destruido para poder criar as duas sequencias
persistent = true;
//Chamando a função que realmente cria a sequence.
//Este objeto só é usado para ser persistente e criar as duas sequences
//A variável destino dele é criada na função que cria a transição
fazendo_transicao();

//Definindo o alarme para 30 frames porque a sequencia tem 30 frames
alarm[0] = 30;


//Variável de controle para saber se eu já troquei de level e posso começar a segunda transição
comecar_transicao_2 = false;

//Variável de controle para saber se eu devo deixar a tela totalmente escura
escurecer_tudo = false;