
module ennoia::shader;
import ennoia::vector;
import ennoia::matrix;
import ennoia::texture;
import std::io;
import std::collections;
import gl;


struct Shader {
  uint id;
  HashMap{String,uint} locs;
}


<* Load shader files and compile
  @param vert: "Filename of uncompiled Vertex Shader"
  @param frag: "Filename of uncompiled Fragment Shader"
  @return "Compiled shader structure"
 *>
fn Shader load(String vert, String frag) @export("shader_load") { 
  char[] vs = file::load_temp(vert)!!;
  char[] fs = file::load_temp(frag)!!;

  return compile(vs, fs);
}
<* Compile shader
  @param vert: "Array containing raw Vertex Shader file"
  @param frag: "Array containing raw Fragment Shader file"
  @return "Compiled shader structure"
 *>
fn Shader compile(char[] vert = {}, char[] frag = {}) @export("shader_compile") {
  int success;
  uint program = gl::create_program();

  // Vertex shader
  uint vertex_shader = gl::create_shader(gl::VERTEX_SHADER);
  if (vert.len > 0) {
    gl::shader_source(vertex_shader, 1, &&((char*)vert), null);
  } else {
    gl::shader_source(vertex_shader, 1, &&((char*)FB_VERTEX), null);
  }
  gl::compile_shader(vertex_shader);
  gl::get_shaderiv(vertex_shader, gl::COMPILE_STATUS, &success);
  if (success == 0) {
    char[] log = mem::new_array(char, 512);
	  gl::get_shader_info_log(vertex_shader, 512, null, (char*)log);
	  io::printfn("[ERROR] - ENNOIA::SHADER::VERTEX [%s]", (String)log);
		free(log);
  }
  gl::attach_shader(program, vertex_shader);

  // Fragment Shader
  uint fragment_shader = gl::create_shader(gl::FRAGMENT_SHADER);
  if (frag.len > 0) {
    gl::shader_source(fragment_shader, 1, &&((char*)frag), null);
  } else {
    gl::shader_source(fragment_shader, 1, &&((char*)FB_FRAGMENT), null);
  }
  gl::compile_shader(fragment_shader);
  gl::get_shaderiv(fragment_shader, gl::COMPILE_STATUS, &success);
  if (success == 0) {
    char[] log = mem::new_array(char, 512);
		gl::get_shader_info_log(fragment_shader, 512, null, (char*)log);
		io::printfn("[ERROR] - ENNOIA::SHADER::FRAGMENT [%s]", (String)log);
		free(log);
  }
  gl::attach_shader(program, fragment_shader);

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

  return {program,{}};
}
<* Cleans up shader *>
fn void Shader.clean(&self) @export("shader_clean") {
  gl::delete_program(self.id);
  self.locs.free();
}
<* Activates shader *>
fn void Shader.use(&self) @export("shader_use") {
  gl::use_program(self.id);
}


