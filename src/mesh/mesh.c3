
module ennoia::mesh;
import std::io;
import std::collections;
import ennoia;
import gl;


struct Mesh {
  Vertex[] vertices;
  Indices[] indices;

  uint vao, vbo, ebo;

  Shader shader;
  String materialName;
  Texture* texture;
}

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


<* Loads Mesh from data
  @param data: "Data to make into mesh"
  @require data.len > 0
 *>
fn HashMap{String, Mesh} load_from_mem(String data) @export("mesh_loadfrommem") {
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

<* Cleans up mesh data *>
fn void Mesh.clean(&self) @export("mesh_cleanmesh") {
  self.delete();
  free(self.vertices);
  free(self.indices);
  
  if (self.texture != null) {
    self.texture.clean();
    free(self.texture);
  }
  
  self.shader.clean();
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

<* Draws Mesh
  @param position: "Position in space to draw mesh. Default is {0,0,0}."
  @param scale:    "Scale to draw mesh at. Default is {1,1,1}."
  @param rotation: "Rotation to apply to mesh. Default is {0,0,0}."
  @param texture:  "Texture to draw on mesh, set to null by default"
 *>
fn void Mesh.draw(&self, Vector3 position = {}, Vector3 scale = {1,1,1}, Vector3 rotation = {}, Texture* texture = null) @export("mesh_draw") {
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
fn void Mesh.draw_instanced(&self, Matrix[] mats, Texture* texture = null) {
  // Use default shader if the mesh doesn't have one
  ((self.shader.id != 0) ? self.shader.use() : ennoia::defaultShader3d.use());

  // Set Camera uniform
  ennoia::defaultShader3d.set_mat4x4("view", camera::get_matrix());

  // Check what textures are available and uses the highest priority.
  int textureID = ((texture != null) ? texture.id : ((self.texture != null) ? self.texture.id : 0));
  gl::bind_texture(gl::TEXTURE_2D, textureID);

  gl::bind_vertex_array(self.vao);

  for (int i; i < mats.len; i++) {
    // Set model position
    ennoia::defaultShader3d.set_mat4x4("model", mats[i]);
    
    if (self.ebo != 0) {
	    gl::draw_elements(gl::TRIANGLES, self.indices.len * 3, gl::UNSIGNED_INT, null);
	  } else {
	    gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len);
	  }
  }
}
<* Draws Mesh in 2d space
  @param position: "Position in space to draw mesh. Default is {0,0,0}."
  @param scale:    "Scale to draw mesh at. Default is {1,1,1}."
  @param rotation: "Rotation to apply to mesh. Default is {0,0,0}."
  @param texture:  "Texture to draw on mesh, set to null by default"
 *>
fn void Mesh.draw_2d(&self, Vector2 position = {}, Vector2 scale = {1,1}, float rotation = 0, Texture* texture = null) @export("mesh_draw2d") {
  // Use default shader if the mesh doesn't have one
  ((self.shader.id != 0) ? self.shader.use() : ennoia::defaultShader2d.use());

  // Set uniforms
  ennoia::defaultShader2d.set_vec2("position", position);
  ennoia::defaultShader2d.set_vec2("scale", scale);
  ennoia::defaultShader2d.set_vec2("texOffset", {0,0});
  ennoia::defaultShader2d.set_vec2("texScale",  {1,1});

  // Check what textures are available and uses the highest priority.
  int textureID = ((texture != null) ? texture.id : ((self.texture != null) ? self.texture.id : 0));
  gl::bind_texture(gl::TEXTURE_2D, textureID);

  gl::disable(gl::DEPTH_TEST);
  gl::bind_vertex_array(self.vao);
  gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len);
  gl::enable(gl::DEPTH_TEST);
}
<* Draws Mesh in 2D space multiple times with different matrices
//  @param 
  @require position.len == scale.len
 *>
//fn void Mesh.draw_2d_instanced(&self, Vector2[] position, Vector2[] scale, Vector2[6][] texcoord, Texture* texture) {
fn void Mesh.draw_2d_instanced(&self, Vector2[] position, Vector2[] scale, Vector4[] texcoord, Color[] tint, Texture* texture) {
  // Use default shader if the mesh doesn't have one
  ((self.shader.id != 0) ? self.shader.use() : ennoia::defaultShader2d.use());

  gl::disable(gl::DEPTH_TEST);
  gl::bind_vertex_array(self.vao);
  gl::bind_texture(gl::TEXTURE_2D, texture.id);

  // Loop
  for (int i; i < position.len; i++) {    // Set uniforms
    ennoia::defaultShader2d.set_vec2("position",  position[i]);
    ennoia::defaultShader2d.set_vec2("scale",     scale[i]);
    ennoia::defaultShader2d.set_vec2("texOffset", {texcoord[i].x,(1 - texcoord[i].w) - texcoord[i].y});
    ennoia::defaultShader2d.set_vec2("texScale",  {texcoord[i].z,texcoord[i].w});
    ennoia::defaultShader2d.set_vec4("texColor",  tint[i].normalize());

    gl::draw_arrays(gl::TRIANGLES, 0, self.vertices.len);
  }

  gl::enable(gl::DEPTH_TEST);
}

<* Prints info on vertex *>
fn void Vertex.print(&self) @export("mesh_print") {
  io::printfn("Position: [%f,%f,%f]\nNormals: [%f,%f,%f]\nTexCoords: [%f,%f]\n",
    self.position.x, self.position.y, self.position.z,
    self.normal.x, self.normal.y, self.normal.z,
    self.texCoords.x, self.texCoords.y,
  );
}


