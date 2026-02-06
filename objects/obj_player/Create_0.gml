/// @description iniciando o objeto

#region variáveis
//variáveis de movimento
vel_h		= 0;
vel_v		= 0;
max_vel_h	= 1;
max_vel_v	= 4;
grav		= 0.2;

//variável do chão
chao	= false;

//variáveis de inputs
right	= false;
left	= false;
jump	= false;

#endregion

#region métodos

//metodo de inputs
inputs = function()
{
	left	= keyboard_check(ord("A")); //pegando o input da esquerda
	right	= keyboard_check(ord("D")); //pegando o input da direita
	jump	= keyboard_check_pressed(vk_space); //pegando o input do pulo
}

//metodo de movimentação
control_player = function()
{	
	inputs(); //chamando o metodo de inputs
	
	checa_chao();
	
	if (!chao) //se não está no chão
	{
		vel_v += grav; //aplica a gravidade
	}
	else //se está no chão
	{
		vel_v = 0; //zerando a vel_v
		if (jump) //se pressionar tecla de pulo
		{
			vel_v = -max_vel_v; //vel_v recebe o valor negativo de max_vel_v, faz o player pular
		}
	}
	
	show_debug_message(vel_v);
	
	vel_h = (right - left) * max_vel_h; //vel_h recebe o tesultado de direita(positivo) - esquerda(negativo) e multiplical po max_vel_h = 2;
	move_and_collide(vel_h, 0, obj_parede, 4); //usando move and collide horizontal
	move_and_collide(0, vel_v, obj_parede, 12); //usando move and collide vertical
}

//metodo para checar se estou no chão
checa_chao = function()
{
	chao = place_meeting(x, y + 1, obj_parede); //checando se estou no chão
	show_debug_message(chao);
}

#endregion