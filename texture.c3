
module ennoia::texture;
import std::io;
import stb;
import ennoia;



struct Image {
  Color[] data;
  int width, height;
  int mipmaps;
  int format;
}

struct Texture {
  uint id;
  uint width, height;
  int mipmaps;
  int format;
}


<**>
fn Texture load(String filename) {
  Texture output;

  stb::stbi_set_flip_vertically_on_load(true);

  uint channels;
  char* data = stb::stbi_load(filename.zstr_tcopy(), &output.width, &output.height, &channels, 0);
  assert(data != null, "[ERROR] - ENNOIA::TEXTURE::LOAD [Failed to load image]");

  gl::gen_textures(1, &output.id);
  gl::bind_texture(gl::TEXTURE_2D, output.id);

  gl::texture_parameter_f(gl::TEXTURE_2D, gl::TEXTURE_MAX_ANISOTROPY_EXT, 4);
  gl::texture_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MIN_FILTER, gl::NEAREST);
  gl::texture_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MAG_FILTER, gl::NEAREST);

  gl::tex_image_2d(gl::TEXTURE_2D, 0, gl::RGBA, output.width, output.height, 0, gl::RGB, gl::UNSIGNED_BYTE, data);
  gl::generate_mipmap(gl::TEXTURE_2D);
  assert(output.id != 0, "[ERROR] - ENNOIA::TEXTURE::LOAD [Failed to bind texture]");

  stb::stbi_image_free(data);

  return output;
}
