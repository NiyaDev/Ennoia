
module ennoia::texture;
import ennoia::color;
import ennoia::rectangle;
import ennoia::vector;
import ennoia::debug;
import std::io;
import spng;
import gl;
import libc;


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

char[] def = $embed("../../../resources/def_tex.png");

faultdef SPNG_ERROR;


<* Loads image from file
  @param filename: "Name of file to load"
 *>
fn Texture load(String filename) @export("texture_load") {
  Texture output;
  int res;

  // Load data from file
  CFile file = libc::fopen((ZString)filename, "rb");
  defer libc::fclose(file);
  usz imgSize;

  Ctx* ctx = spng::ctx_new(0);
  spng::set_png_file(ctx, file);
  if (res != 0) debug::fatal("set_png_file() error: %s", spng::strerror(res));
  spng::decoded_image_size(ctx, (int)Format.RGBA8, &imgSize);
  if (res != 0) debug::fatal("decoded_image_size() error: %s", spng::strerror(res));
  
  char[] data = mem::new_array(char, imgSize);
  defer free(data);

  Ihdr ihdr;
  spng::get_ihdr(ctx, &ihdr);
  if (res != 0) debug::fatal("get_ihdr() error: %s", spng::strerror(res));
  output.width = ihdr.width;
  output.height = ihdr.height;
  
  spng::decode_image(ctx, (void*)data, imgSize, (int)Format.RGBA8, 0);
  if (res != 0) debug::fatal("decode_image() error: %s", spng::strerror(res));
  data.reverse(output.width, output.height, 4);

  spng::ctx_free(ctx);

  // Gen OpenGL texture
  gl::gen_textures(1, &output.id);
  gl::bind_texture(gl::TEXTURE_2D, output.id);

  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MIN_FILTER, gl::NEAREST);
  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MAG_FILTER, gl::NEAREST);

  gl::tex_image_2d(gl::TEXTURE_2D, 0, gl::RGBA, output.width, output.height, 0, gl::RGBA, gl::UNSIGNED_BYTE, data);
  gl::generate_mipmap(gl::TEXTURE_2D);
  if (output.id == 0) debug::fatal("texture::load() error: Failed to bind Texture.");

  return output;
}

<* Load texture from memory
  @param data: "Array of data to convert into texture"
 *>
fn Texture? load_from_mem(char[] data) @export("texture_loadfrommem") {
  Texture output;
  int res;

  // Create context and get decoded size
  Ctx* ctx = spng::ctx_new(0);
  usz imgSize;
  res = spng::set_png_buffer(ctx, data, data.len);
  debug::@error_b(res == 0, "set_png_buffer() error: %s", spng::strerror(res), SPNG_ERROR)!;
  //if (res != 0) debug::fatal("set_png_buffer() error: %s", spng::strerror(res));
  res = spng::decoded_image_size(ctx, (int)Format.RGBA8, &imgSize);
  debug::@error_b(res == 0, "decoded_image_size() error: %s", spng::strerror(res), SPNG_ERROR)!;
  //if (res != 0) debug::fatal("decoded_image_size() error: %s", spng::strerror(res));

  // Copy width and height
  Ihdr ihdr;
  res = spng::get_ihdr(ctx, &ihdr);
  if (res != 0) debug::fatal("get_ihdr() error: %s", spng::strerror(res));
  output.width = ihdr.width;
  output.height = ihdr.height;
  
  // Decode image data and reverse result
  char[] img = mem::new_array(char, imgSize);
  defer free(img);
  
  res = spng::decode_image(ctx, (void*)img, imgSize, (int)Format.RGBA8, 0);
  if (res != 0) debug::fatal("decode_image() error: %s", spng::strerror(res));
  img.reverse(output.width, output.height, 4);

  spng::ctx_free(ctx);

  // Gen OpenGL texture
  gl::gen_textures(1, &output.id);
  gl::bind_texture(gl::TEXTURE_2D, output.id);

  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MIN_FILTER, gl::NEAREST);
  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MAG_FILTER, gl::NEAREST);

  gl::tex_image_2d(gl::TEXTURE_2D, 0, gl::RGBA, output.width, output.height, 0, gl::RGBA, gl::UNSIGNED_BYTE, img);
  gl::generate_mipmap(gl::TEXTURE_2D);
  if (output.id == 0) debug::fatal("texture::load() error: Failed to bind Texture.");

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
  output.width = width;
  output.height = height;

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

<**>
fn void char[].reverse(self, usz width, usz height, int bytesPerPixel) {
  usz stride = width * bytesPerPixel;
  char[] row = mem::new_array(char, stride);
  for (int y; y < height / 2; y++) {
    char* top = (char*)self + y * stride;
    char* bot = (char*)self + (height - y - 1) * stride;

    mem::copy(row, top, stride);
    mem::copy(top, bot, stride);
    mem::copy(bot, row, stride);
  }
  free(row);
}
