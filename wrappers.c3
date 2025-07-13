
module ennoia;
import std::io;
import std::collections;



<* Wrapper for clear color
  @param color: "Color to draw background"
 *>
fn void clear_background(Color color) {
  gl::clear_color((float)color.r / 255, (float)color.g / 255, (float)color.b / 255, (float)color.a / 255);
  gl::clear(gl::COLOR_BUFFER_BIT | gl::DEPTH_BUFFER_BIT);
}

<**>
fn void start_drawing() {
  gl::bind_framebuffer(gl::FRAMEBUFFER, framebuffer);
  gl::enable(gl::DEPTH_TEST);
  gl::viewport(0, 0, renWidth, renHeight);

  clear_background(bgColor);
}
<* Swaps buffers and polls events *>
fn void end_drawing() {
  scrollwheel = 0;

  gl::bind_framebuffer(gl::FRAMEBUFFER, 0);
  gl::disable(gl::DEPTH_TEST);
  gl::clear_color((float)color::ORANGE.r / 255, (float)color::ORANGE.g / 255, (float)color::ORANGE.b / 255, (float)color::ORANGE.a / 255);
  gl::clear(gl::COLOR_BUFFER_BIT);
  gl::viewport(0, 0, scrWidth, scrHeight);


  renderQuad.shader.use();
  gl::active_texture(gl::TEXTURE0);
  gl::bind_vertex_array(renderQuad.vao);
  gl::bind_texture(gl::TEXTURE_2D, render.id);
  gl::draw_arrays(gl::TRIANGLES, 0, renderQuad.vertices.len);

  sdl::gl_swap_window(window);
}

<* Sets vertex attribute data
  @param location
  @param size: "The number of floats in data"
  @param offset: "Offset to each entry of the data"
 *>
fn void set_vertex_attribute(uint location, uint size, void* offset) {
  gl::vertex_attrib_pointer(location, size, gl::FLOAT, false, Vertex.sizeof, offset);
  gl::enable_vertex_attrib_array(location);
}

<**>
fn void set_rendershader(Shader newShader) {
  renderQuad.shader.clean();
  renderQuad.shader = newShader;
}

