
module ennoia::shader;
import ennoia::gl;
import ennoia::vector;
import ennoia::matrix;
import ennoia::texture;
import std::io;
import std::collections;


struct Shader {
  uint id;
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

const char[] BASIC_VERTEX = 
  "#version 330 core\n"
  "layout (location = 0) in vec3 aPos;\n"
  "layout (location = 1) in vec3 norm;\n"
  "layout (location = 2) in vec2 aTexCoord;\n\n"
  "out vec2 TexCoord;\n\n"
  "uniform mat4 model;\n"
  "uniform mat4 view;\n"
  "uniform mat4 projection;\n\n"
  "void main() {\n"
  "  gl_Position = projection * view * model * vec4(aPos, 1.0f);\n"
  "  TexCoord = vec2(aTexCoord.x, aTexCoord.y);\n"
  "}\n";
const char[] BASIC_FRAGMENT = 
  "#version 330 core\n"
  "out vec4 FragColor;\n\n"
  "in vec2 TexCoord;\n\n"
  "uniform sampler2D texture1;\n\n"
  "void main() {\n"
  "  FragColor = texture(texture1, TexCoord);\n"
  "}\n";

const char[] FB_VERTEX =
  "#version 330 core\n"
  "layout (location = 0) in vec3 aPos;\n"
  "layout (location = 1) in vec3 normals;\n"
  "layout (location = 2) in vec2 aTexCoords;\n\n"
  "out vec2 TexCoords;\n\n"
  "void main() {\n"
  "  TexCoords = vec2(aTexCoords.x, aTexCoords.y);\n"
  "  gl_Position = vec4(aPos.x, aPos.y, 0.0, 1.0);\n"
  "}\n";
const char[] FB_FRAGMENT =
  "#version 330 core\n"
  "out vec4 FragColor;\n\n"
  "in vec2 TexCoords;\n\n"
  "uniform sampler2D texture0;\n\n"
  "void main() {\n"
  "  FragColor = texture(texture0, TexCoords);\n"
  "}\n";



<* Load shader files and compile
  @param vert: "Filename of uncompiled Vertex Shader"
  @param frag: "Filename of uncompiled Fragment Shader"
  @return "Compiled shader structure"
 *>
fn Shader load(String vert, String frag) { 
  char[] vs = file::load_temp(vert)!!;
  char[] fs = file::load_temp(frag)!!;

  return compile(vs, fs);
}
<* Compile shader
  @param vert: "Array containing raw Vertex Shader file"
  @param frag: "Array containing raw Fragment Shader file"
  @return "Compiled shader structure"
 *>
fn Shader compile(char[] vert = {}, char[] frag = {}) {
  int success;
  uint program = gl::create_program();

  // Vertex shader
  uint vertex_shader = gl::create_shader(gl::VERTEX_SHADER);
  if (vert.len > 0) {
    gl::shader_source(vertex_shader, 1, &&((char*)vert), null);
  } else {
    gl::shader_source(vertex_shader, 1, &&((char*)BASIC_VERTEX), null);
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
    gl::shader_source(fragment_shader, 1, &&((char*)BASIC_FRAGMENT), null);
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

  return {program};
}
<* Cleans up shader *>
fn void Shader.clean(&self) {
  gl::delete_program(self.id);
}

<* Sets integer uniform value *>
fn void Shader.set_int(&self, String name, int i) {
  gl::program_uniform_i(self.id, gl::get_uniform_location(self.id, name.zstr_tcopy()), i);
}
<* Sets float uniform value *>
fn void Shader.set_float(&self, String name, float f) {
  gl::program_uniform_f(self.id, gl::get_uniform_location(self.id, name.zstr_tcopy()), f);
}
<* Sets vector2 uniform value *>
fn void Shader.set_vec2(&self, String name, Vector2 v2) {
  gl::program_uniform_2f(self.id, gl::get_uniform_location(self.id, name.zstr_tcopy()), v2.x, v2.y);
}
<* Sets 4x4matrix uniform value *>
fn void Shader.set_mat4x4(&self, String name, Matrix mat) {
  gl::program_uniform_matrix4_fv(
    self.id,
    gl::get_uniform_location(self.id, name.zstr_tcopy()),
    1,
    false,
    (float*)&mat,
  );
}
<**>
fn void Shader.set_sampler2d(&self, String name, Texture texture) {
  gl::program_uniform_i(self.id, gl::get_uniform_location(self.id, name.zstr_tcopy()), texture.id);
}

<* Activates shader *>
fn void Shader.use(&self) {
  gl::use_program(self.id);
}

