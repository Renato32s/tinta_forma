/// @description iniciando o objeto
//iniciando funções
inicia_efeito_squash();

#region variáveis
//variáveis de movimento
vel_h		= 0;
vel_v		= 0;
max_vel_h	= 1;
max_vel_v	= 3;
grav		= 0.2;

//variável do chão
chao	= false;

//variável de controle da direção que o player está olhando
direction_flip = 1;

//variáveis de inputs
right		= false;
left		= false;
jump		= false;
power_tinta = false;

//variável do estado
estado = noone;

#endregion

#region métodos

//metodo de inputs
inputs = function()
{
	left		= keyboard_check(ord("A")); //pegando o input da esquerda
	right		= keyboard_check(ord("D")); //pegando o input da direita
	jump		= keyboard_check_pressed(vk_space); //pegando o input do pulo
	power_tinta	= keyboard_check_pressed(vk_shift); //pegando o input do poder da tinta
}

//metodo para aplicar a gravidade
aplica_velocidade = function()
{
	checa_chao(); //checando se está no chão
	
	vel_h = (right - left) * max_vel_h; //vel_h recebe o tesultado de direita(positivo) - esquerda(negativo) e multiplical po max_vel_h = 2;
	
	if (!chao) //se não está no chão
	{
		vel_v += grav; //aplica a gravidade
	}
	else //se está no chão
	{
		vel_v = 0; //zerando a vel_v
		y = round(y); //arredondando o valor do eixo_y( vertical )
		
		if (jump) //se pressionar tecla de pulo
		{
			vel_v = -max_vel_v; //vel_v recebe o valor negativo de max_vel_v, faz o player pular
		}
	}
	
}

//metodo de movimentação
movimento = function()
{	
	move_and_collide(vel_h, vel_v, obj_parede, 4); //usando move and collide horizontal
	move_and_collide(0, vel_v, obj_parede, 12); //usando move and collide vertical
	
	//enabler_debug(); //chamando o metodo de ativar ou desativar o debug
	//checa_chao(); //chamando o metodo que checa se está no chão
	//inputs(); //chamando o metodo de inputs	
	//estado(); //máquina de estado
}

//metodo para checar se está no chão
checa_chao = function()
{
	chao = place_meeting(x, y + 1, obj_parede); //checando se está no chão
}

//metodo para trocar de sprite
swap_sprite = function(_sprite = spr_parede)
{
	if (sprite_index != _sprite) //se a sprite for diferente da sprite atual
	{
		sprite_index	= _sprite; //define a sprite atual
		image_index		= 0; //zerando o index da sprite, faz ela começãr do zero
	}
}

//metodo para checar se a animação da sprite acabou
animacao_acabou = function() 
{
	//variável de velocidade da sprite
	var _spd = sprite_get_speed(sprite_index) / FPS;
	if (image_index + _spd >= image_number)
	{
		return true;
	}
}

//metodo para ajustar a escala
ajusta_escala = function()
{
	if (vel_h != 0) direction_flip = sign(vel_h); //se o vel_h for diferente de zero, a escala é definida com base no vel_h
}

#endregion fim da região

#region máquina de estados

estado_parado = function() //está parado
{
	vel_h = 0;
	vel_v = 0;
	aplica_velocidade();
	
	
	swap_sprite(spr_player_idle); //definindo a sprite
	
	if (power_tinta) estado = estado_tinta_entrar; //entrando no modo tinta
	
	if (right != left) estado = estado_movendo; //se movendo, para esquerda ou direita
	if (jump) 
	{
		estado = estado_pulo; //pulando
		cria_particulas(x, y, depth -1, obj_pulo_particula); //criando a particula do pulo
		efeito_squash(.4, 1.6); //esticando e achatando
	}
	if (!chao) estado = estado_pulo; //se não está no chão, está caindo
}

estado_movendo = function() //se movendo
{
	aplica_velocidade();
	swap_sprite(spr_player_movendo); //definindo a sprite
	
	if (vel_h == 0) 
	{
		estado = estado_parado; //se vel_h for zero, volta para o estado de parado
	}
	
	if (jump)
	{
		estado = estado_pulo;
		cria_particulas(x, y, depth -1, obj_pulo_particula); //criando a particula do pulo
		efeito_squash(.4, 1.6); //esticando e achatando
	}
}

estado_pulo = function() //pulando
{
	aplica_velocidade();
	if (vel_v < 0) swap_sprite(spr_player_pulo_cima); //definindo a sprite
	else if (vel_v > 0) swap_sprite(spr_player_pulo_baixo); //caindo
	
	if (chao) 
	{
		cria_particulas(x, y, depth -1, obj_pouso_particula); //criando particula do posuso
		estado = estado_parado; //se está no chão, o estado base é o parado
		efeito_squash(1.5, .5); //esticando e achatando
	}
}

estado_tinta_entrar = function()
{
	swap_sprite(spr_player_tinta_entrar);
	
	if (animacao_acabou())
	{
		estado = estado_tinta_loop;
	}
}

estado_tinta_loop = function()
{
	swap_sprite(spr_player_tinta_loop);
	
	if (power_tinta)
	{
		estado = estado_tinta_sair;
	}
}

estado_tinta_sair = function()
{
	swap_sprite(spr_player_tinta_sair);
	if (animacao_acabou())
	{
		estado = estado_parado;
	}
}

estado_power_up_inicio = function() //power_up inicio
{
	swap_sprite(spr_player_power_up_inicio); //definindo a sprite
	
	if (animacao_acabou()) //se acabou a animação
	{
		estado = estado_power_up_meio; //muda estado
	}
}

estado_power_up_meio = function() //power_up meio
{
	swap_sprite(spr_player_power_up_meio); //definindo a sprite
	
	if (animacao_acabou())
	{
		estado = estado_power_up_final;
	}
}

estado_power_up_final = function() //power_up final
{
	swap_sprite(spr_player_power_up_final); //definindo a sprite
	
	if (animacao_acabou())
	{
		estado = estado_parado;
	}
}


#endregion fim da região, máquina de estados

#region debug

//variável de view do debug
view_player = noone;

//metodo de debug
debug_on_screen = function()
{	
	show_debug_overlay(global.debug); //mostrando o debug overlay
	
	view_player = dbg_view("view_player", 1, 60, 85, 300, 200); //criando o debug overlay
	dbg_watch(ref_create(self, "vel_v"), "força_do_pulo"); //verificando a variável vel_v
	dbg_watch(ref_create(self, "chao"), "no_chão"); //verificando a variável chao
	dbg_slider(ref_create(self, "max_vel_v"), 0, 8, "forçs_máx_pulo", .1); //slider da velocidade máxima
	dbg_slider(ref_create(self, "grav"), 0, 1, "força_gravidade", .01); //slider da gravidade

}

//metodo para ativar ou desativar p debug
enabler_debug = function()
{
	if (!DEBUG_MODE) return; //se não está no modo debug, não faz nada
	
	var _debug = keyboard_check_pressed(vk_tab); //se pressionar o tab
	if (_debug) 
	{
		global.debug = !global.debug; //se pressionar a tecla para ativar o debug
		
		if (global.debug) //se global.debug for true
		{
			debug_on_screen(); //mostrando o debug
		}
		else
		{
			if (dbg_view_exists(view_player)) //se view existe e global.debug for false
			{
				show_debug_overlay(0);
				dbg_view_delete(view_player); //deletando a view_player
			}
		}
	}
}



#endregion

//final do script
estado = estado_parado; //passando para a variável de estado, os estados do player