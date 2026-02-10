//função para balançar a tela(screenshake)
function screen_sacode(_sacode = 0)
{
	if (instance_exists(obj_screenshake)) //se o screenshake existe
	{
		with(obj_screenshake) //rodando a função dentro do objeto
		{
			if (_sacode > treme) //se o sacode for maior que o valor de treme
			{
				treme = _sacode; //treme recebe o valor de sacode
			}
		}
	}
}