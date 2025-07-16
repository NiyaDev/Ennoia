
module ennoia::gl;


// OpenGL
const DEPTH_BUFFER_BIT = 0x00000100;
const COLOR_BUFFER_BIT = 0x00004000;

const G_2D       = 0x00000600;
const G_3D       = 0x00000601;
const G_3D_COLOR = 0x00000602;
const G_3D_COLOR_TEXTURE = 0x00000603;

const COMPILE_STATUS = 0x00008B81;

const FOCUSED   = 0x00020001; // Input focus
const ICONIFIED = 0x00020002; // Window iconification
const RESIZABLE = 0x00020003; 
const VISIBLE = 0x00020004; 
const DECORATED = 0x00020005; 
const AUTO_ICONIFY = 0x00020006; 
const FLOATING = 0x00020007; 
const MAXIMIZED = 0x00020008; 
const CENTER_CURSOR = 0x00020009; 
const TRANSPARENT_FRAMEBUFFER = 0x0002000A; 
const HOVERED = 0x0002000B; 
const FOCUS_ON_SHOW = 0x0002000C; 
const MOUSE_PASSTHROUGH = 0x0002000D; 
const POSITION_X = 0x0002000E; 
const POSITION_Y = 0x0002000F; 
const RED_BITS = 0x00021001; 
const GREEN_BITS = 0x00021002; 
const BLUE_BITS = 0x00021003; 
const ALPHA_BITS = 0x00021004; 
const DEPTH_BITS = 0x00021005; 
const STENCIL_BITS = 0x00021006; 
const ACCUM_RED_BITS = 0x00021007; 
const ACCUM_GREEN_BITS = 0x00021008; 
const ACCUM_BLUE_BITS = 0x00021009; 
const ACCUM_ALPHA_BITS = 0x0002100A; 
const AUX_BUFFERS = 0x0002100B; 
const STEREO = 0x0002100C; 
const SAMPLES = 0x0002100D; 
const SRGB_CAPABLE = 0x0002100E; 
const REFRESH_RATE = 0x0002100F; 
const DOUBLEBUFFER = 0x00021010; 
const CLIENT_API = 0x00022001; 
const CONTEXT_VERSION_MAJOR = 0x00022002; 
const CONTEXT_VERSION_MINOR = 0x00022003; 
const CONTEXT_REVISION = 0x00022004; 
const CONTEXT_ROBUSTNESS = 0x00022005; 
const OPENGL_FORWARD_COMPAT = 0x00022006; 
const CONTEXT_DEBUG = 0x00022007; 
const OPENGL_PROFILE = 0x00022008;

const OPENGL_CORE_PROFILE = 0x00032001;

const ARRAY_BUFFER    = 0x00008892;
const ELEMENT_ARRAY_BUFFER = 0x00008893;

const STATIC_DRAW     = 0x000088E4;
const FRAGMENT_SHADER = 0x00008B30;
const VERTEX_SHADER   = 0x00008B31;
const LINK_STATUS     = 0x00008B82;

const TRIANGLES = 0x00000004;
const QUADS = 0x00000007;
const TRIANGLES_ADJACENCY = 0x0000000C;
const UNSIGNED_BYTE = 0x00001401;
const UNSIGNED_INT = 0x00001405;
const FLOAT = 0x00001406;

const TEXTURE_WRAP_S = 0x00002802;
const TEXTURE_2D = 0x00000DE1;
const MIRRORED_REPEAT = 0x00008370;
const TEXTURE_MAX_ANISOTROPY_EXT = 0x000084FE;
const RGB  = 0x00001907;
const RGBA = 0x00001908;
const TEXTURE_MAG_FILTER = 0x00002800;
const TEXTURE_MIN_FILTER = 0x00002801;

const NEAREST = 0x00002600;
const LINEAR  = 0x00002601;

const DEPTH_TEST = 0x0000B71;

const FRAMEBUFFER	= 0x00008D40;
const COLOR_ATTACHMENT0	=	0x00008CE0;
const DEPTH_ATTACHMENT = 0x00008D00;
const DEPTH_COMPONENT = 0x00001902;
const RENDERBUFFER = 0x00008D41;
const FRAMEBUFFER_COMPLETE = 0x00008CD5;
const DEPTH24_STENCIL8 = 0x000088F0;
const DEPTH_STENCIL_ATTACHMENT = 0x0000821A;
const TEXTURE0 = 0x000084C0;
const CULL_FACE = 0x00000B44;


extern fn void clear_color(float, float, float, float) @extern("glClearColor");
extern fn void clear(int) @extern("glClear");
extern fn void enable(int) @extern("glEnable");
extern fn void disable(int) @extern("glDisable");
extern fn int get_error() @extern("glGetError");

