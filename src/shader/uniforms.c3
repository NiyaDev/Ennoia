
module ennoia::shader;
import ennoia::matrix;
import ennoia::texture;
import ennoia::vector;
import gl;


<* Sets integer uniform value *>
fn void Shader.set_int(&self, String name, int i) @export("shader_setint") {
  if (self.locs.has_key(name)) {
    gl::program_uniform_i(self.id, self.locs[name]!!, i);
  } else {
    uint loc = gl::get_uniform_location(self.id, name.zstr_tcopy());
    self.locs.set(name, loc);
    gl::program_uniform_i(self.id, loc, i);
  }
}
<* Sets float uniform value *>
fn void Shader.set_float(&self, String name, float f) @export("shader_setfloat") {
  if (self.locs.has_key(name)) {
    gl::program_uniform_f(self.id, self.locs[name]!!, f);
  } else {
    uint loc = gl::get_uniform_location(self.id, name.zstr_tcopy());
    self.locs.set(name, loc);
    gl::program_uniform_f(self.id, loc, f);
  }
}
<* Sets vector2 uniform value *>
fn void Shader.set_vec2(&self, String name, Vector2 v2) @export("shader_setv2") {
  if (self.locs.has_key(name)) {
    gl::program_uniform_2f(self.id, self.locs[name]!!, v2.x, v2.y);
  } else {
    uint loc = gl::get_uniform_location(self.id, name.zstr_tcopy());
    self.locs.set(name, loc);
    gl::program_uniform_2f(self.id, loc, v2.x, v2.y);
  }
}
<* Sets 4x4matrix uniform value *>
fn void Shader.set_mat4x4(&self, String name, Matrix mat) @export("shader_setmat") {
  if (self.locs.has_key(name)) {
    gl::program_uniform_matrix4_fv(self.id, self.locs[name]!!, 1, false, (float*)&mat);
  } else {
    uint loc = gl::get_uniform_location(self.id, name.zstr_tcopy());
    self.locs.set(name, loc);
    gl::program_uniform_matrix4_fv(self.id, loc, 1, false, (float*)&mat);
  }
}
<* Sets Texture uniform value *>
fn void Shader.set_sampler2d(&self, String name, Texture texture) @export("shader_settexture") {
  gl::program_uniform_i(self.id, gl::get_uniform_location(self.id, name.zstr_tcopy()), texture.id);
}


