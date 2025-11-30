
module ennoia;
import std::math;
import sdl3;
import gl;


<* Shorthand for doing both drawing until i merge them *>
fn void drawing() @export("drawing") {
  start_drawing();
  end_drawing();
}
<* Starts the process of drawing *>
fn void start_drawing() @export("start_drawing") {
  gl::bind_framebuffer(gl::FRAMEBUFFER, render::framebuffer);
  gl::enable(gl::DEPTH_TEST);
  gl::viewport(0, 0, renWidth, renHeight);

  clear_background(bgColor, gl::COLOR_BUFFER_BIT | gl::DEPTH_BUFFER_BIT);
}
<* Swaps buffers and polls events *>
fn void end_drawing() @export("end_drawing") {
  scrollwheel = 0;

  if (debug::timer > 0) {
    render::draw_font("font",debug::recentText);
    debug::timer--;
  }

  render::render_all();

  // Set up default framebuffer
  gl::bind_framebuffer(gl::FRAMEBUFFER, 0);
  gl::disable(gl::DEPTH_TEST);
  clear_background(color::ORANGE, gl::COLOR_BUFFER_BIT);
  gl::viewport(0, 0, scrWidth, scrHeight);

  // Draw renderquad to screen
  render::renderQuad.shader.use();
  gl::active_texture(gl::TEXTURE0);
  gl::bind_vertex_array(render::renderQuad.vao);
  gl::bind_texture(gl::TEXTURE_2D, render::renderTexture.id);
  gl::draw_arrays(gl::TRIANGLES, 0, render::renderQuad.vertices.len);

  sdl3::gl_swap_window(window);
}

<* Wrapper for clear color
  @param color: "Color to draw background"
 *>
fn void clear_background(Color color, int flags) @export("clearbg") {
  gl::clear_color((float)color.r / 255, (float)color.g / 255, (float)color.b / 255, (float)color.a / 255);
  gl::clear(flags);
}
<* Changes the current screen size to input and updates screen
  @param w: "New Width of screen"
  @require w > 0
  @param h: "New Height of screen"
  @require h > 0
 *>
fn void set_size(uint w, uint h) @export("setsize") {
  scrWidth  = w;
  scrHeight = h;
  renWidth  = (int)((float)w * renRes);
  renHeight = (int)((float)h * renRes);
  
  update_screen();
}
<* Changes the current render scale
  @param scale: "New scale to render at"
  @require scale > 0
 *>
fn void set_render_scale(float scale) @export("setrenderscale") {
  renRes = scale;

  renWidth  = (int)((float)scrWidth * renRes);
  renHeight = (int)((float)scrHeight * renRes);
  
  update_screen();
}
<* Changes whether game is in borderless mode *>
fn void set_borderless(bool borderless = true) @export("setborderless") {
  sdl3::set_bordered(window, !borderless);
}
<* Changes whether game is in fullscren mode *>
fn void set_fullscreen(bool fullscreen = true) @export("setfullscreen") {
  sdl3::set_fullscreen(window, fullscreen);
  int w,h;
  sdl3::get_size(window, &w, &h);

  set_size(w, h);
}
<* Sets the field of view of the current main camera *>
fn void set_field_of_view(float fov) @export("setfov") {
  camera::main.fov = fov;
}
<* Returns the current fps *>
fn int get_fps() @export("getfps") {
  return (int)(1 / deltaTime);
}
<* Returns monitor resolution *>
fn int[2] get_display_resolution() @export("getdisplayresolution") {
  sdl3::Rect rec;
  sdl3::get_display_bounds(sdl3::get_primary_display(), &rec);

  return {rec.w, rec.h};
}

<* Updates the screen to apply any changes made *>
fn void update_screen() {
  sdl3::set_size(window, scrWidth, scrHeight);

  // Update main shader
  Shader shader = render::save_shader();
  shader.set_vec2f("u_output_size", {(float)scrWidth, (float)scrHeight});
  shader.set_vec2f("u_game_size", {(float)renWidth, (float)renHeight});

  // Update default shaders
  defaultShader2d.set_vec2f("screensize", {(float)renWidth,(float)renHeight});
  defaultShader3d.set_mat4x4("projection", matrix::perspective{float}(70 * math::PI / 180, (float)renWidth / (float)renHeight, 0.1, 100.0));

  // Re-create render texture
  render::clean();
  render::init(renWidth, renHeight);

  // Re-set shader
  render::set_shader(shader);
}