// Framebuffer drawing
extern fn void gen_framebuffers(int size, uint* ids) @extern("glGenFramebuffers");
extern fn void bind_framebuffer(int target, uint framebuffer) @extern("glBindFramebuffer");
extern fn void draw_buffers(int n, int* buffs) @extern("glDrawBuffers");
extern fn void framebuffer_texture(int target, int attachment, uint texture, int level) @extern("glFramebufferTexture");
extern fn void framebuffer_texture_2d(int target, int attachment, int textarget, uint texture, int level) @extern("glFramebufferTexture2D");
extern fn void framebuffer_renderbuffer(int target, int attachment, int renderbufferTarget, uint renderbuffer) @extern("glFramebufferRenderbuffer");
extern fn void gen_renderbuffers(int n, uint* renderbuffers) @extern("glGenRenderbuffers");
extern fn void bind_renderbuffer(int target, uint renderbuffer) @extern("glBindRenderbuffer");
extern fn void renderbuffer_storage(int target, int internalformat, int width, int height) @extern("glRenderbufferStorage");
extern fn int  check_framebuffer_status(int target) @extern("glCheckFramebufferStatus"); 
extern fn void active_texture(int texture) @extern("glActiveTexture");
extern fn void read_pixels(int x, int y, int width, int height, int format, int type, void* data) @extern("glReadPixels");
extern fn void delete_renderbuffers(int size, uint* renderbuffers) @extern("glDeleteRenderbuffers");
extern fn void delete_framebuffers(int size, uint* framebuffers) @extern("glDeleteFramebuffers");

extern fn void gen_buffers(uint, uint*) @extern("glGenBuffers");
extern fn void bind_buffer(int, uint) @extern("glBindBuffer");
extern fn void buffer_data(int, uint, void*, int) @extern("glBufferData");
extern fn uint create_shader(int) @extern("glCreateShader");
extern fn void shader_source(uint, int, char**, int*) @extern("glShaderSource");
extern fn void compile_shader(uint) @extern("glCompileShader");
extern fn void get_shaderiv(uint, int, int*) @extern("glGetShaderiv");
extern fn void get_shader_info_log(uint, usz, usz*, char*) @extern("glGetShaderInfoLog");
extern fn uint create_program() @extern("glCreateProgram");
extern fn void attach_shader(uint, uint) @extern("glAttachShader");
extern fn void link_program(uint) @extern("glLinkProgram");
extern fn void use_program(uint) @extern("glUseProgram");
extern fn void get_programiv(uint, int, int*) @extern("glGetProgramiv");
extern fn void get_program_info_log(uint, usz, usz*, char*) @extern("glGetProgramInfoLog");
extern fn void delete_shader(uint) @extern("glDeleteShader");
extern fn void delete_program(uint) @extern("glDeleteProgram");
extern fn int get_uniform_location(uint, char*) @extern("glGetUniformLocation");
extern fn void program_uniform_i(uint program, int location, int v0) @extern("glProgramUniform1i");
extern fn void program_uniform_f(uint, int, float) @extern("glProgramUniform1f");
extern fn void program_uniform_2f(uint, int, float, float) @extern("glProgramUniform2f");
extern fn void program_uniform_matrix4_fv(uint, int, int, bool, float*) @extern("glProgramUniformMatrix4fv");
extern fn void delete_vertex_arrays(int, uint*) @extern("glDeleteVertexArrays");
extern fn void delete_buffers(int, uint*) @extern("glDeleteBuffers");
extern fn void delete_textures(int size, uint* textures) @extern("glDeleteTextures");

extern fn void tex_parameter_i(int, int, int) @extern("glTexParameteri");
extern fn void texture_parameter_i(int, int, int) @extern("glTextureParameteri");
extern fn void texture_parameter_f(int, int, float) @extern("glTextureParameterf");
extern fn void texture_parameter_fv(int, int, float[]) @extern("glTextureParameterfv");

// Textures
extern fn void gen_textures(int, uint*) @extern("glGenTextures");
extern fn void bind_texture(int, uint) @extern("glBindTexture");
extern fn void generate_mipmap(int) @extern("glGenerateMipmap");
extern fn void tex_image_2d(int target, int level, int internalFormat, int width, int height, int border, int format, int type, void* data) @extern("glTexImage2D");

extern fn void vertex_attrib_pointer(uint, int, int, bool, int, void*) @extern("glVertexAttribPointer");
extern fn void enable_vertex_attrib_array(uint) @extern("glEnableVertexAttribArray");
extern fn void gen_vertex_arrays(uint, uint*) @extern("glGenVertexArrays");
extern fn void bind_vertex_array(uint) @extern("glBindVertexArray");
extern fn void draw_arrays(int, uint, uint) @extern("glDrawArrays");
extern fn void draw_elements(int, uint, int, void*) @extern("glDrawElements");


extern fn void viewport(int, int, int, int) @extern("glViewport");

