/// @description iniciando o obejeto

//definindo uma variável para ao alvo
target = noone;

//metodo para criar as particulas
explosion = function()
{
	repeat(20) //cria 20 particulas
	{
		var _speed = choose(2, 4);
		var _direction = random_range(0, 359);
		var _particula =  instance_create_depth(x, y, +1, obj_part_power_up); //criando minha particula
		_particula.speed = _speed; //define a velocidade das particulas
		_particula.direction = _direction; //define a direção das particulas
		_particula.target = target; //define o alvo das particulas
	}
}

//metodo para ficar acima do player
movement = function()
{
	if (!target) return; //se não tem alvo, não faz nada
	x = target.x;
	y = target.y - 35;
}

//metodo para sumir e se destruir
alpha_noone = function()
{
	if (target)
	{
		image_alpha = lerp(image_alpha, 0, 0.1); //fica transparente
		if (image_alpha <= 0) //se o alpha for zero ou menor
		{
			instance_destroy(); //se destruindo
		}
	}
}