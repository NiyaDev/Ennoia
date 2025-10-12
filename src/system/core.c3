
module ennoia;
import std::io;
import std::math;
import sdl3;
import gl;


<* Initializes Ennoia
  @param width:  "Initial width of screen"
  @param height: "Initial height of screen"
  @param title:  "Title of window"
  @require title != ""
  @param scale: "The value to multiple the screen resolution by to get render resolution"
 *>
fn void init(int width = -1, int height = -1, String title = "ENNOIA", float scale = 0) @export("init") {
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
  defaultShader2d.set_vec2f("screensize", {(float)renWidth,(float)renHeight});
  defaultShader3d = shader::compile(shader::DEFAULT_VERTEX_3D, shader::DEFAULT_FRAGMENT_3D);
  defaultShader3d.set_mat4x4("projection", matrix::perspective{float}(70 * math::PI / 180, (float)renWidth / (float)renHeight, 0.1, 100.0).transpose());

  // Framebuffer
  render::init(renWidth, renHeight);

  // Load defaults
  bulk::load_all("resources/default");
  textureMesh = mesh::gen_quad();

  meshes.set("tri", mesh::gen_tri(1,1));
  meshes.set("cube", mesh::gen_cube(1,1,1));

  // Keybinds
  bulk::load_all_keybinds("resources/keybinds");
}
<* Cleans up resources *>
fn void clean() @export("clean") {
  // Destroy window, OpenGL context, and event structure
  sdl3::destroy_window(window);
  window = null;
  sdl3::gl_destroy_context(glcontext);
  glcontext = null;
  event = {};

  // Clean up mesh used for textures
  textureMesh.clean();

  // Clean up timing variables
  deltaTime = 0;
  lastFrame = 0;
  forceClose = false;

  // Clean up shaders
  defaultShader2d.clean();
  defaultShader3d.clean();

  // Clean up keybindings
  keybinds.clear();
  keyqueue.clear();

  // Clean up mouse controls
  mousePosition = {};
  mouseButtons = {};
  mouseButtonsHeld = {};
  mouseButtonsUp = {};
  scrollwheel = 0;

  // Clean up options ans localization
  options.clear();
  localization.clear();

  // Clean up Textures
  textures.@each(; String key, Texture val) { val.clean(); };
  textures.clear();

  // Clean up fonts
  fonts.@each(; String key, Font val) { val.clean(); };
  fonts.clear();

  // Clean up Meshes
  meshes.@each(; String key, Mesh val) { val.clean(); };
  meshes.clear();
  
  // Clean up shaders
  shaders.@each(; String key, Shader val) { val.clean(); };
  shaders.clear();

  // Clean up UI handler
  //ui::clean();

  // Clean up renderbuffers
  render::clean();

  // Quit SDL3
  sdl3::quit();
}
<* Checks if the window should close and updating deltatime *>
fn bool window_should_close() @export("windowshouldclose") {
  // Calculate deltaTime
  double currentFrame = (double)sdl3::get_ticks() / 1000;
  deltaTime = currentFrame - lastFrame;
  lastFrame = currentFrame;

  // Update keybinds
  keybinds::update();

  // Poll event handler
  while (sdl3::poll_event(&event)) {
    switch (event.type) {
      case QUIT: return true;

      case KEY_DOWN:
      case KEY_UP:
        keybinds::add_queue(event.key);

      case WINDOW_SHOWN: break;
      case WINDOW_EXPOSED: break;
      case WINDOW_MOVED: break;
      case WINDOW_PIXEL_SIZE_CHANGED: break;
      case WINDOW_MINIMIZED: break;
      case WINDOW_RESTORED: break;
      case WINDOW_MOUSE_ENTER: break;
      case WINDOW_MOUSE_LEAVE: break;
      case WINDOW_FOCUS_GAINED: break;
      case WINDOW_FOCUS_LOST: break;
      case WINDOW_SAFE_AREA_CHANGED: break;
      case WINDOW_OCCLUDED: break;

      case MOUSE_MOTION:
        Vec2f temp = {event.motion.x, event.motion.y};
        mouseDelta = {event.motion.xrel, event.motion.yrel};
        mousePosition = temp;
      case MOUSE_BUTTON_DOWN:
        mouseButtons[event.button.button-1] = true;
      case MOUSE_BUTTON_UP:
        mouseButtonsUp[event.button.button-1] = true;
      case MOUSE_WHEEL:
        scrollwheel = event.wheel.y;

      case SENSOR_UPDATE: break;

      default: io::printfn("Unhandled event [0x%x]",event.type);
    }
  }

  // Default exit button
  if (keybinds.has_key("quit") && keybinds::pressed("quit")) forceClose = true;

  return forceClose;
}

<* Sets vertex attribute data
  @param location
  @param size: "The number of floats in data"
  @param offset: "Offset to each entry of the data"
 *>
fn void set_vertex_attribute(uint location, uint size, void* offset) @export("setvertexattribute") {
  gl::vertex_attrib_pointer(location, size, gl::FLOAT, false, Vertex.sizeof, offset);
  gl::enable_vertex_attrib_array(location);
}

