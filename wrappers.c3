
module ennoia;
import std::io;
import std::collections;



<* Wrapper for clear color
  @param color: "Color to draw background"
 *>
fn void clear_background(Color color) {
  gl::clear_color((float)color.r / 255, (float)color.g / 255, (float)color.b / 255, (float)color.a / 255);
  gl::clear(gl::COLOR_BUFFER_BIT | gl::DEPTH_BUFFER_BIT);
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


