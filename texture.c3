
module ennoia::texture;
import std::io;
import stb;
import ennoia;



struct Texture {
  uint id;
  uint width, height;
  int mipmaps;
  int format;
}


<* Loads image from file *>
fn Texture load(String filename) {
  Texture output;

  stb::stbi_set_flip_vertically_on_load(true);

  uint channels;
  char* data = stb::stbi_load(filename.zstr_tcopy(), &output.width, &output.height, &channels, 0);
  assert(data != null, "[ERROR] - ENNOIA::TEXTURE::LOAD [Failed to load image]");

  gl::gen_textures(1, &output.id);
  gl::bind_texture(gl::TEXTURE_2D, output.id);

  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MIN_FILTER, gl::NEAREST);
  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MAG_FILTER, gl::NEAREST);

  gl::tex_image_2d(gl::TEXTURE_2D, 0, gl::RGBA, output.width, output.height, 0, gl::RGBA, gl::UNSIGNED_BYTE, data);
  gl::generate_mipmap(gl::TEXTURE_2D);
  assert(output.id != 0, "[ERROR] - ENNOIA::TEXTURE::LOAD [Failed to bind texture]");

  stb::stbi_image_free(data);

  return output;
}
<* Load texture from memory *>
fn Texture load_from_mem(char[] data) {
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
fn Texture new(int width, int height) {
  Texture output;

  gl::gen_textures(1, &output.id);
  gl::bind_texture(gl::TEXTURE_2D, output.id);
  gl::tex_image_2d(gl::TEXTURE_2D, 0, gl::RGB, width, height, 0, gl::RGB, gl::UNSIGNED_BYTE, null);
  
  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MIN_FILTER, gl::LINEAR);
  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MAG_FILTER, gl::LINEAR);

  return output;
}
<* Cleans up texture *>
fn void Texture.clean(&self) {
  gl::delete_textures(1, &self.id);
}

<* Draw texture to screen *>
fn void Texture.draw(&self, Rectangle dest = {0,0,-1,-1}, Rectangle src = {0,0,-1,-1}) {
  // Calculating size on screen
  Vector2 newSize = {dest.w, dest.h};
  if (dest.w < -1) newSize.x = (float)self.width;
  if (dest.h < -1) newSize.y = (float)self.height;
  Vector2 scale = {
    newSize.x / (float)ennoia::renWidth,
    newSize.y / (float)ennoia::renHeight,
  };

  // Change texcoords
  Rectangle newSrc = src;
  if (src.w < 0) newSrc.w = (float)self.width;
  if (src.h < 0) newSrc.h = (float)self.height;
  Vector2 topLeft  = {newSrc.x  / (float)self.width,                                   1 - (newSrc.y  / (float)self.height)};
  Vector2 topRight = {(newSrc.x / (float)self.width) + (newSrc.w / (float)self.width), 1 - (newSrc.y  / (float)self.height)};
  Vector2 botLeft  = {newSrc.x  / (float)self.width,                                   1 - ((newSrc.y / (float)self.height) + (newSrc.h / (float)self.height))};
  Vector2 botRight = {(newSrc.x / (float)self.width) + (newSrc.w / (float)self.width), 1 - ((newSrc.y / (float)self.height) + (newSrc.h / (float)self.height))}; 
  ennoia::textureMesh.update_texcoords({topLeft, botLeft, botRight, topLeft, botRight, topRight});

  // Calculating position on screen
  Vector2 pos = {
    dest.x + newSize.x - (float)ennoia::renWidth,
    dest.y + newSize.y - (float)ennoia::renHeight,
  };

  // Draw
  ennoia::textureMesh.draw_2d(position:pos,scale:scale,texture:self);

  // Reset TexCoords
  ennoia::textureMesh.update_texcoords({{0,1}, {0,0}, {1,0}, {0,1}, {1,0}, {1,1}});
}

