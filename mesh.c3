
module ennoia::mesh;
import std::io;
import ennoia::gl;
import ennoia::shader;
import ennoia::texture;
import ennoia::vector;
import ennoia::matrix;
import ennoia::camera;


struct Mesh {
  float[] vertices;

  Matrix mat;

  Shader shader;
}

struct Trio {
  uint vao, vbo;
}

const float[] BASIC_TRI = {
   0.0,  0.5, 0.0, 1,1,
  -0.5, -0.5, 0.0, 1,0,
   0.5, -0.5, 0.0, 0,0,
};

<* Creates a new Mesh using input vertices and indices
  @param vertices: "The array of vertices to set"
  @return "Mesh struct"
 *>
fn Mesh new(float[] vertices = {}) {
  Mesh output;

  if (vertices.len != 0) {
    output.vertices = vertices;
  } else {
    output.vertices = BASIC_TRI;
  }

  output.mat = matrix::IDENTITY;

  return output;
}
<* Uploads mesh data to GPU *>
fn Trio Mesh.upload(&self) @private {
  Trio output;

  gl::gen_vertex_arrays(1, &output.vao);
  gl::gen_buffers(1, &output.vbo);
  
  gl::bind_vertex_array(output.vao);

  gl::bind_buffer(gl::ARRAY_BUFFER, output.vbo);
  gl::buffer_data(gl::ARRAY_BUFFER, self.vertices.len * float.sizeof, self.vertices, gl::STATIC_DRAW);

  // Position attrib
  gl::vertex_attrib_pointer(0, 3, gl::FLOAT, false, 5 * float.sizeof, null);
  gl::enable_vertex_attrib_array(0);
  // Texture coord attrib
  gl::vertex_attrib_pointer(1, 2, gl::FLOAT, false, 5 * float.sizeof, (void*)(3 * float.sizeof));
  gl::enable_vertex_attrib_array(1);

  gl::bind_buffer(gl::ARRAY_BUFFER, 0);
  gl::bind_vertex_array(0);

  return output;
}
<**>
fn void Mesh.delete(&self, Trio trio) {
  gl::delete_vertex_arrays(1, &trio.vao);
  gl::delete_buffers(1, &trio.vbo);
}
<* Draws Mesh
  @param self
 *>
fn void Mesh.draw(&self, Texture* tex = null) {
  Trio trio = self.upload();

  gl::use_program(ennoia::default_shader.id);
  Matrix mat = camera::get_matrix();
  ennoia::default_shader.update_loc("view",  MATRIX4X4, &mat);
  ennoia::default_shader.update_loc("model", MATRIX4X4, &self.mat);
  //gl::use_program(self.shader.id);
  if (tex != null) gl::bind_texture(gl::TEXTURE_2D, tex.id);
	gl::bind_vertex_array(trio.vao);
	gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len / 5);

	self.delete(trio);
}
<**>
fn void Mesh.draw_at(&self, Matrix over, Texture* tex = null) {
  Trio trio = self.upload();

  gl::use_program(ennoia::default_shader.id);
  Matrix view = camera::get_matrix();
  ennoia::default_shader.update_loc("view",  MATRIX4X4, &view);
  ennoia::default_shader.update_loc("model", MATRIX4X4, &over);
  if (tex != null) gl::bind_texture(gl::TEXTURE_2D, tex.id);
	gl::bind_vertex_array(trio.vao);
	gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len / 5);

	self.delete(trio);
}


