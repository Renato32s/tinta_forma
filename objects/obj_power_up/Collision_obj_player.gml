/// @description ao se colidir com o player

//instance_destroy(); //se destruindo
if (!target)
{
	other.pega_power_up(); //entra no estado correto
	target = other.id; //definindo o alvo
	movement(); //se movendo para cima do player
	explosion(); //criando a particula
	global.power_unlocked = true; //pode usar o poder da tinta
}