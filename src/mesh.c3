
module ennoia::mesh;
import std::io;
import std::collections;
import ennoia;


struct Mesh {
  Vertex[] vertices;
  Indices[] indices;

  uint vao, vbo, ebo;

  Shader shader;
  String materialName;
  Texture* texture;
}
alias Model = HashMap{String, Mesh};

struct Vertex {
  Vector3 position;
  Vector3 normal;
  Vector2 texCoords;
  Vector4 color;
  //Vector4 tangents;
  //Vector2 texCoords2;
}
alias Indices = uint[3];

const void* VERTEX_POSITION = null;
const void* VERTEX_NORMAL   = (void*)(Vector3.sizeof);
const void* VERTEX_TEXCOORD = (void*)((long)VERTEX_NORMAL * 2);
const void* VERTEX_COLOR    = (void*)((long)VERTEX_TEXCOORD + Vector2.sizeof);

const Vertex[] BASIC_TRI = {
  {{ 0.0,  0.5, 0.0}, {0,0,1}, {1,1}, {0,0,0,1}},
  {{-0.5, -0.5, 0.0}, {0,0,1}, {1,0}, {0,0,0,1}},
  {{ 0.5, -0.5, 0.0}, {0,0,1}, {0,1}, {0,0,0,1}},
};
const Vertex[] BASIC_QUAD = {
  {{-1, 1, 0}, {}, {0,1}, {0,0,0,0}},
  {{-1,-1, 0}, {}, {0,0}, {0,0,0,0}},
  {{ 1,-1, 0}, {}, {1,0}, {0,0,0,0}},

  {{-1, 1, 0}, {}, {0,1}, {0,0,0,0}},
  {{ 1,-1, 0}, {}, {1,0}, {0,0,0,0}},
  {{ 1, 1, 0}, {}, {1,1}, {0,0,0,0}},
};
const Vertex[] BASIC_CUBE = {
  // Back
  {{-0.5, -0.5, -0.5},{0,0,1},{0,0},{0,0,0,1}},
  {{ 0.5, -0.5, -0.5},{0,0,1},{1,0},{0,0,0,1}},
  {{ 0.5,  0.5, -0.5},{0,0,1},{1,1},{0,0,0,1}},
  {{ 0.5,  0.5, -0.5},{0,0,1},{1,1},{0,0,0,1}},
  {{-0.5,  0.5, -0.5},{0,0,1},{0,1},{0,0,0,1}},
  {{-0.5, -0.5, -0.5},{0,0,1},{0,0},{0,0,0,1}},
  // Front
  {{-0.5, -0.5,  0.5},{0,0,1},{0,0},{0,0,0,1}},
  {{ 0.5, -0.5,  0.5},{0,0,1},{1,0},{0,0,0,1}},
  {{ 0.5,  0.5,  0.5},{0,0,1},{1,1},{0,0,0,1}},
  {{ 0.5,  0.5,  0.5},{0,0,1},{1,1},{0,0,0,1}},
  {{-0.5,  0.5,  0.5},{0,0,1},{0,1},{0,0,0,1}},
  {{-0.5, -0.5,  0.5},{0,0,1},{0,0},{0,0,0,1}},
  // Left
  {{-0.5,  0.5,  0.5},{0,0,1},{1,0},{0,0,0,1}},
  {{-0.5,  0.5, -0.5},{0,0,1},{1,1},{0,0,0,1}},
  {{-0.5, -0.5, -0.5},{0,0,1},{0,1},{0,0,0,1}},
  {{-0.5, -0.5, -0.5},{0,0,1},{0,1},{0,0,0,1}},
  {{-0.5, -0.5,  0.5},{0,0,1},{0,0},{0,0,0,1}},
  {{-0.5,  0.5,  0.5},{0,0,1},{1,0},{0,0,0,1}},
  // Right
  {{ 0.5,  0.5,  0.5},{0,0,1},{1,0},{0,0,0,1}},
  {{ 0.5,  0.5, -0.5},{0,0,1},{1,1},{0,0,0,1}},
  {{ 0.5, -0.5, -0.5},{0,0,1},{0,1},{0,0,0,1}},
  {{ 0.5, -0.5, -0.5},{0,0,1},{0,1},{0,0,0,1}},
  {{ 0.5, -0.5,  0.5},{0,0,1},{0,0},{0,0,0,1}},
  {{ 0.5,  0.5,  0.5},{0,0,1},{1,0},{0,0,0,1}},
  // Bottom
  {{-0.5, -0.5, -0.5},{0,0,1},{0,1},{0,0,0,1}},
  {{ 0.5, -0.5, -0.5},{0,0,1},{1,1},{0,0,0,1}},
  {{ 0.5, -0.5,  0.5},{0,0,1},{1,0},{0,0,0,1}},
  {{ 0.5, -0.5,  0.5},{0,0,1},{1,0},{0,0,0,1}},
  {{-0.5, -0.5,  0.5},{0,0,1},{0,0},{0,0,0,1}},
  {{-0.5, -0.5, -0.5},{0,0,1},{0,1},{0,0,0,1}},
  // Top
  {{-0.5,  0.5, -0.5},{0,0,1},{0,1},{0,0,0,1}},
  {{ 0.5,  0.5, -0.5},{0,0,1},{1,1},{0,0,0,1}},
  {{ 0.5,  0.5,  0.5},{0,0,1},{1,0},{0,0,0,1}},
  {{ 0.5,  0.5,  0.5},{0,0,1},{1,0},{0,0,0,1}},
  {{-0.5,  0.5,  0.5},{0,0,1},{0,0},{0,0,0,1}},
  {{-0.5,  0.5, -0.5},{0,0,1},{0,1},{0,0,0,1}},
};


