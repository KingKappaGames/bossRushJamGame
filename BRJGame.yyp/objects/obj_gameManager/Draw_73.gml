//var _distortionWidth = sprite_get_width(spr_distort_smoothnoise);
//var _distortionHeight = sprite_get_height(spr_distort_smoothnoise);

//var _gridX = y div blockSize * blockSize;
//var _gridY = x div blockSize * blockSize;

//shader_set(Shader1);

//shader_set_uniform_f(shader_get_uniform(Shader1, "roomPosition"), (x - (x - updateLastX)) / _distortionWidth, (y - (y - updateLastY)) / _distortionWidth);

//shader_set_uniform_f(shader_get_uniform(Shader1, "gm_pSurfaceDimensions"), surface_get_width(perlinSurf), surface_get_height(perlinSurf));


//var texture = sprite_get_texture(spr_distort_smoothnoise, 0);
//var register = shader_get_sampler_index(Shader1, "g_DistortTexture");
//texture_set_stage(register, texture);
//gpu_set_texrepeat_ext(register, true);


//shader_set_uniform_f(shader_get_uniform(Shader1, "g_DistortTextureDimensions"), _distortionWidth, _distortionHeight);

//shader_set_uniform_f(shader_get_uniform(Shader1, "g_DistortScale"), 10.0);
//shader_set_uniform_f(shader_get_uniform(Shader1, "g_DistortAmount"), 60.0);
//shader_set_uniform_f(shader_get_uniform(Shader1, "g_DistortOffset"), 0.0, 0.0);