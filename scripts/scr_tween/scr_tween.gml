enum tween_animation {
	//Esses são os originais e estão baoms
	back,
	flat,
	elastic,
	bounce,
	ease,
	//Outras opção (não sei se ficaram boras, pode ser interessante olhar as curvas)
	linear,
	sine_in,    sine_out,    sine_inout,
	quad_in,    quad_out,    quad_inout,
	cubic_in,   cubic_out,   cubic_inout,
	quart_in,   quart_out,   quart_inout,
	quint_in,   quint_out,   quint_inout,
	expo_in,    expo_out,    expo_inout,
	circ_in,    circ_out,    circ_inout,
	back_in,    back_out,    back_inout,
	elastic_in, elastic_out, elastic_inout,
	bounce_in,  bounce_out,  bounce_inout, elastic_slow
}

function tween(_object, _variable_name, _value, _animation = tween_animation.back, _time = 30, _callback = -1, _force = true, _retorno = false){
	//Mesma ordem do que foi criado em cima
	static _anim_names = [
		"back", "flat", "elastic", "bounce", "ease",
		"linear",
		"sine_in",    "sine_out",    "sine_inout",
		"quad_in",    "quad_out",    "quad_inout",
		"cubic_in",   "cubic_out",   "cubic_inout",
		"quart_in",   "quart_out",   "quart_inout",
		"quint_in",   "quint_out",   "quint_inout",
		"expo_in",    "expo_out",    "expo_inout",
		"circ_in",    "circ_out",    "circ_inout",
		"back_in",    "back_out",    "back_inout",
		"elastic_in", "elastic_out", "elastic_inout",
		"bounce_in",  "bounce_out",  "bounce_inout", "elastic_slow"
	];

	// Aceita tanto um valor do enum quanto o nome do canal direto (string).
	var _anim = is_string(_animation) ? _animation : _anim_names[_animation];
	var _origem = undefined;

	// Já existe um tween rodando nessa mesma variável desse mesmo objeto?
	with (obj_tween) {
		if (object == _object && variable_name == _variable_name) {
			// Mesmo efeito já rodando
			if (destino == _value && animation == _anim) {
				var _continua = chamado_anterior;
				chamado = true;
				// Chamada nova (não veio do frame anterior): toca a curva do início
				if (!_continua) {
					base     = origem;
					value    = destino;
					percent  = 0;
					voltando = false;
					time     = _time;
					callback = _callback;
					retorno  = _retorno;
				}
				return id;
			}
			// Efeito diferente sem force: o que está rodando tem prioridade
			if (!_force) return noone;
			// Efeito diferente com force: impõe o novo
			// Herda a origem para não voltar para um valor "do meio" da animação
			if (retorno) _origem = origem;
			instance_destroy();
		}
	}
	// Nenhum tween ativo e a variável já está no destino só morre
	if (_object[$ _variable_name] == _value) return noone;

	var _tween = instance_create_depth(x, y, depth, obj_tween, {
			object: _object,
			variable_name: _variable_name,
			value: _value,
			destino: _value,
			animation: _anim,
			time: _time,
			anim_curve: animcurve_get_channel(tween_curves, _anim),
			callback: _callback,
			retorno: _retorno,
			origem: _origem
		});

	return _tween;
}