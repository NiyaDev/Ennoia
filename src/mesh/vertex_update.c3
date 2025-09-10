
module ennoia::mesh;
import ennoia::vector;


<* Changes the positions of the mesh and re-uploads it
  @param newPos: "Array of new positions"
  @require newPos.len == self.vertices.len
 *>
fn void Mesh.update_positions(&self, Vector3[] newPos) @export("mesh_updatepositions") {
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
fn void Mesh.update_normals(&self, Vector3[] newNorms) @export("mesh_updatenormals") {
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
fn void Mesh.update_texcoords(&self, Vector2[] newCoords) @export("mesh_updatetexcoords") {
  for (int i; i < newCoords.len; i++) {
    self.vertices[i].texCoords = newCoords[i];
  }

  self.delete();
  self.upload();
}
<* Changes the TexCoords of the mesh and re-uploads it
  @param newColors: "Array of new texCoords"
  @require newColors.len == self.vertices.len
 *>
fn void Mesh.update_colors(&self, Vector4[] newColors) @export("mesh_updatecolors") {
  for (int i; i < newColors.len; i++) {
    self.vertices[i].color = newColors[i];
  }

  self.delete();
  self.upload();
}

