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
chao		= false;
chao_tinta	= false;
tile_map_tinta = layer_tilemap_get_id("tl_tinta");

//variável de colisão
var _tilemap = layer_tilemap_get_id("tl_chao"); //pegando o ID da layer do tilemap
colisao = [obj_parede, _tilemap];

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
	reset		= keyboard_check_pressed(ord("R")); //pegando o input para resetar o game
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
	
	vel_v = clamp(vel_v, -max_vel_v, max_vel_v); //limitando a velocidade vertical(eixo_y)
	
	if (reset) game_restart(); //resetando o game
}

//metodo de movimentação
movimento = function()
{	
	move_and_collide(vel_h, vel_v, colisao, 4); //usando move and collide horizontal
	move_and_collide(0, vel_v, colisao, 12); //usando move and collide vertical
	
	//enabler_debug(); //chamando o metodo de ativar ou desativar o debug
	//checa_chao(); //chamando o metodo que checa se está no chão
	//inputs(); //chamando o metodo de inputs	
	//estado(); //máquina de estado
}

//metodo para checar se está no chão
checa_chao = function()
{
	chao = place_meeting(x, y + 1, colisao); //checando se está no chão
	chao_tinta = place_meeting(x, y + 1, tile_map_tinta); //checando se está no chao de tinta
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

//metodo para pegar o power up
pega_power_up = function()
{
	estado = estado_power_up_inicio; //definindo o estado para pegar o power up
}

#endregion fim da região

#region máquina de estados

estado_parado = function() //está parado
{
	vel_h = 0;
	vel_v = 0;
	aplica_velocidade();
	
	
	swap_sprite(spr_player_idle); //definindo a sprite
	
	if (power_tinta and (global.power_unlocked and chao_tinta))
	{
		cria_particulas(x, y, depth -1, obj_tinta_entrar_particula); //criando particula
		estado = estado_tinta_entrar; //entrando no modo tinta
	}
	
	if (right != left) estado = estado_movendo; //se movendo, para esquerda ou direita
	if (jump) 
	{
		estado = estado_pulo; //pulando
		cria_particulas(x, y, depth -1, obj_pulo_particula); //criando a particula do pulo
		var _x = random_range(-.3, -.6);
		var _y = random_range(.3, .6);
		efeito_squash(1 + _x, 1 + _y);
		//efeito_squash(.4, 1.6); //esticando e achatando
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
		var _x = random_range(-.3, -.6);
		var _y = random_range(.3, .6);
		efeito_squash(1 + _x, 1 + _y);
		//efeito_squash(.4, 1.6); //esticando e achatando
	}
	
	if (!chao)
	{
		estado = estado_pulo;
	}
	
	if (power_tinta and (global.power_unlocked and chao_tinta))
	{
		cria_particulas(x, y, depth -1, obj_tinta_entrar_particula); //criando particula
		estado = estado_tinta_entrar;
	}
}

estado_pulo = function() //pulando
{
	aplica_velocidade();
	if (vel_v < 0) 
	{
		swap_sprite(spr_player_pulo_cima); //definindo a sprite
		if (array_contains(colisao, obj_parede_onde_way)) //se a instancia existe no array
		{
			var _index = array_get_index(colisao, obj_parede_onde_way); //pegando a posição do objeto dentro do array
			array_delete(colisao, _index, 01); //deletando a instancia do array
		}
	}
	else
	{
		swap_sprite(spr_player_pulo_baixo); //caindo
		if (!place_meeting(x, y, obj_parede_onde_way)) //se não está tocando na colisão
		{
			if (!array_contains(colisao, obj_parede_onde_way)) //se a instancia não existe
			{
				array_push(colisao, obj_parede_onde_way); //adiciona parede one way na lista
			}
			//colisao[2] = obj_parede_onde_way; //parede one way entra na lista
		}
	}
	
	if (chao) 
	{
		cria_particulas(x, y, depth -1, obj_pouso_particula); //criando particula do posuso
		estado = estado_parado; //se está no chão, o estado base é o parado
		var _x = random_range(.1, .4);
		var _y = random_range(-.2, -.4);
		efeito_squash(1 + _x, 1 + _y);
		//efeito_squash(1.2, .8); //esticando e achatando
	}
}

estado_tinta_entrar = function()
{
	vel_h = 0;
	swap_sprite(spr_player_tinta_entrar);
	
	if (animacao_acabou())
	{
		estado = estado_tinta_loop;
	}
}

estado_tinta_loop = function()
{
	swap_sprite(spr_player_tinta_loop);
	aplica_velocidade();
	
	var _stop = !place_meeting(x + (vel_h * 18), y + 1, tile_map_tinta); //impede o player de cair das plataformas quando o modo tinta está ativo
	if (_stop)
	{
		vel_h = 0;
	}
	
	if (power_tinta)
	{
		cria_particulas(x, y, depth -1, obj_tinta_sair_particula); //criando particula
		estado = estado_tinta_sair;
	}
}

estado_tinta_sair = function()
{
	vel_h = 0;
	swap_sprite(spr_player_tinta_sair);
	if (animacao_acabou())
	{
		estado = estado_parado;
	}
}

estado_power_up_inicio = function() //power_up inicio
{
	vel_h = 0; //parando de se mover 
	swap_sprite(spr_player_power_up_inicio); //definindo a sprite
	
	if (animacao_acabou()) //se acabou a animação
	{
		estado = estado_power_up_meio; //muda estado
	}
}

estado_power_up_meio = function() //power_up meio
{
	swap_sprite(spr_player_power_up_meio); //definindo a sprite
	var _instance = !instance_exists(obj_part_power_up);
	if (_instance and animacao_acabou()) //se não existe particula e a animação acabou
	{
		estado = estado_power_up_final; //muda o estado
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