<* Loads Mesh from .obj file
  @param filename: "Name of .obj file to load"
  @require filename != ""
 *>
fn Model load(String filename, bool getMaterial = true) {
  Model output;
  String data = (String)file::load_temp(filename)!!;
  String[] mtl;

  // Create base directory path
  String[] pathSplit = filename.tsplit("/");
  String dir = filename.trim(pathSplit[pathSplit.len-1]);

  if (getMaterial) {
    // Get material name and load file
    String[] split = data.tsplit("\n");
    for (int i; i < split.len; i++) {
      String[] splitTwo = split[i].tsplit(" ");
      if (splitTwo[0] == "mtllib") {
        String path = string::tformat("%s%s",dir,splitTwo[1]);
        mtl = ((String)file::load_temp(path)!!).tsplit("\n");
        break;
      }
    }
    
    // Load Mesh
    output = load_from_mem(data);

    // Iterate through material file to find material and load data
    output.@each(; String key, Mesh val) {
      bool myMat = false;
      for (int i; i < mtl.len; i++) {
        String[] line = mtl[i].tsplit(" ");
        switch (line[0]) {
          case "newmtl": // Material definition
            if (line[1] == val.materialName) {
              myMat = true;
            } else { myMat = false; }
          case "map_Kd": // Texture name
            if (myMat) {
              String texturePath = string::tformat("%s%s", dir, line[1]);
              Mesh* temp = output.get_ref(key)!!;
              temp.texture = mem::new(Texture);
              *temp.texture = texture::load(texturePath);
            }
        }
      }
    };
  } else {
    output = load_from_mem(data);
  }

  return output;
}
<* Loads Mesh from data
  @param data: "Data to make into mesh"
  @require data.len > 0
 *>
