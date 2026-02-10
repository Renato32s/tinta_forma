/// @description iniciando o objeto

//variável de força do screenshake
treme = 0;

//metodo para tremer a tela
screen_treme = function()
{
	if (treme > 0.1) //se o valor do treme for maior que zero
	{
		var _x = random_range(-treme, treme); //variável que balança o eixo_x horizontal
		var _y = random_range(-treme, treme); //variável que balança o eixo_y vertical
		
		view_set_xport(view_current, _x); //balançando o eixo_x horizontal
		view_set_yport(view_current, _y); //balançando o eixo_y vertical
	}
	else //se não
	{
		treme = 0; //zerando a variável de balanço
		
		//resetando os valores de view_set(eixo_x & eixo_y)
		view_set_xport(view_current, 0);
		view_set_yport(view_current, 0);
	}
	
	treme = lerp(treme, 0, .1); //voltando ao valor base
}