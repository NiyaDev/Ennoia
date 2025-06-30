
module ennoia::mesh;
import std::io;
import ennoia::gl;
import ennoia::shader;
import ennoia::texture;
import ennoia::vector;


struct Mesh {
  float[] vertices;
  uint[] indices;

  uint vao, vbo, ebo;
  Shader shader;
}

struct Trio {
  uint vao, vbo, ebo;
}

const float[] BASIC_TRI = {
   0.0,  0.5, 0.0, 1,0,0, 1,1,
  -0.5, -0.5, 0.0, 0,1,0, 1,0,
   0.5, -0.5, 0.0, 1,1,0, 0,0,
};
const uint[] BASIC_IND = {
  0, 1, 2,
};

<* Creates a new Mesh using input vertices and indices
  @param vertices: "The array of vertices to set"
  @param indices:  "In dices of triangles"
  @return "Mesh struct"
 *>
fn Mesh new(float[] vertices = {}, uint[] indices = {}) {
  Mesh output;

  if (vertices.len != 0) {
    output.vertices = vertices;
  } else {
    output.vertices = BASIC_TRI;
  }
  if (indices.len != 0) {
    output.indices = indices;
  } else {
    output.indices = BASIC_IND;
  }

  return output;
}
<* Uploads mesh data to GPU *>
fn Trio Mesh.upload(&self, float[] override = {}) @private {
  Trio output;

  gl::gen_vertex_arrays(1, &output.vao);
  gl::gen_buffers(1, &output.vbo);
  gl::gen_buffers(1, &output.ebo);
  
  gl::bind_vertex_array(output.vao);

  gl::bind_buffer(gl::ARRAY_BUFFER, output.vbo);
  if (override.len == 0) {
    gl::buffer_data(gl::ARRAY_BUFFER, self.vertices.len * float.sizeof, self.vertices, gl::STATIC_DRAW);
  } else {
    gl::buffer_data(gl::ARRAY_BUFFER, override.len * float.sizeof, override, gl::STATIC_DRAW);
  }

  gl::bind_buffer(gl::ELEMENT_ARRAY_BUFFER, output.ebo);
  gl::buffer_data(gl::ELEMENT_ARRAY_BUFFER, self.indices.len * uint.sizeof, self.indices, gl::STATIC_DRAW);

  gl::vertex_attrib_pointer(0, 3, gl::FLOAT, false, 8 * float.sizeof, null);
  gl::enable_vertex_attrib_array(0);
  gl::vertex_attrib_pointer(1, 3, gl::FLOAT, false, 8 * float.sizeof, (void*)(3 * float.sizeof));
  gl::enable_vertex_attrib_array(1);
  gl::vertex_attrib_pointer(2, 2, gl::FLOAT, false, 8 * float.sizeof, (void*)(6 * float.sizeof));
  gl::enable_vertex_attrib_array(2);

  gl::bind_buffer(gl::ARRAY_BUFFER, 0);
  gl::bind_vertex_array(0);

  return output;
}
<**>
fn void Mesh.delete(&self, Trio trio) {
  gl::delete_vertex_arrays(1, &trio.vao);
  gl::delete_buffers(1, &trio.vbo);
  gl::delete_buffers(1, &trio.ebo);
}
<* Draws Mesh
  @param self
  @param position: "Position in world to draw at"
 *>
// TODO: Position not implemented yet
fn void Mesh.draw(&self, Vector3 position, Texture* tex = null) {
  
  //self.vertices[0] = 0;
  Trio trio;
  if (position != (Vector3){0,0,0}) {
    float[] vertices = mem::new_array(float, self.vertices.len);
    mem::copy(vertices, self.vertices, self.vertices.len * float.sizeof);
    //float[] vertices = self.vertices.copy(allocator::heap());
    for (int i; i < (self.vertices.len / 8); i++) {
      usz offset = (usz)i*8;
      vertices[offset + 0] = self.vertices[offset + 0] + position.x;
      vertices[offset + 1] = self.vertices[offset + 1] + position.y;
      vertices[offset + 2] = self.vertices[offset + 2] + position.z;
    }
    trio = self.upload(vertices);
  } else {
    trio = self.upload();
  }

  

  gl::use_program(self.shader.id);
  if (tex != null) gl::bind_texture(gl::TEXTURE_2D, tex.id);
	gl::bind_vertex_array(trio.vao);
	gl::draw_elements(gl::TRIANGLES, 6, gl::UNSIGNED_INT, null);

	self.delete(trio);
}