fn HashMap{String, Mesh} load_from_mem(String data) {
  HashMap{String, Mesh} list;
  String[] lines = data.tsplit("\n");

  String lastMember = "";
  usz lastVertexPos, lastVertexNor, lastVertexTex, lastIndices;
  usz  maxVertexPos,  maxVertexNor,  maxVertexTex;
  String materialName;
  List{Vertex} vertices;
  List{Indices} indices;

  for (int i; i < lines.len; i++) {
    String[] line = lines[i].tsplit(" ");
    switch (line[0]) {
      case "#": continue;
      case "mtllib": // Material file
        break;
      case "usemtl": // Material info
        Mesh* temp = list.get_ref(lastMember)!!;
        temp.materialName = line[1];
      case "o":  // Object
        // If this isn't the first object, save vertices
        if (list.len() > 0) {
          Mesh* temp = list.get_ref(lastMember)!!;
          temp.vertices = vertices.to_array(mem);
          vertices.free();
          maxVertexPos += lastVertexPos;
          maxVertexNor += lastVertexNor;
          maxVertexTex += lastVertexTex;
          lastVertexPos = 0;
          lastVertexNor = 0;
          lastVertexTex = 0;
          temp.indices = indices.to_array(mem);
          indices.free();
          lastIndices = 0;
          //temp.textures = mem::new_array(Texture*, 1);
          temp.upload();
        }
        // Create new mesh
        Mesh newMesh;
        list.set(line[1],newMesh);
        lastMember = line[1];
      case "v":  // Vertex
        if (vertices.len() <= lastVertexPos) vertices.push({{},{},{0,1},{0,0,0,1}});

        float x = line[1].to_float()!!;
        float y = line[2].to_float()!!;
        float z = line[3].to_float()!!;
        vertices[lastVertexPos].position = (Vector3){x,y,z};
        lastVertexPos++;
      case "vn": // Normal
        if (vertices.len() <= lastVertexNor) vertices.push({{},{},{0,1},{0,0,0,1}});

        float x = line[1].to_float()!!;
        float y = line[2].to_float()!!;
        float z = line[3].to_float()!!;
        vertices[lastVertexNor].normal = (Vector3){x,y,z};
        lastVertexNor++;
      case "vt": // TextureCoord
        if (vertices.len() <= lastVertexTex) vertices.push({{},{},{0,1},{0,0,0,1}});

        float x = line[1].to_float()!!;
        float y = line[2].to_float()!!;
        vertices[lastVertexTex].texCoords = (Vector2){x,y};
        lastVertexTex++;
      case "f": // Indices
        if (indices.len() <= lastIndices) indices.push({});
        String[] anotherSplit1 = line[1].tsplit("/");
        String[] anotherSplit2 = line[2].tsplit("/");
        String[] anotherSplit3 = line[3].tsplit("/");
        int x = anotherSplit1[0].to_int()!! - (int)maxVertexPos - 1;
        int y = anotherSplit2[0].to_int()!! - (int)maxVertexPos - 1;
        int z = anotherSplit3[0].to_int()!! - (int)maxVertexPos - 1;

        indices[lastIndices] = {x,y,z};
        lastIndices++;
    }
  }
  Mesh* temp = list.get_ref(lastMember)!!;
  temp.vertices = vertices.to_array(mem);
  vertices.free();
  temp.indices = indices.to_array(mem);
  indices.free();
  temp.upload();

  return list;
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
  Mesh output;
  output.vertices = mem::new_array(Vertex, BASIC_TRI.len);

  mem::copy(output.vertices, BASIC_TRI, Vertex.sizeof * BASIC_TRI.len);
  output.upload();

  return output;
}
<* Generates a simple Quad mesh *>
fn Mesh gen_quad() {
  Mesh output;
  output.vertices = mem::new_array(Vertex, BASIC_QUAD.len);

  mem::copy(output.vertices, BASIC_QUAD, Vertex.sizeof * BASIC_QUAD.len);
  output.upload();

  return output;
}
<* Generates a simple Cube mesh *>
fn Mesh gen_cube() {
  Mesh output;
  output.vertices = mem::new_array(Vertex, BASIC_CUBE.len);

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
        vert_list.push({{(float)x  ,0,(float)z  }, {0,1,0}, {0,0}, {0,0,0,1}});
        vert_list.push({{(float)x+1,0,(float)z  }, {0,1,0}, {0,0}, {0,0,0,1}});
        vert_list.push({{(float)x  ,0,(float)z+1}, {0,1,0}, {0,0}, {0,0,0,1}});
        vert_list.push({{(float)x+1,0,(float)z  }, {0,1,0}, {0,0}, {0,0,0,1}});
        vert_list.push({{(float)x  ,0,(float)z+1}, {0,1,0}, {0,0}, {0,0,0,1}});
        vert_list.push({{(float)x+1,0,(float)z+1}, {0,1,0}, {0,0}, {0,0,0,1}});
      }
    }
  }
  output.vertices = vert_list.to_array(mem);
  vert_list.free();
  output.upload();

  return output;
}
<* Cleans up mesh data *>
fn void Mesh.clean(&self) {
  self.delete();
  free(self.vertices);
  free(self.indices);
  
  if (self.texture != null) {
    self.texture.clean();
    free(self.texture);
  }
  
  self.shader.clean();
}
<* Cleans up model data *>
fn void Model.clean(&self) {
  self.@each(; String key, Mesh val) {
    Mesh* temp = self.get_ref(key)!!;
    temp.clean();
  };
  self.free();
}

