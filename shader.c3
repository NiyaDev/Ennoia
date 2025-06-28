
module ennoia::shader;
import ennoia::gl;
import std::io;
import std::collections;


struct Shader {
  uint id;
  HashMap{String, int} locs;
}

enum UniformType {
  FLOAT,
  VECTOR2,
  VECTOR3,
  VECTOR4,

  INT,
  IVECTOR2,
  IVECTOR3,
  IVECTOR4,

  UINT,
  UIVECTOR2,
  UIVECTOR3,
  UIVECTOR4,

  FLOATARRAY,
  VECTOR2ARRAY,
  VECTOR3ARRAY,
  VECTOR4ARRAY,

  INTARRAY,
  IVECTOR2ARRAY,
  IVECTOR3ARRAY,
  IVECTOR4ARRAY,

  UINTARRAY,
  UIVECTOR2ARRAY,
  UIVECTOR3ARRAY,
  UIVECTOR4ARRAY,

  MATRIX2X2,
  MATRIX3X3,
  MATRIX4X4,
  MATRIX2X3,
  MATRIX3X2,
  MATRIX2X4,
  MATRIX4X2,
  MATRIX3X4,
  MATRIX4X3,
}

<* Compile a new shader
  @param vert: "Filename of uncompiled Vertex Shader"
  @param frag: "Filename of uncompiled Fragment Shader"
  @return "Compiled shader structure"
 *>
fn Shader load(String vert, String frag) {
  int success;

  // Initialize Program
  uint program = gl::create_program();

  // Vertex Shader
  uint vertex_shader;
  if (vert != "") {
    // Load data
    String vs = (String)file::load_temp(vert)!!;

    // Load Shader
    vertex_shader = gl::create_shader(gl::VERTEX_SHADER);
    gl::shader_source(vertex_shader, 1, &&((char*)vs), null);
    gl::compile_shader(vertex_shader);
    gl::get_shaderiv(vertex_shader, gl::COMPILE_STATUS, &success);
    if (success == 0) {
      char[] log = mem::new_array(char, 512);
		  gl::get_shader_info_log(vertex_shader, 512, null, (char*)log);
		  io::printfn("[ERROR] - ENNOIA::SHADER::VERTEX [%s]", (String)log);
	  	free(log);
    }
    gl::attach_shader(program, vertex_shader);
  }

  // Fragment Shader
  uint fragment_shader;
  if (frag != "") {
    // Load data
    String fs = (String)file::load_temp(frag)!!;

    // Load Shader
    fragment_shader = gl::create_shader(gl::FRAGMENT_SHADER);
    gl::shader_source(fragment_shader, 1, &&((char*)fs), null);
    gl::compile_shader(fragment_shader);
    gl::get_shaderiv(fragment_shader, gl::COMPILE_STATUS, &success);
    if (success == 0) {
      char[] log = mem::new_array(char, 512);
	  	gl::get_shader_info_log(fragment_shader, 512, null, (char*)log);
	  	io::printfn("[ERROR] - ENNOIA::SHADER::FRAGMENT [%s]", (String)log);
	  	free(log);
    }
    gl::attach_shader(program, fragment_shader);
  }

  // Linking program
  gl::link_program(program);
  gl::get_programiv(program, gl::LINK_STATUS, &success);
  if (success == 0) {
    char[] log = mem::new_array(char, 512);
		gl::get_program_info_log(program, 512, null, (char*)log);
		io::printfn("[ERROR] - ENNOIA::SHADER::PROGRAM [%s]",(String)log);
		free(log);
  }

  // Cleanup
  gl::delete_shader(vertex_shader);
	gl::delete_shader(fragment_shader);

  return {program, {}};
}
<* Add uniform location to shader
  @param name: "name of uniform"
  @param type: "Type of variable"
  @param data: "Pointer to data"
 *>
fn void Shader.add_loc(&self, String name, UniformType type, any data) {
  if (self.locs.has_key(name)) {
    io::printfn("[WARNING] - ENNOIA::SHADER::ADD_LOC [Added new location that already existed. Replacing old entry with new one.]");
  }

  int location = gl::get_uniform_location(self.id, name.zstr_tcopy());
  self.locs.set(name, location);

  self.update_loc(name, type, data);
}
<* Update uniform value
  @param name: "name of uniform"
  @param type: "Type of variable"
  @param data: "Pointer to data"
 *>
fn void Shader.update_loc(&self, String name, UniformType type, any data) {
  if (!self.locs.has_key(name)) {
    io::printfn("[WARNING] - ENNOIA::SHADER::UPDATE_LOC [Attempted to update a location that doesn't exist. Adding it as a new one.]");
    self.add_loc(name, type, data);
    return;
  }

  switch (type) {
    case FLOAT: gl::program_uniform_f(self.id, self.locs[name]!!, *((float*)data));
    default: io::printfn("[WARNING] - ENNOIA::SHADER::ADD_LOC [Attempted to edit non-implemented data type (%s)]", type);
  }
}

