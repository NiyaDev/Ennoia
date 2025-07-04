
module ennoia;
import std::io;
import std::math;


GLFWwindow* window;

double deltaTime;
double lastFrame;

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

  gl::init();
  gl::window_hint(gl::CONTEXT_VERSION_MAJOR, 3);
	gl::window_hint(gl::CONTEXT_VERSION_MINOR, 3);
	gl::window_hint(gl::OPENGL_PROFILE, gl::OPENGL_CORE_PROFILE);

	window = gl::create_window(scr_width, scr_height, title.zstr_tcopy(), null, null);
  assert(window != null, "[ERROR] - ENNOIA::INIT [Failed to create GLFW window]");

  gl::make_context_current(window);
  gl::set_framebuffer_size_callback(window, &framebuffer_size_callback);
  gl::set_scroll_callback(window, &mousewheel_callback);

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
  double currentFrame = gl::get_time();
  deltaTime = currentFrame - lastFrame;
  lastFrame = currentFrame;

  return gl::window_should_close(window);
}

fn void framebuffer_size_callback(GLFWwindow* window, int width, int height) {
  scr_width = width;
  scr_height = height;
	gl::viewport(0,0,width,height);
  Matrix proj = matrix::perspective(70 * math::PI / 180, (double)scr_width / (double)scr_height, 0.1, 100.0);
  default_shader.update_loc("projection", MATRIX4X4, &proj);
}

//fn void mousewheel_callback(int wheel, int direction, int x, int y) {
fn void mousewheel_callback(GLFWwindow* window, double xoffset, double yoffset) {
  scrollwheel = (float)yoffset;
}

