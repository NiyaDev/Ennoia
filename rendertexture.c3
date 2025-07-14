
module ennoia::render;
import ennoia::texture;
import ennoia::shader;
import ennoia::mesh;
import ennoia::gl;


uint framebuffer;
uint renderbuffer;
Texture renderTexture;
Mesh renderQuad;


<* Initializes the Framebuffer and Renderbuffer *>
fn void init(int width, int height) {
  // Render quad
  renderQuad = mesh::new(
    {
      {{-1, 1, 0}, {}, {0,1}},
      {{-1,-1, 0}, {}, {0,0}},
      {{ 1,-1, 0}, {}, {1,0}},

      {{-1, 1, 0}, {}, {0,1}},
      {{ 1,-1, 0}, {}, {1,0}},
      {{ 1, 1, 0}, {}, {1,1}},
    }
  );
  renderQuad.shader = shader::compile(shader::FB_VERTEX, shader::FB_FRAGMENT);
  renderQuad.shader.set_int("screenTexture", 0);

  // Framebuffer
  gl::gen_framebuffers(1, &framebuffer);
  gl::bind_framebuffer(gl::FRAMEBUFFER, framebuffer);

  // Render Texture
  renderTexture = texture::new(width, height);
  gl::framebuffer_texture_2d(gl::FRAMEBUFFER, gl::COLOR_ATTACHMENT0, gl::TEXTURE_2D, renderTexture.id, 0);

  // Renderbuffer
  gl::gen_renderbuffers(1, &renderbuffer);
  gl::bind_renderbuffer(gl::RENDERBUFFER, renderbuffer);
  gl::renderbuffer_storage(gl::RENDERBUFFER, gl::DEPTH24_STENCIL8, width, height);
  gl::framebuffer_renderbuffer(gl::FRAMEBUFFER, gl::DEPTH_STENCIL_ATTACHMENT, gl::RENDERBUFFER, renderbuffer);
  assert(gl::check_framebuffer_status(gl::FRAMEBUFFER) == gl::FRAMEBUFFER_COMPLETE, "[ERROR] - ENNOIA::RENDERTEXTURE::INIT::CHECK_FRAMEBUFFER_STATUS [Framebuffer failed to initialize]");
  gl::bind_framebuffer(gl::FRAMEBUFFER, 0);
}

<* Replaces old rendershader, cleaning up the old one *>
fn void set_shader(Shader newShader) {
  renderQuad.shader.clean();
  renderQuad.shader = newShader;
}
<* Returns current rendershader *>
fn Shader get_shader() {
  return renderQuad.shader;
}
