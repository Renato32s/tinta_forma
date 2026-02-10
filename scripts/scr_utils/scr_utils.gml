#region variáveis

global.debug = false; //variável de debug

#endregion

#region macros

#macro DEBUG_MODE false //macro de debug
#macro modo_debug:DEBUG_MODE true //modo de debug
#macro modo_normal:DEBUG_MODE false //modo normal sem função de debug
#macro FPS game_get_speed(gamespeed_fps) //pegando o fps do game


#endregion

#region funções

function cria_particulas(_position_x, _position_y, _depth, _particula)
{
	//if (!instance_exists(_particula)) return; //se a instancia não exite, não faz nada
	
	instance_create_depth(_position_x, _position_y, _depth, _particula); //criando a particula
}

#endregion