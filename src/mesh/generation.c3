
module ennoia::mesh;


<* Creates a new Mesh using input vertices and indices
  @param vertices: "The array of vertices to set"
  @return "Mesh struct"
 *>
fn Mesh new(Vertex[] vertices = {}) @export("mesh_new") {
  return gen_triangle();
}
<* Generates a simple Triangle mesh *>
fn Mesh gen_triangle() @export("mesh_gentri") {
  Mesh output;
  output.vertices = mem::new_array(Vertex, BASIC_TRI.len);

  mem::copy(output.vertices, BASIC_TRI, Vertex.sizeof * BASIC_TRI.len);
  output.upload();

  return output;
}
<* Generates a simple Quad mesh *>
fn Mesh gen_quad() @export("mesh_genquad") {
  Mesh output;
  output.vertices = mem::new_array(Vertex, BASIC_QUAD.len);

  mem::copy(output.vertices, BASIC_QUAD, Vertex.sizeof * BASIC_QUAD.len);
  output.upload();

  return output;
}
<* Generates a simple Cube mesh *>
fn Mesh gen_cube() @export("mesh_gencube") {
  Mesh output;
  output.vertices = mem::new_array(Vertex, BASIC_CUBE.len);

  mem::copy(output.vertices, BASIC_CUBE, Vertex.sizeof * BASIC_CUBE.len);
  output.upload();

  return output;
}