<* Uploads mesh data to GPU *>
fn void Mesh.upload(&self) {
  gl::gen_vertex_arrays(1, &self.vao);
  gl::gen_buffers(1, &self.vbo);
  
  gl::bind_vertex_array(self.vao);

  gl::bind_buffer(gl::ARRAY_BUFFER, self.vbo);
  gl::buffer_data(gl::ARRAY_BUFFER, self.vertices.len * Vertex.sizeof, self.vertices, gl::STATIC_DRAW);

  if (self.indices.len > 0) {
    gl::gen_buffers(1, &self.ebo);
    gl::bind_buffer(gl::ELEMENT_ARRAY_BUFFER, self.ebo);
    gl::buffer_data(gl::ELEMENT_ARRAY_BUFFER, self.indices.len * Indices.sizeof, self.indices, gl::STATIC_DRAW);
  }

  ennoia::set_vertex_attribute(0, 3, VERTEX_POSITION);
  ennoia::set_vertex_attribute(1, 3, VERTEX_NORMAL);
  ennoia::set_vertex_attribute(2, 2, VERTEX_TEXCOORD);
  ennoia::set_vertex_attribute(3, 4, VERTEX_COLOR);

  gl::bind_buffer(gl::ARRAY_BUFFER, 0);
  gl::bind_vertex_array(0);
}
<* Deletes trio from gpu *>
fn void Mesh.delete(&self) {
  gl::delete_vertex_arrays(1, &self.vao);
  gl::delete_buffers(1, &self.vbo);
  gl::delete_buffers(1, &self.ebo);
}

<* Changes the positions of the mesh and re-uploads it
  @param newPos: "Array of new positions"
  @require newPos.len == self.vertices.len
 *>
fn void Mesh.update_positions(&self, Vector3[] newPos) {
  for (int i; i < newPos.len; i++) {
    self.vertices[i].position = newPos[i];
  }

  self.delete();
  self.upload();
}
<* Changes the normals of the mesh and re-uploads it
  @param newNorms: "Array of new normals"
  @require newNorms.len == self.vertices.len
 *>
