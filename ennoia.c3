
module ennoia;
import std::io;
import std::collections;
import std::math;
import sdl3;


SDL_Window* window;
SDL_Surface* surface;
SDL_GLContext* glcontext;
SDL_Event event;

Color bgColor = color::PURPLE;
Mesh textureMesh;
Texture defaultTexture;
Font defaultFont;

double deltaTime;
double lastFrame;
bool forceClose = false;

int scrWidth, scrHeight;
int renWidth, renHeight;
float renRes;
bool borderless, fullscreen;

Vector2 mousePosition;
bool[5] mouseButtons;
bool[5] mouseButtonsHeld;
bool[5] mouseButtonsUp;
float scrollwheel;

Shader defaultShader3d;
Shader defaultShader2d;


<* Initializes Ennoia
  @param width:  "Initial width of screen"
  @param height: "Initial height of screen"
  @param title:  "Title of window"
  @require title != ""
  @param scale: "The value to multiple the screen resolution by to get render resolution"
 *>
fn void init(int width = -1, int height = -1, String title = "ENNOIA", float scale = 0) {
  // Options
  bulk::load_all_options("resources/options");

  // If grab resolution from options if they exist, but override with input
  if (options::contains("screen_width"))  scrWidth  = options::get_int("screen_width");
  if (options::contains("screen_height")) scrHeight = options::get_int("screen_height");
  ((width  > 0) ? scrWidth  = width  : 0);
  ((height > 0) ? scrHeight = height : 0);
  ((scrWidth  <= 0) ? scrWidth  = 1280 : 0);
  ((scrHeight <= 0) ? scrHeight =  720 : 0);

  // Calculate render resolution
  if (options::contains("render_scale")) renRes = options::get_float("render_scale");
  ((scale  >  0) ? renRes = scale : 0);
  ((renRes <= 0) ? renRes = 1     : 0);
  renWidth  = (int)((float)scrWidth  * renRes);
  renHeight = (int)((float)scrHeight * renRes);
  
  // Initialize SDL3
	assert(sdl3::init(sdl3::INIT_VIDEO | sdl3::INIT_AUDIO), "[ERROR] - ENNOIA::INIT::INIT [Failed to initialize SDL3 (%s)]", sdl3::get_error());
	sdl3::gl_set_attribute(GLAttr.CONTEXT_MAJOR_VERSION, 3);
	sdl3::gl_set_attribute(GLAttr.CONTEXT_MINOR_VERSION, 3);
	sdl3::gl_set_attribute(GLAttr.CONTEXT_PROFILE_MASK, sdl3::CONTEXT_PROFILE_CORE);

  // Create window
  window = sdl3::create_window(title.zstr_tcopy(), scrWidth, scrHeight, sdl3::WINDOW_OPENGL);
  assert(window != null, "[ERROR] - ENNOIA::INIT::CREATE_WINDOW [Failed to create sdl3 window(%s)]", sdl3::get_error());

  // Create OpenGL context
  glcontext = sdl3::gl_create_context(window);
  assert(glcontext != null, "[ERROR] - ENNOIA::INIT::CREATE_CONTEXT [Failed to create SDL_GL context (%s)]", (String)sdl3::get_error()[..1024]);
  assert(sdl3::gl_make_current(window, glcontext), "[ERROR] - ENNOIA::INIT::MAKE_CURRENT [Failed to make gl context current (%s)]", sdl3::get_error()); 

  // Enable depth testing
  gl::enable(gl::DEPTH_TEST);
  gl::enable(gl::BLEND);
  //gl::enable(gl::CULL_FACE);
  gl::blend_func(gl::SRC_ALPHA, gl::ONE_MINUS_SRC_ALPHA);

  // Create default shaders
  defaultShader2d = shader::compile(shader::DEFAULT_VERTEX_2D, shader::DEFAULT_FRAGMENT_2D);
  defaultShader2d.set_vec2("screensize", {(float)renWidth,(float)renHeight});
  defaultShader3d = shader::compile(shader::DEFAULT_VERTEX_3D, shader::DEFAULT_FRAGMENT_3D);
  defaultShader3d.set_mat4x4("projection", matrix::perspective(70 * math::PI / 180, (double)renWidth / (double)renHeight, 0.1, 100.0));

  // Framebuffer
  render::init(renWidth, renHeight);

  // Load defaults
  textureMesh = mesh::gen_quad();
  defaultFont = bulk::load_font("resources/default","font");
  defaultTexture = bulk::load_texture("resources/default","texture");

  // Keybinds
  bulk::load_all_keybinds("resources/keybinds");
}
<* Checks if the window should close and updating deltatime *>
fn bool window_should_close() {
  double currentFrame = (double)sdl3::get_ticks() / 1000;
  deltaTime = currentFrame - lastFrame;
  lastFrame = currentFrame;

  keybinds::update();
  while (sdl3::poll_event(&event)) {
    switch (event.type) {
      case sdl3::QUIT: return true;

      case sdl3::KEYDOWN:
      case sdl3::KEYUP:
        keybinds::add_queue(event.key);

      case sdl3::MOUSEMOTION:
        mousePosition = {event.motion.x, event.motion.y};
      case sdl3::MOUSEBUTTONDOWN:
        mouseButtons[event.button.button-1] = true;
      case sdl3::MOUSEBUTTONUP:
        mouseButtonsUp[event.button.button-1] = true;
      case sdl3::MOUSEWHEEL:
        scrollwheel = event.wheel.y;
      default: io::printfn("Unhandled event [%d]",event.type);
    }
  }

  // Default exit button
  if (keybinds.has_key("quit")) {
    if (keybinds::pressed("quit")) {
      ennoia::forceClose = true;
    }
  }

  return forceClose;
}

