/*
object
variable_name
animation
time
callback
anim_curve
*/

position = 0;
percent = 0;
base = object[$ variable_name];

voltando = false;
// Se não herdou origem de um tween anterior, a origem é o valor atual
origem ??= base;

// Controle de chamadas: contínua (todo frame) não reinicia, nova chamada reinicia
chamado          = true;
chamado_anterior = false;