function inicia_efeito_squash()
{
	//iniciando as variáveis que eu vou usar
	xscale = 1;
	yscale = 1;
}

function efeito_squash(_xscale, _yscale)
{
	xscale = _xscale;
	yscale = _yscale;
}

function retorna_efeito_squash(_amount = .1)
{
	xscale = lerp(xscale, 1, _amount);
	yscale = lerp(yscale, 1, _amount);
}

function desenha_efeito_squash()
{
	draw_sprite_ext(sprite_index, image_index, x, y, xscale * direction_flip, yscale, image_angle, image_blend, image_alpha);
}