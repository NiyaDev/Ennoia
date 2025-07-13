
module ennoia::mesh;
import std::io;
import std::collections;
import ennoia;


struct Mesh {
  Vertex[] vertices;

  uint vao, vbo;

  Shader shader;
}

struct Vertex {
  Vector3 position;
  Vector3 normal;
  Vector2 texCoords;
  //Color   colors;
  //Vector4 tangents;
  //Vector2 texCoords2;
}
const void* VERTEX_POSITION = null;
const void* VERTEX_NORMAL   = (void*)(Vector3.sizeof);
const void* VERTEX_TEXCOORD = (void*)((long)VERTEX_NORMAL * 2);
const void* VERTEX_COLORS   = (void*)(Color.sizeof);

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

  output.upload();

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
  output.vertices = vert_list.to_array(allocator::heap());
  vert_list.free();

  return output;
}

<* Uploads mesh data to GPU *>
fn void Mesh.upload(&self) {
  gl::gen_vertex_arrays(1, &self.vao);
  gl::gen_buffers(1, &self.vbo);
  
  gl::bind_vertex_array(self.vao);

  gl::bind_buffer(gl::ARRAY_BUFFER, self.vbo);
  gl::buffer_data(gl::ARRAY_BUFFER, self.vertices.len * Vertex.sizeof, self.vertices, gl::STATIC_DRAW);

  ennoia::set_vertex_attribute(0, 3, VERTEX_POSITION);
  ennoia::set_vertex_attribute(1, 3, VERTEX_NORMAL);
  ennoia::set_vertex_attribute(2, 2, VERTEX_TEXCOORD);

  gl::bind_buffer(gl::ARRAY_BUFFER, 0);
  gl::bind_vertex_array(0);
}
<* Deletes trio from gpu *>
fn void Mesh.delete(&self) {
  gl::delete_vertex_arrays(1, &self.vao);
  gl::delete_buffers(1, &self.vbo);
}

<* Draws Mesh
  @param position: "Position in space to draw mesh. Default is {0,0,0}."
  @param scale:    "Scale to draw mesh at. Default is {1,1,1}."
  @param rotation: "Rotation to apply to mesh. Default is {0,0,0}."
  @param texture:  "Texture to draw on mesh, set to null by default"
 *>
fn void Mesh.draw(&self, Vector3 position = {}, Vector3 scale = {1,1,1}, Vector3 rotation = {}, Texture* texture = null) {
  self.upload();

  if (self.shader.id != 0) {
    self.shader.use();
  } else {
    ennoia::default_shader.use();
  }

  //Matrix view = camera::get_matrix();
  //ennoia::default_shader.update_loc("view",  MATRIX4X4, &view);
  ennoia::default_shader.set_mat4x4("view", camera::get_matrix());

  //Matrix transform = matrix::IDENTITY.translate(position).rotate(rotation).scale(scale);
  //ennoia::default_shader.update_loc("model", MATRIX4X4, &transform);
  ennoia::default_shader.set_mat4x4("model", matrix::IDENTITY.translate(position).rotate(rotation).scale(scale));
  if (texture != null) {
    gl::bind_texture(gl::TEXTURE_2D, texture.id);
  } else {
    gl::bind_texture(gl::TEXTURE_2D, 0);
  }
	gl::bind_vertex_array(self.vao);
	gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len);

	self.delete();
}


