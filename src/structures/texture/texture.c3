
module ennoia::texture;
import ennoia::color;
import ennoia::rectangle;
import ennoia::vector;
import std::io;
import stb;
import gl;


struct Texture {
  uint id;
  uint width, height;
  int mipmaps;
  int format;
  bool transparency;
}
enum TilingLayout {
  THREE_THREE,
  ONE_THREE,
  THREE_ONE,
}


<* Loads image from file
  @param filename: "Name of file to load"
 *>
fn Texture load(String filename) @export("texture_load") {
  Texture output;

  // Load data from file
  stb::stbi_set_flip_vertically_on_load(true);
  uint channels;
  char* data = stb::stbi_load(filename.zstr_tcopy(), &output.width, &output.height, &channels, 0);
  assert(data != null, "[ERROR] - ENNOIA::TEXTURE::LOAD [Failed to load image]");

  // Check if transparent
  for (int i = 3; i < (output.width * output.height) * 4; i += 4) {
    if (data[i] != 255) {
      output.transparency = true;
      break;
    }
  }

  // Gen OpenGL texture
  gl::gen_textures(1, &output.id);
  gl::bind_texture(gl::TEXTURE_2D, output.id);

  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MIN_FILTER, gl::NEAREST);
  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MAG_FILTER, gl::NEAREST);

  gl::tex_image_2d(gl::TEXTURE_2D, 0, gl::RGBA, output.width, output.height, 0, gl::RGBA, gl::UNSIGNED_BYTE, data);
  gl::generate_mipmap(gl::TEXTURE_2D);
  assert(output.id != 0, "[ERROR] - ENNOIA::TEXTURE::LOAD [Failed to bind texture]");

  // Cleanup
  stb::stbi_image_free(data);

  return output;
}

<* Load texture from memory
  @param data: "Array of data to convert into texture"
 *>
fn Texture load_from_mem(char[] data) @export("texture_loadfrommem") {
  Texture output;

  stb::stbi_set_flip_vertically_on_load(true);

  uint channels;
  char* img = stb::stbi_load_from_memory((char*)data, (uint)data.len, &output.width, &output.height, &channels, 0);
  assert(img != null, "[ERROR] - ENNOIA::TEXTURE::LOAD [Failed to load image]");

  gl::gen_textures(1, &output.id);
  gl::bind_texture(gl::TEXTURE_2D, output.id);

  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MIN_FILTER, gl::NEAREST);
  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MAG_FILTER, gl::NEAREST);

  gl::tex_image_2d(gl::TEXTURE_2D, 0, gl::RGBA, output.width, output.height, 0, gl::RGBA, gl::UNSIGNED_BYTE, img);
  gl::generate_mipmap(gl::TEXTURE_2D);
  assert(output.id != 0, "[ERROR] - ENNOIA::TEXTURE::LOAD [Failed to bind texture]");

  stb::stbi_image_free(img);

  return output;
}
<* Create a new blank texture
  @param width: "The width of the image"
  @require width > 0
  @param height: "The height of the image"
  @require height > 0
 *>
fn Texture new(int width, int height) @export("texture_new") {
  Texture output;

  gl::gen_textures(1, &output.id);
  gl::bind_texture(gl::TEXTURE_2D, output.id);
  gl::tex_image_2d(gl::TEXTURE_2D, 0, gl::RGB, width, height, 0, gl::RGB, gl::UNSIGNED_BYTE, null);
  
  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MIN_FILTER, gl::LINEAR);
  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MAG_FILTER, gl::LINEAR);

  return output;
}
<* Cleans up texture *>
fn void Texture.clean(&self) @export("texture_clean") {
  gl::delete_textures(1, &self.id);
}

