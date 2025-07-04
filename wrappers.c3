
module ennoia;


<* Wrapper for clear color
  @param color: "Color to draw background"
 *>
fn void clear_background(Color color) {
  gl::clear_color((float)color.r / 255, (float)color.g / 255, (float)color.b / 255, (float)color.a / 255);
  gl::clear(gl::COLOR_BUFFER_BIT | gl::DEPTH_BUFFER_BIT);
}
<* Swaps buffers and polls events *>
fn void end_drawing() {
  scrollwheel = 0;

  gl::swap_buffers(window);
	gl::poll_events();
}
