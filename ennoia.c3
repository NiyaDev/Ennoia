
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

double deltaTime;
double lastFrame;
bool forceClose = false;

int scrWidth, scrHeight;
int renWidth, renHeight;
float renRes;

float scrollwheel;

Shader defaultShader3d;
Shader defaultShader2d;


<* Initializes Ennoia
  @param width:  "Initial width of screen"
  @require width > 1
  @param height: "Initial height of screen"
  @require height > 1
  @param title:  "Title of window"
  @require title != ""
  @param renderRes: "The value to multiple the screen resolution by to get render resolution"
  @require renderRes > 0.0
 *>
fn void init(int width, int height, String title, float renderRes = 1) {
  scrWidth  = width;
  scrHeight = height;
  renWidth  = (int)((float)width  * renderRes);
  renHeight = (int)((float)height * renderRes);
  renRes = renderRes;
  
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
  gl::blend_func(gl::SRC_ALPHA, gl::ONE_MINUS_SRC_ALPHA);

  // Create default shaders
  defaultShader2d = shader::compile(shader::DEFAULT_VERTEX_2D, shader::DEFAULT_FRAGMENT_2D);
  defaultShader2d.set_vec2("screensize", {(float)renWidth,(float)renHeight});
  defaultShader3d = shader::compile(shader::DEFAULT_VERTEX_3D, shader::DEFAULT_FRAGMENT_3D);
  defaultShader3d.set_mat4x4("projection", matrix::perspective(70 * math::PI / 180, (double)renWidth / (double)renHeight, 0.1, 100.0));

  // Framebuffer
  render::init(renWidth, renHeight);

  // Texture mesh
  textureMesh = mesh::gen_quad();

  // Keybinds
  bulk::load_all_keybinds("resources/keybinds");
  // Options
  bulk::load_all_options("resources/options");
}
<* Checks if the window should close and updating deltatime *>
fn bool window_should_close() {
  double currentFrame = (double)sdl3::get_ticks() / 1000;
  deltaTime = currentFrame - lastFrame;
  lastFrame = currentFrame;

  keybinds::update();
  while (sdl3::poll_event(&event)) {
    if (event.type == sdl3::QUIT) return true;
    // Input
    if (event.type == sdl3::KEYDOWN)    keybinds::add_queue(event.key);
    if (event.type == sdl3::KEYUP)      keybinds::add_queue(event.key);
    if (event.type == sdl3::MOUSEWHEEL) scrollwheel = event.wheel.y;
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

/*
fn void framebuffer_size_callback(GLFWwindow* window, int width, int height) {
  scr_width = width;
  scr_height = height;
	gl::viewport(0,0,width,height);
  Matrix proj = matrix::perspective(70 * math::PI / 180, (double)scr_width / (double)scr_height, 0.1, 100.0);
  default_shader.update_loc("projection", MATRIX4X4, &proj);
}

