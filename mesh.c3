
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
  bool quad;
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
<**>
fn Mesh generate_mesh_test(uint[][] data) {
  Mesh output;

  usz count;
  for (int z; z < data.len; z++) {
    for (int x; x < data[z].len; x++) {
      if (data[z][x] == 1) {
        io::printfn("drawing: %d-%d",x,z);
        count += 5*6;
      }
    }
  }
  output.vertices = mem::new_array(float, count);
  output.mat = matrix::IDENTITY;
  output.quad = true;
  
  count = 0;
  for (int z; z < data.len; z++) {
    for (int x; x < data[z].len; x++) {
      if (data[z][x] == 1) {
        output.vertices[(count * 30) + 0] = (float)x;
        output.vertices[(count * 30) + 1] = 0.0;
        output.vertices[(count * 30) + 2] = (float)z;
        output.vertices[(count * 30) + 3] = 0;
        output.vertices[(count * 30) + 4] = 0;

        output.vertices[(count * 30) + 5] = (float)x + 1;
        output.vertices[(count * 30) + 6] = 0.0;
        output.vertices[(count * 30) + 7] = (float)z;
        output.vertices[(count * 30) + 8] = 0;
        output.vertices[(count * 30) + 9] = 0;

        output.vertices[(count * 30) + 10] = (float)x;
        output.vertices[(count * 30) + 11] = 0.0;
        output.vertices[(count * 30) + 12] = (float)z + 1;
        output.vertices[(count * 30) + 13] = 0;
        output.vertices[(count * 30) + 14] = 0;

        output.vertices[(count * 30) + 15] = (float)x + 1;
        output.vertices[(count * 30) + 16] = 0.0;
        output.vertices[(count * 30) + 17] = (float)z;
        output.vertices[(count * 30) + 18] = 0;
        output.vertices[(count * 30) + 19] = 0;

        output.vertices[(count * 30) + 20] = (float)x;
        output.vertices[(count * 30) + 21] = 0.0;
        output.vertices[(count * 30) + 22] = (float)z + 1;
        output.vertices[(count * 30) + 23] = 0;
        output.vertices[(count * 30) + 24] = 0;

        output.vertices[(count * 30) + 25] = (float)x + 1;
        output.vertices[(count * 30) + 26] = 0.0;
        output.vertices[(count * 30) + 27] = (float)z + 1;
        output.vertices[(count * 30) + 28] = 0;
        output.vertices[(count * 30) + 29] = 0;
        count++;
      }
    }
  }

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
<* Deletes trio from gpu *>
fn void Mesh.delete(&self, Trio trio) {
  gl::delete_vertex_arrays(1, &trio.vao);
  gl::delete_buffers(1, &trio.vbo);
}

<* Draws Mesh
  @param self
  @param tex: "Texture to draw on mesh, set to null by default"
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
	//gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len / 5);
	gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len / 5);

	self.delete(trio);
}
<* Draws mesh using matrix override
  @param self
  @param over: "Matrix used as an override to meshes inbuilt"
  @param tex: "Texture to draw on mesh, set to null by default"
 *>
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