fn void Mesh.update_normals(&self, Vector3[] newNorms) {
  for (int i; i < newNorms.len; i++) {
    self.vertices[i].normal = newNorms[i];
  }

  self.delete();
  self.upload();
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
<* Changes the TexCoords of the mesh and re-uploads it
  @param newColor: "Array of new texCoords"
  @require newColor.len == self.vertices.len
 *>
fn void Mesh.update_color(&self, Vector4[] newColor) {
  for (int i; i < newColor.len; i++) {
    self.vertices[i].color = newColor[i];
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
  // Use default shader if the mesh doesn't have one
  ((self.shader.id != 0) ? self.shader.use() : ennoia::defaultShader3d.use());

  // Set uniforms
  ennoia::defaultShader3d.set_mat4x4("view", camera::get_matrix());
  ennoia::defaultShader3d.set_mat4x4("model", matrix::IDENTITY.translate(position).rotate(rotation).scale(scale));
  
  // Check what textures are available and uses the highest priority.
  int textureID = ((texture != null) ? texture.id : ((self.texture != null) ? self.texture.id : 0));
  gl::bind_texture(gl::TEXTURE_2D, textureID);

	gl::bind_vertex_array(self.vao);

	if (self.ebo != 0) {
	  gl::draw_elements(gl::TRIANGLES, self.indices.len * 3, gl::UNSIGNED_INT, null);
	} else {
	  gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len);
	}
}
<* Draws Mesh multiple times with different matrices
  @param mats: "Array of Matrixes defining the location of each mesh instance"
 *>
fn void Mesh.draw_instanced(&self, Matrix[] mats) {
  // Use default shader if the mesh doesn't have one
  ((self.shader.id != 0) ? self.shader.use() : ennoia::defaultShader3d.use());

  // Set Camera uniform
  ennoia::defaultShader3d.set_mat4x4("view", camera::get_matrix());

  // Check what textures are available and uses the highest priority.
  int textureID = ((self.texture != null) ? self.texture.id : 0);
  gl::bind_texture(gl::TEXTURE_2D, textureID);

  gl::bind_vertex_array(self.vao);

  for (int i; i < mats.len; i++) {
    // Set model position'
    ennoia::defaultShader3d.set_mat4x4("model", mats[i]);
    
    if (self.ebo != 0) {
	    gl::draw_elements(gl::TRIANGLES, self.indices.len * 3, gl::UNSIGNED_INT, null);
	  } else {
	    gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len);
	  }
  }
}
<* Draws Mesh in 2d space3
  @param position: "Position in space to draw mesh. Default is {0,0,0}."
  @param scale:    "Scale to draw mesh at. Default is {1,1,1}."
  @param rotation: "Rotation to apply to mesh. Default is {0,0,0}."
  @param texture:  "Texture to draw on mesh, set to null by default"
 *>
fn void Mesh.draw_2d(&self, Vector2 position = {}, Vector2 scale = {1,1}, float rotation = 0, Texture* texture = null) {
  // Use default shader if the mesh doesn't have one
  ((self.shader.id != 0) ? self.shader.use() : ennoia::defaultShader2d.use());

  // Set uniforms
  ennoia::defaultShader2d.set_vec2("position", position);
  ennoia::defaultShader2d.set_vec2("scale", scale);

  // Check what textures are available and uses the highest priority.
  int textureID = ((texture != null) ? texture.id : ((self.texture != null) ? self.texture.id : 0));
  gl::bind_texture(gl::TEXTURE_2D, textureID);

  gl::disable(gl::DEPTH_TEST);
  gl::bind_vertex_array(self.vao);
  gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len);
  gl::enable(gl::DEPTH_TEST);
}

<* Create Model from single mesh *>
fn Model Mesh.to_model(&self) {
  Model output;
  output.set("mesh_1", *self);

  return output;
}

<* Draws all contained meshes
  @param position: "Position in space to draw meshes. Default is {0,0,0}."
  @param scale:    "Scale to draw meshes at. Default is {1,1,1}."
  @param rotation: "Rotation to apply to meshes. Default is {0,0,0}."
 *>
fn void Model.draw(&self, Vector3 position = {}, Vector3 scale = {1,1,1}, Vector3 rotation = {}, Texture* texture = null) {
  self.@each(; String key, Mesh val) {
    val.draw(position, scale, rotation, (texture != null) ? texture : null);
  };
}
<* Draws all contained meshes multiple times
  @param mats: "Array of Matrixes defining the location of each mesh instance"
 *>
fn void Model.draw_instanced(&self, Matrix[] mats) {
  self.@each(; String key, Mesh val) {
    val.draw_instanced(mats);
  };
}

<* Prints info on vertex *>
fn void Vertex.print(&self) {
  io::printfn("Position: [%f,%f,%f]\nNormals: [%f,%f,%f]\nTexCoords: [%f,%f]\n",
    self.position.x, self.position.y, self.position.z,
    self.normal.x, self.normal.y, self.normal.z,
    self.texCoords.x, self.texCoords.y,
  );
}


