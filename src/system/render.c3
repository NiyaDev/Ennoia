
module ennoia::render;
import ennoia::shader;
import ennoia::texture;
import ennoia::mesh;
import ennoia::debug;
import gl;
import std::io;
import spng;


uint framebuffer, renderbuffer;
Texture renderTexture;
Mesh renderQuad;

<* Initializes the Framebuffer and Renderbuffer *>
fn void init(int width, int height) {
  // Render quad
  renderQuad = mesh::gen_quad();
  renderQuad.shader = shader::compile(shader::FB_VERTEX, shader::FB_FRAGMENT);
  renderQuad.shader.set_int("screenTexture", 0);

  // Framebuffer
  gl::gen_framebuffers(1, &framebuffer);
  gl::bind_framebuffer(gl::FRAMEBUFFER, framebuffer);

  // Render Texture
  renderTexture = texture::new(width, height);
  gl::framebuffer_texture_2d(gl::FRAMEBUFFER, gl::COLOR_ATTACHMENT0, gl::TEXTURE_2D, renderTexture.id, 0);

  // Renderbuffer
  gl::gen_renderbuffers(1, &renderbuffer);
  gl::bind_renderbuffer(gl::RENDERBUFFER, renderbuffer);
  gl::renderbuffer_storage(gl::RENDERBUFFER, gl::DEPTH24_STENCIL8, width, height);
  gl::framebuffer_renderbuffer(gl::FRAMEBUFFER, gl::DEPTH_STENCIL_ATTACHMENT, gl::RENDERBUFFER, renderbuffer);
  assert(gl::check_framebuffer_status(gl::FRAMEBUFFER) == gl::FRAMEBUFFER_COMPLETE, "[ERROR] - ENNOIA::RENDERTEXTURE::INIT::CHECK_FRAMEBUFFER_STATUS [Framebuffer failed to initialize]");
  gl::bind_framebuffer(gl::FRAMEBUFFER, 0);
}
<* Clean up the framebuffer *>
fn void clean() {
  renderQuad.clean();
  renderTexture.clean();
  gl::delete_framebuffers(1, &framebuffer);
  gl::delete_renderbuffers(1, &renderbuffer);
}

<* Replaces old rendershader, cleaning up the old one *>
fn void set_shader(Shader newShader) @export("setshader") {
  renderQuad.shader.clean();
  renderQuad.shader = newShader;
}
<* Returns current rendershader *>
fn Shader save_shader() @export("getshader") {
  Shader sh = renderQuad.shader;
  renderQuad.shader = {};
  return sh;
}

<* Gets raw screenshot *>
// TODO: Error check
fn char[] screenshot() @export("screenshot") {
  char[] data = mem::new_array(char, 4 * (usz)renderTexture.width * (usz)renderTexture.height);
  gl::read_pixels(0,0,renderTexture.width,renderTexture.height, gl::RGBA, gl::UNSIGNED_BYTE, data);

  return data;
}
<* Saves screenshot as png *>
fn void save_screenshot(String filename = "screenshot.png") @export("screenshot_save") {
  int res;

  Ctx* enc = spng::ctx_new((int)CTXFlags.ENCODER);
  defer spng::ctx_free(enc);

  res = spng::set_option(enc, Option.ENCODE_TO_BUFFER, 1);
  debug::error(res == 0, "set_options() error: %s", spng::strerror(res));

  Ihdr ihdr = {
    ennoia::renWidth,
    ennoia::renHeight,
    8,
    (char)ColorType.TRUECOLOR_ALPHA,
    0, 0, 0,
  };
  res = spng::set_ihdr(enc, &ihdr);
  debug::error(res == 0, "set_ihdr() error: %s", spng::strerror(res));

  char[] data = screenshot();
  data.reverse(ennoia::renWidth, ennoia::renHeight, 4);
  defer free(data);

  res = spng::encode_image(enc, data, data.len, (int)Format.PNG, (int)EncodeFlags.FINALIZE);
  debug::error(res == 0, "encode_image() error: %s", spng::strerror(res));

  usz pngSize;
  void* png = spng::get_png_buffer(enc, &pngSize, &res);
  //defer free(png);
  debug::error(res == 0, "get_png_buffer() error: %s", spng::strerror(res));

  file::save(filename, ((char*)png)[:pngSize])!!;

}

