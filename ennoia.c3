
module ennoia;


GLFWwindow* window;

float deltaTime;
float lastFrame;


<* Initializes Ennoia
  @param width:  "Initial width of screen"
  @param height: "Initial height of screen"
  @param title:  "Title of window"
 *>
fn void init(int width, int height, String title) {
  gl::init();
  gl::window_hint(gl::CONTEXT_VERSION_MAJOR, 3);
	gl::window_hint(gl::CONTEXT_VERSION_MINOR, 3);
	gl::window_hint(gl::OPENGL_PROFILE, gl::OPENGL_CORE_PROFILE);

	window = gl::create_window(width, height, title.zstr_tcopy(), null, null);
  assert(window != null, "[ERROR] - ENNOIA::INIT [Failed to create GLFW window]");

  gl::make_context_current(window);
}
<* Checks if the window should close and updating deltatime *>
fn bool window_should_close() {
  float currentFrame = gl::get_time();
  deltaTime = currentFrame - lastFrame;
  lastFrame = currentFrame;

  return gl::window_should_close(window);
}

