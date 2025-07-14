
module ennoia;
import std::io;
import std::math;


SDL_Window* window;
SDL_Surface* surface;
SDL_GLContext* glcontext;
SDL_Event event;

//uint framebuffer = 0;
//uint depthRenderBuffer;
//Texture render;
//Mesh renderQuad;
Color bgColor = color::PURPLE;

double deltaTime;
double lastFrame;
bool forceClose = false;

int scrWidth, scrHeight;
int renWidth, renHeight;
float renRes;

float scrollwheel;

Shader default_shader;


<* Initializes Ennoia
  @param width:  "Initial width of screen"
  @param height: "Initial height of screen"
  @param title:  "Title of window"
 *>
fn void init(int width, int height, String title, float renderRes = 1) {
  scrWidth  = width;
  scrHeight = height;
  renWidth  = (int)((float)width  * renderRes);
  renHeight = (int)((float)height * renderRes);
  renRes = renderRes;
  
  // Initialize SDL3
	assert(sdl::init(sdl::INIT_VIDEO | sdl::INIT_AUDIO), "[ERROR] - ENNOIA::INIT::INIT [Failed to initialize SDL3 (%s)]", sdl::get_error());
	sdl::gl_set_attribute(GLAttr.CONTEXT_MAJOR_VERSION, 3);
	sdl::gl_set_attribute(GLAttr.CONTEXT_MINOR_VERSION, 3);
	sdl::gl_set_attribute(GLAttr.CONTEXT_PROFILE_MASK, sdl::CONTEXT_PROFILE_CORE);

  // Create window
  window = sdl::create_window(title.zstr_tcopy(), scrWidth, scrHeight, sdl::WINDOW_OPENGL);
  assert(window != null, "[ERROR] - ENNOIA::INIT::CREATE_WINDOW [Failed to create sdl3 window(%s)]", sdl::get_error());

  // Create OpenGL context
  glcontext = sdl::gl_create_context(window);
  assert(glcontext != null, "[ERROR] - ENNOIA::INIT::CREATE_CONTEXT [Failed to create SDL_GL context (%s)]", (String)sdl::get_error()[..1024]);
  assert(sdl::gl_make_current(window, glcontext), "[ERROR] - ENNOIA::INIT::MAKE_CURRENT [Failed to make gl context current (%s)]", sdl::get_error()); 

  // Enable depth testing
  gl::enable(gl::DEPTH_TEST);

  // Create default shader
  default_shader = shader::compile();
  default_shader.set_mat4x4("projection", matrix::perspective(70 * math::PI / 180, (double)renWidth / (double)renHeight, 0.1, 100.0));

  // Framebuffer
  render::init(renWidth, renHeight);
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

<* Starts the process of drawing *>
fn void start_drawing() {
  gl::bind_framebuffer(gl::FRAMEBUFFER, render::framebuffer);
  gl::enable(gl::DEPTH_TEST);
  gl::viewport(0, 0, renWidth, renHeight);

  clear_background(bgColor);
}
<* Swaps buffers and polls events *>
fn void end_drawing() {
  scrollwheel = 0;

  // Set up default framebuffer
  gl::bind_framebuffer(gl::FRAMEBUFFER, 0);
  gl::disable(gl::DEPTH_TEST);
  gl::clear_color((float)color::ORANGE.r / 255, (float)color::ORANGE.g / 255, (float)color::ORANGE.b / 255, (float)color::ORANGE.a / 255);
  gl::clear(gl::COLOR_BUFFER_BIT);
  gl::viewport(0, 0, scrWidth, scrHeight);


  // Draw renderquad to screen
  render::renderQuad.shader.use();
  gl::active_texture(gl::TEXTURE0);
  gl::bind_vertex_array(render::renderQuad.vao);
  gl::bind_texture(gl::TEXTURE_2D, render::renderTexture.id);
  gl::draw_arrays(gl::TRIANGLES, 0, render::renderQuad.vertices.len);

  sdl::gl_swap_window(window);
}

/*
fn void framebuffer_size_callback(GLFWwindow* window, int width, int height) {
  scr_width = width;
  scr_height = height;
	gl::viewport(0,0,width,height);
  Matrix proj = matrix::perspective(70 * math::PI / 180, (double)scr_width / (double)scr_height, 0.1, 100.0);
  default_shader.update_loc("projection", MATRIX4X4, &proj);
}

