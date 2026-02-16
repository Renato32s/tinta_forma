/// @description desenha no objeto

var _escala = random_range(0, 0.02); //definindo uma variável de escala para o brilho
gpu_set_blendmode(bm_add); //iniciando o efeito de brilho
draw_sprite_ext(spr_brilho_tocha, 0, x, y, 0.3 + _escala, 0.3 + _escala, image_angle, c_white, 0.2); //desenhando o brilho da tocha
gpu_set_blendmode(bm_normal); //resetando o efeito de brilho