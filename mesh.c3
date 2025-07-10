
module ennoia::mesh;
import std::io;
import std::collections;
import ennoia;
/*
import ennoia::gl;
import ennoia::shader;
import ennoia::texture;
import ennoia::vector;
import ennoia::matrix;
import ennoia::camera;
*/


struct Mesh {
  Vertex[] vertices;

  Matrix mat;

  Shader shader;
}

struct Vertex {
  Vector3 position;
  Vector3 normal;
  Vector2 texCoords;
}
const void* VERTEX_POSITION = null;
const void* VERTEX_NORMAL   = (void*)(Vector3.sizeof);
const void* VERTEX_TEXCOORD = (void*)(Vector3.sizeof * 2);

const Vertex[] BASIC_TRI = {
  {{ 0.0,  0.5, 0.0}, {0,0,1}, {1,1}},
  {{-0.5, -0.5, 0.0}, {0,0,1}, {1,0}},
  {{ 0.5, -0.5, 0.0}, {0,0,1}, {0,1}},
};


<* Creates a new Mesh using input vertices and indices
  @param vertices: "The array of vertices to set"
  @return "Mesh struct"
 *>
fn Mesh new(Vertex[] vertices = {}) {
  Mesh output;

  if (vertices.len != 0) {
    output.vertices = vertices;
  } else {
    output.vertices = BASIC_TRI;
  }

  output.mat = matrix::IDENTITY;

  return output;
}
<**>
fn Mesh generate_mesh_test(uint[][] data) {
  Mesh output;

  List{Vertex} vert_list;
  for (int z; z < data.len; z++) {
    for (int x; x < data[z].len; x++) {
      if (data[z][x] == 1) {
        vert_list.push({{(float)x  ,0,(float)z  }, {0,1,0}, {0,0}});
        vert_list.push({{(float)x+1,0,(float)z  }, {0,1,0}, {0,0}});
        vert_list.push({{(float)x  ,0,(float)z+1}, {0,1,0}, {0,0}});
        vert_list.push({{(float)x+1,0,(float)z  }, {0,1,0}, {0,0}});
        vert_list.push({{(float)x  ,0,(float)z+1}, {0,1,0}, {0,0}});
        vert_list.push({{(float)x+1,0,(float)z+1}, {0,1,0}, {0,0}});
      }
    }
  }
  output.mat = matrix::IDENTITY;
  output.vertices = vert_list.to_array(allocator::heap());
  vert_list.free();

  return output;
}

<* Uploads mesh data to GPU *>
fn Tuple{uint, uint} Mesh.upload(&self) @private {
  Tuple{uint, uint} output;

  gl::gen_vertex_arrays(1, &output.first);
  gl::gen_buffers(1, &output.second);
  
  gl::bind_vertex_array(output.first);

  gl::bind_buffer(gl::ARRAY_BUFFER, output.second);
  gl::buffer_data(gl::ARRAY_BUFFER, self.vertices.len * Vertex.sizeof, self.vertices, gl::STATIC_DRAW);

  ennoia::set_vertex_attribute(0, 3, VERTEX_POSITION);
  ennoia::set_vertex_attribute(1, 3, VERTEX_NORMAL);
  ennoia::set_vertex_attribute(2, 2, VERTEX_TEXCOORD);

  gl::bind_buffer(gl::ARRAY_BUFFER, 0);
  gl::bind_vertex_array(0);

  return output;
}
<* Deletes trio from gpu *>
fn void Mesh.delete(&self, Tuple{uint, uint} tup) {
  gl::delete_vertex_arrays(1, &tup.first);
  gl::delete_buffers(1, &tup.second);
}

<* Draws Mesh
  @param self
  @param tex: "Texture to draw on mesh, set to null by default"
 *>
fn void Mesh.draw(&self, Texture* tex = null) {
  Tuple{uint, uint} tup = self.upload();

  gl::use_program(ennoia::default_shader.id);
  Matrix mat = camera::get_matrix();
  ennoia::default_shader.update_loc("view",  MATRIX4X4, &mat);
  ennoia::default_shader.update_loc("model", MATRIX4X4, &self.mat);
  if (tex != null) gl::bind_texture(gl::TEXTURE_2D, tex.id);
	gl::bind_vertex_array(tup.first);
	gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len);

	self.delete(tup);
}
<* Draws mesh using matrix override
  @param self
  @param over: "Matrix used as an override to meshes inbuilt"
  @param tex: "Texture to draw on mesh, set to null by default"
 *>
fn void Mesh.draw_at(&self, Matrix over, Texture* tex = null) {
  Tuple{uint, uint} tup = self.upload();

  gl::use_program(ennoia::default_shader.id);
  Matrix view = camera::get_matrix();
  ennoia::default_shader.update_loc("view",  MATRIX4X4, &view);
  ennoia::default_shader.update_loc("model", MATRIX4X4, &over);
  if (tex != null) gl::bind_texture(gl::TEXTURE_2D, tex.id);
	gl::bind_vertex_array(tup.first);
	gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len);

	self.delete(tup);
}


