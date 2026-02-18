/// description iniciando o objeto
image_yscale	= .5;
image_xscale	= .3;
image_alpha		= .3;

target = noone; //variável do alvo iniciada com valor nulo
come_back = false; //variável para saber se a velocidade já é zero

//metodo para ir na direção do player
movendo = function()
{
	if (!target) return; //se o alvo não existe, não faz nada
	if (!come_back)	
	{
		speed -= .01; //zerando a velocidade
		if (speed <= 0)	come_back = true; //se a velocidade for menor ou igual a zero, voltar ficar verdadeiro
	}
	else
	{
		var _player = instance_place(x, y, obj_player); //se colidir com o player
		speed += .05; //ganhando velocidade
		direction = point_direction(x, y, target.x, target.y - 10); //definindo a direção das particulas
		if (_player)
		{
			with (_player)
			{
				var _x = random_range(-.09, .1);
				var _y = random_range(.06, -.07);
				efeito_squash(1 + _x, 1 + _y);
			}
			
			instance_destroy(); //as particulas se destroem
		}
	}
	
	image_xscale	= lerp(image_xscale, speed * 4, .1); //esticando a sprite
	image_angle		= direction; //definindo a direção
}