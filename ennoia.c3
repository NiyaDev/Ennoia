
module ennoia;
import std::io;
import std::math;


//GLFWwindow* window;
SDL_Window* window;
SDL_Surface* surface;
SDL_GLContext* glcontext;
SDL_Event event;

double deltaTime;
double lastFrame;
bool forceClose = false;

int scr_width, scr_height;

float scrollwheel;

Shader default_shader;


<* Initializes Ennoia
  @param width:  "Initial width of screen"
  @param height: "Initial height of screen"
  @param title:  "Title of window"
 *>
fn void init(int width, int height, String title) {
  scr_width = width;
  scr_height = height;
  
	assert(sdl::init(sdl::INIT_VIDEO | sdl::INIT_AUDIO), "[ERROR] - ENNOIA::INIT::INIT [Failed to initialize SDL3 (%s)]", sdl::get_error());
	sdl::gl_set_attribute(GLAttr.CONTEXT_MAJOR_VERSION, 3);
	sdl::gl_set_attribute(GLAttr.CONTEXT_MINOR_VERSION, 3);
	sdl::gl_set_attribute(GLAttr.CONTEXT_PROFILE_MASK, sdl::CONTEXT_PROFILE_CORE);

  window = sdl::create_window(title.zstr_tcopy(), scr_width, scr_height, sdl::WINDOW_OPENGL);
  assert(window != null, "[ERROR] - ENNOIA::INIT::CREATE_WINDOW [Failed to create sdl3 window(%s)]", sdl::get_error());
  
  glcontext = sdl::gl_create_context(window);
  assert(glcontext != null, "[ERROR] - ENNOIA::INIT::CREATE_CONTEXT [Failed to create SDL_GL context (%s)]", (String)sdl::get_error()[..1024]);
  assert(sdl::gl_make_current(window, glcontext), "[ERROR] - ENNOIA::INIT::MAKE_CURRENT [Failed to make gl context current (%s)]", sdl::get_error());

  gl::enable(gl::DEPTH_TEST);

  default_shader = shader::compile();
  default_shader.add_loc("view", MATRIX4X4);
  default_shader.add_loc("model", MATRIX4X4);
  default_shader.add_loc("projection", MATRIX4X4);
  Matrix proj = matrix::perspective(70 * math::PI / 180, (double)scr_width / (double)scr_height, 0.1, 100.0);
  default_shader.update_loc("projection", MATRIX4X4, &proj);
}
<* Checks if the window should close and updating deltatime *>
fn bool window_should_close() {
  double currentFrame = (double)sdl::get_ticks() / 1000;
  deltaTime = currentFrame - lastFrame;
  lastFrame = currentFrame;

  keybinds::update();
  while (sdl::poll_event(&event)) {
    if (event.type == sdl::QUIT) return true;
    // Input
    if (event.type == sdl::KEYDOWN)    keybinds::add_queue(event.key);
    if (event.type == sdl::KEYUP)      keybinds::add_queue(event.key);
    if (event.type == sdl::MOUSEWHEEL) scrollwheel = event.wheel.y;
  }
  return forceClose;
}

/*
fn void framebuffer_size_callback(GLFWwindow* window, int width, int height) {
  scr_width = width;
  scr_height = height;
	gl::viewport(0,0,width,height);
  Matrix proj = matrix::perspective(70 * math::PI / 180, (double)scr_width / (double)scr_height, 0.1, 100.0);
  default_shader.update_loc("projection", MATRIX4X4, &proj);
}

fn void mousewheel_callback(GLFWwindow* window, double xoffset, double yoffset) {
  scrollwheel = (float)yoffset;
}
*/

