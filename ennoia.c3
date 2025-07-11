
module ennoia;
import std::io;
import std::math;


//GLFWwindow* window;
SDL_Window* window;
SDL_Surface* surface;
SDL_GLContext* glcontext;
SDL_Event event;

uint framebuffer = 0;
uint depthRenderBuffer;
Texture render;
int[1] drawBuffers = {gl::COLOR_ATTACHMENT0};
Mesh renderQuad;
//Shader renderShader;
Color bgColor = color::PURPLE;

double deltaTime;
double lastFrame;
bool forceClose = false;

int scrWidth, scrHeight;

float scrollwheel;

Shader default_shader;


<* Initializes Ennoia
  @param width:  "Initial width of screen"
  @param height: "Initial height of screen"
  @param title:  "Title of window"
 *>
fn void init(int width, int height, String title) {
  scrWidth = width;
  scrHeight = height;
  
  // Initialize SDL3
	assert(sdl::init(sdl::INIT_VIDEO | sdl::INIT_AUDIO), "[ERROR] - ENNOIA::INIT::INIT [Failed to initialize SDL3 (%s)]", sdl::get_error());
	sdl::gl_set_attribute(GLAttr.CONTEXT_MAJOR_VERSION, 3);
	sdl::gl_set_attribute(GLAttr.CONTEXT_MINOR_VERSION, 3);
	sdl::gl_set_attribute(GLAttr.CONTEXT_PROFILE_MASK, sdl::CONTEXT_PROFILE_CORE);

  // Create window
  window = sdl::create_window(title.zstr_tcopy(), scrWidth, scrHeight, sdl::WINDOW_OPENGL);
  assert(window != null, "[ERROR] - ENNOIA::INIT::CREATE_WINDOW [Failed to create sdl3 window(%s)]", sdl::get_error());

  // Generate texture framebuffer
  gl::gen_framebuffers(1, &framebuffer);
  gl::bind_framebuffer(gl::FRAMEBUFFER, framebuffer);
  render = texture::new(scrWidth, scrHeight);
  gl::framebuffer_texture_2d(gl::FRAMEBUFFER, gl::COLOR_ATTACHMENT0, gl::TEXTURE_2D, render.id, 0);

  gl::gen_renderbuffers(1, &depthRenderBuffer);
  gl::bind_renderbuffer(gl::RENDERBUFFER, depthRenderBuffer);
  // TODO: Change from DEPTH_COMPONENT to DEPTH24_STENCIL8 and DEPTH_ATTACHMENT to DEPTH_STENCIL_ATTACHMENT
  gl::renderbuffer_storage(gl::RENDERBUFFER, gl::DEPTH_COMPONENT, scrWidth, scrHeight);
  gl::framebuffer_renderbuffer(gl::FRAMEBUFFER,gl::DEPTH_ATTACHMENT, gl::RENDERBUFFER, depthRenderBuffer);
  assert(gl::check_framebuffer_status(gl::FRAMEBUFFER) != gl::FRAMEBUFFER_COMPLETE, "[ERROR] - ENNOIA::INIT::CHECKFRAMEBUFFERSTATUS [Framebuffer failed to initialize]");
  gl::bind_framebuffer(gl::FRAMEBUFFER, 0);

  //gl::framebuffer_texture(gl::FRAMEBUFFER, gl::COLOR_ATTACHMENT0, render.id, 0);
  //gl::draw_buffers(1, &drawBuffers);

  gl::bind_framebuffer(gl::FRAMEBUFFER, framebuffer);

  // Create OpenGL context
  glcontext = sdl::gl_create_context(window);
  assert(glcontext != null, "[ERROR] - ENNOIA::INIT::CREATE_CONTEXT [Failed to create SDL_GL context (%s)]", (String)sdl::get_error()[..1024]);
  assert(sdl::gl_make_current(window, glcontext), "[ERROR] - ENNOIA::INIT::MAKE_CURRENT [Failed to make gl context current (%s)]", sdl::get_error());

  // Enable depth testing
  gl::enable(gl::DEPTH_TEST);

  // Create default texture
  default_shader = shader::compile();
  default_shader.add_loc("view", MATRIX4X4);
  default_shader.add_loc("model", MATRIX4X4);
  default_shader.add_loc("projection", MATRIX4X4);
  Matrix proj = matrix::perspective(70 * math::PI / 180, (double)scrWidth / (double)scrHeight, 0.1, 100.0);
  default_shader.update_loc("projection", MATRIX4X4, &proj);

  // Ready render quad
  renderQuad = {
    {
      {{-1, 1, 0}, {0,0,0}, {0,1}},
      {{-1,-1, 0}, {0,0,0}, {0,0}},
      {{ 1,-1, 0}, {0,0,0}, {1,0}},

      {{-1, 1, 0}, {0,0,0}, {0,1}},
      {{ 1,-1, 0}, {0,0,0}, {1,0}},
      {{ 1, 1, 0}, {0,0,0}, {1,1}},
    },
    matrix::IDENTITY,
    shader::compile(shader::FB_VERTEX, shader::FB_FRAGMENT),
  };
  renderQuad.shader.add_loc("screenTexture", INT);
  int zero;
  renderQuad.shader.update_loc("screenTexture", INT, &zero);
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

