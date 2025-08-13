
module ennoia::mesh;
import std::io;
import std::collections;
import ennoia;


struct Mesh {
  Vertex[] vertices;

  uint vao, vbo;

  Shader shader;
  Texture* texture;
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
const Vertex[] BASIC_QUAD = {
  {{-1, 1, 0}, {}, {0,1}},
  {{-1,-1, 0}, {}, {0,0}},
  {{ 1,-1, 0}, {}, {1,0}},

  {{-1, 1, 0}, {}, {0,1}},
  {{ 1,-1, 0}, {}, {1,0}},
  {{ 1, 1, 0}, {}, {1,1}},
};
const Vertex[] BASIC_CUBE = {
  // Back
  {{-0.5, -0.5, -0.5},{0,0,1},{0,0}},
  {{ 0.5, -0.5, -0.5},{0,0,1},{1,0}},
  {{ 0.5,  0.5, -0.5},{0,0,1},{1,1}},
  {{ 0.5,  0.5, -0.5},{0,0,1},{1,1}},
  {{-0.5,  0.5, -0.5},{0,0,1},{0,1}},
  {{-0.5, -0.5, -0.5},{0,0,1},{0,0}},
  // Front
  {{-0.5, -0.5,  0.5},{0,0,1},{0,0}},
  {{ 0.5, -0.5,  0.5},{0,0,1},{1,0}},
  {{ 0.5,  0.5,  0.5},{0,0,1},{1,1}},
  {{ 0.5,  0.5,  0.5},{0,0,1},{1,1}},
  {{-0.5,  0.5,  0.5},{0,0,1},{0,1}},
  {{-0.5, -0.5,  0.5},{0,0,1},{0,0}},
  // Left
  {{-0.5,  0.5,  0.5},{0,0,1},{1,0}},
  {{-0.5,  0.5, -0.5},{0,0,1},{1,1}},
  {{-0.5, -0.5, -0.5},{0,0,1},{0,1}},
  {{-0.5, -0.5, -0.5},{0,0,1},{0,1}},
  {{-0.5, -0.5,  0.5},{0,0,1},{0,0}},
  {{-0.5,  0.5,  0.5},{0,0,1},{1,0}},
  // Right
  {{ 0.5,  0.5,  0.5},{0,0,1},{1,0}},
  {{ 0.5,  0.5, -0.5},{0,0,1},{1,1}},
  {{ 0.5, -0.5, -0.5},{0,0,1},{0,1}},
  {{ 0.5, -0.5, -0.5},{0,0,1},{0,1}},
  {{ 0.5, -0.5,  0.5},{0,0,1},{0,0}},
  {{ 0.5,  0.5,  0.5},{0,0,1},{1,0}},
  // Bottom
  {{-0.5, -0.5, -0.5},{0,0,1},{0,1}},
  {{ 0.5, -0.5, -0.5},{0,0,1},{1,1}},
  {{ 0.5, -0.5,  0.5},{0,0,1},{1,0}},
  {{ 0.5, -0.5,  0.5},{0,0,1},{1,0}},
  {{-0.5, -0.5,  0.5},{0,0,1},{0,0}},
  {{-0.5, -0.5, -0.5},{0,0,1},{0,1}},
  // Top
  {{-0.5,  0.5, -0.5},{0,0,1},{0,1}},
  {{ 0.5,  0.5, -0.5},{0,0,1},{1,1}},
  {{ 0.5,  0.5,  0.5},{0,0,1},{1,0}},
  {{ 0.5,  0.5,  0.5},{0,0,1},{1,0}},
  {{-0.5,  0.5,  0.5},{0,0,1},{0,0}},
  {{-0.5,  0.5, -0.5},{0,0,1},{0,1}},
};


<**>
fn Mesh[] load(String filename) {
  List{Mesh} list;
  
  String data = (String)file::load_temp(filename)!!;
  String[] lines = data.tsplit("\n");

  for (int i; i < lines.len; i++) {
    String[] line = lines[i].split(" ");
    switch (line[0]) {
      case "#": continue;
      case "o":  // Object
      case "v":  // Vertex
      case "vn": // Normal
      case "vt": // TextureCoord
    }
  }

  Mesh[] output = list.to_array(allocator::heap());
  list.free();
  return output;
}
<* Creates a new Mesh using input vertices and indices
  @param vertices: "The array of vertices to set"
  @return "Mesh struct"
 *>
fn Mesh new(Vertex[] vertices = {}) {
  return gen_triangle();
}

// Mesh generation
<* Generates a simple Triangle mesh *>
fn Mesh gen_triangle() {
  Mesh output = {mem::new_array(Vertex, BASIC_TRI.len), 0, 0, {}, null};
  mem::copy(output.vertices, BASIC_TRI, Vertex.sizeof * BASIC_TRI.len);
  output.upload();

  return output;
}
<* Generates a simple Quad mesh *>
fn Mesh gen_quad() {
  Mesh output = {mem::new_array(Vertex, BASIC_QUAD.len), 0, 0, {}, null};
  mem::copy(output.vertices, BASIC_QUAD, Vertex.sizeof * BASIC_QUAD.len);
  output.upload();

  return output;
}
<* Generates a simple Cube mesh *>
fn Mesh gen_cube() {
  Mesh output = {mem::new_array(Vertex, BASIC_CUBE.len), 0, 0, {}, null};
  mem::copy(output.vertices, BASIC_CUBE, Vertex.sizeof * BASIC_CUBE.len);
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
  output.upload();

  return output;
}
<* Cleans up data *>
fn void Mesh.clean(&self) {
  self.delete();
  free(self.vertices);
  self.shader.clean();
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

<* Changes the TexCoords of the mesh and re-uploads it
  @param newCoords: "Array of new texCoords"
  @require newCoords.len == self.vertices.len
 *>
fn void Mesh.update_texcoords(&self, Vector2[] newCoords) {
  for (int i; i < newCoords.len; i++) {
    self.vertices[i].texCoords = newCoords[i];
  }

  self.delete();
  self.upload();
}

<* Draws Mesh
  @param position: "Position in space to draw mesh. Default is {0,0,0}."
  @param scale:    "Scale to draw mesh at. Default is {1,1,1}."
  @param rotation: "Rotation to apply to mesh. Default is {0,0,0}."
  @param texture:  "Texture to draw on mesh, set to null by default"
 *>
fn void Mesh.draw(&self, Vector3 position = {}, Vector3 scale = {1,1,1}, Vector3 rotation = {}, Texture* texture = null) {
  if (self.shader.id != 0) {
    self.shader.use();
  } else {
    ennoia::defaultShader3d.use();
  }

  ennoia::defaultShader3d.set_mat4x4("view", camera::get_matrix());
  ennoia::defaultShader3d.set_mat4x4("model", matrix::IDENTITY.translate(position).rotate(rotation).scale(scale));
  
  if (texture != null) {
    gl::bind_texture(gl::TEXTURE_2D, texture.id);
  } else {
    if (self.texture != null) {
      gl::bind_texture(gl::TEXTURE_2D, self.texture.id);
    } else {
      gl::bind_texture(gl::TEXTURE_2D, 0);
    }
  }

	gl::bind_vertex_array(self.vao);
	gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len);
}
<* Draws Mesh in 2d space3
  @param position: "Position in space to draw mesh. Default is {0,0,0}."
  @param scale:    "Scale to draw mesh at. Default is {1,1,1}."
  @param rotation: "Rotation to apply to mesh. Default is {0,0,0}."
  @param texture:  "Texture to draw on mesh, set to null by default"
 *>
fn void Mesh.draw_2d(&self, Vector2 position = {}, Vector2 scale = {1,1}, float rotation = 0, Texture* texture = null) {
  if (self.shader.id != 0) {
    self.shader.use();
  } else {
    ennoia::defaultShader2d.use();
  }

  //ennoia::default_shader_2d.set_mat4x4("model", matrix::IDENTITY.translate({position.x, position.y, 0}).rotate({0,0,rotation}).scale({scale.x, scale.y, 1}));
  ennoia::defaultShader2d.set_vec2("position", position);
  ennoia::defaultShader2d.set_vec2("scale", scale);

  if (texture != null) {
    gl::bind_texture(gl::TEXTURE_2D, texture.id);
  } else {
    if (self.texture != null) {
      gl::bind_texture(gl::TEXTURE_2D, self.texture.id);
    } else {
      gl::bind_texture(gl::TEXTURE_2D, 0);
    }
  }

  gl::bind_vertex_array(self.vao);
  gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len);
}

<* Prints info on vertex *>
fn void Vertex.print(&self) {
  io::printfn("Position: [%f,%f,%f]\nNormals: [%f,%f,%f]\nTexCoords: [%f,%f]\n",
    self.position.x, self.position.y, self.position.z,
    self.normal.x, self.normal.y, self.normal.z,
    self.texCoords.x, self.texCoords.y,
  );
}