<* Starts the process of drawing *>
fn void start_drawing() {
  gl::bind_framebuffer(gl::FRAMEBUFFER, render::framebuffer);
  gl::enable(gl::DEPTH_TEST);
  gl::viewport(0, 0, renWidth, renHeight);

  clear_background(bgColor, gl::COLOR_BUFFER_BIT | gl::DEPTH_BUFFER_BIT);
}
<* Swaps buffers and polls events *>
fn void end_drawing() {
  scrollwheel = 0;

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
<* Cleans up resources *>
fn void clean() {
  defaultShader2d.clean();
  defaultShader3d.clean();

  textureMesh.clean();

  render::clean();

  sdl3::destroy_window(ennoia::window);
  sdl3::quit();
}

<* Wrapper for clear color
  @param color: "Color to draw background"
 *>
fn void clear_background(Color color, int flags) {
  gl::clear_color((float)color.r / 255, (float)color.g / 255, (float)color.b / 255, (float)color.a / 255);
  gl::clear(flags);
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

<* Changes the current screen size to input and updates screen
  @param w: "New Width of screen"
  @require w > 0
  @param h: "New Height of screen"
  @require h > 0
 *>
fn void set_size(uint w, uint h) {
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
fn void set_render_scale(float scale) {
  renRes = scale;

  renWidth  = (int)((float)scrWidth * renRes);
  renHeight = (int)((float)scrHeight * renRes);
  
  update_screen();
}
<* Changes whether game is in borderless mode *>
fn void set_borderless(bool borderless = true) {
  sdl3::set_bordered(window, !borderless);
}
<* Changes whether game is in fullscren mode *>
fn void set_fullscreen(bool fullcreen = true) {
  sdl3::set_fullscreen(window, fullcreen);
  int w,h;
  sdl3::get_size(window, &w, &h);

  set_size(w, h);
}
<* Sets the field of view of the current main camera *>
fn void set_field_of_view(float fov) {
  camera::main.fov = fov;
}
<**>
fn int get_fps() {
  return (int)(1 / deltaTime);
}

<* Updates the screen to apply any changes made *>
fn void update_screen() {
  sdl3::set_size(window, scrWidth, scrHeight);

  // Update main shader
  Shader shader = render::save_shader();
  shader.set_vec2("u_output_size", {(float)scrWidth, (float)scrHeight});
  shader.set_vec2("u_game_size", {(float)renWidth, (float)renHeight});

  // Update default shaders
  defaultShader2d.set_vec2("screensize", {(float)renWidth,(float)renHeight});
  defaultShader3d.set_mat4x4("projection", matrix::perspective(70 * math::PI / 180, (double)renWidth / (double)renHeight, 0.1, 100.0));

  // Re-create render texture
  render::clean();
  render::init(renWidth, renHeight);

  // Re-set shader
  render::set_shader(shader);
}

<**>
fn int[2] get_display_resolution() {
  sdl3::Rect rec;
  sdl3::get_display_bounds(sdl3::get_primary_display(), &rec);

  return {rec.w, rec.h};
}

/*
fn void framebuffer_size_callback(GLFWwindow* window, int width, int height) {
  scr_width = width;
  scr_height = height;
	gl::viewport(0,0,width,height);
  Matrix proj = matrix::perspective(70 * math::PI / 180, (double)scr_width / (double)scr_height, 0.1, 100.0);
  default_shader.update_loc("projection", MATRIX4X4, &proj);
}

