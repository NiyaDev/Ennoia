
module ennoia::mesh;
import ennoia::gl;
import ennoia::shader;
import ennoia::texture;


struct Mesh {
  float[] vertices;
  uint[] indices;

  uint vao, vbo;
  Shader shader;
}

<* Creates a new Mesh using input vertices and indices
  @param vertices: "The array of vertices to set"
  @param indices:  "In dices of triangles"
  @return "Mesh struct"
 *>
fn Mesh new(float[] vertices = {}, uint[] indices = {}) {
  Mesh output;

  float[] vert;
  if (vertices.len > 3) {
    vert = vertices;
  } else {
    vert = {
       0.0,  0.5, 0.0, 1,0,0, 1,1,
      -0.5, -0.5, 0.0, 0,1,0, 1,0,
       0.5, -0.5, 0.0, 1,1,0, 0,0,
    };
  }
  uint[] ind;
  if (indices.len > 3) {
    ind = indices;
  } else {
    ind = {0, 1, 2};
  }

  uint ebo;

  gl::gen_vertex_arrays(1, &output.vao);
  gl::gen_buffers(1, &output.vbo);
  gl::gen_buffers(1, &ebo);
  
  gl::bind_vertex_array(output.vao);

  gl::bind_buffer(gl::ARRAY_BUFFER, output.vbo);
  gl::buffer_data(gl::ARRAY_BUFFER, vert.len * float.sizeof, vert, gl::STATIC_DRAW);

  gl::bind_buffer(gl::ELEMENT_ARRAY_BUFFER, ebo);
  gl::buffer_data(gl::ELEMENT_ARRAY_BUFFER, ind.len * uint.sizeof, ind, gl::STATIC_DRAW);

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
<* Draws Mesh
  @param self
  @param position: "Position in world to draw at"
 *>
// TODO: Position not implemented yet
fn void Mesh.draw(&self, Vector3 position, Texture* tex = null) {
  gl::use_program(self.shader.id);
  if (tex != null) gl::bind_texture(gl::TEXTURE_2D, tex.id);
	gl::bind_vertex_array(self.vao);
	gl::draw_elements(gl::TRIANGLES, 6, gl::UNSIGNED_INT, null);
}



