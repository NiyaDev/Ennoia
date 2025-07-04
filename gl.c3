
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


const int KEY_SPACE = 32;
const int KEY_APOSTROPHE = 39;  /* ' */
const int KEY_COMMA = 44;  /* , */
const int KEY_MINUS = 45;  /* - */
const int KEY_PERIOD = 46;  /* . */
const int KEY_SLASH = 47;  /* / */
const int KEY_0 = 48; 
const int KEY_1 = 49; 
const int KEY_2 = 50; 
const int KEY_3 = 51; 
const int KEY_4 = 52; 
const int KEY_5 = 53; 
const int KEY_6 = 54; 
const int KEY_7 = 55; 
const int KEY_8 = 56; 
const int KEY_9 = 57; 
const int KEY_SEMICOLON = 59;  /* ; */
const int KEY_EQUAL = 61;  /* = */
const int KEY_A = 65; 
const int KEY_B = 66; 
const int KEY_C = 67; 
const int KEY_D = 68; 
const int KEY_E = 69; 
const int KEY_F = 70; 
const int KEY_G = 71; 
const int KEY_H = 72; 
const int KEY_I = 73; 
const int KEY_J = 74; 
const int KEY_K = 75; 
const int KEY_L = 76; 
const int KEY_M = 77; 
const int KEY_N = 78; 
const int KEY_O = 79; 
const int KEY_P = 80; 
const int KEY_Q = 81; 
const int KEY_R = 82; 
const int KEY_S = 83; 
const int KEY_T = 84; 
const int KEY_U = 85; 
const int KEY_V = 86; 
const int KEY_W = 87; 
const int KEY_X = 88; 
const int KEY_Y = 89; 
const int KEY_Z = 90; 
const int KEY_LEFT_BRACKET = 91;  /* [ */
const int KEY_BACKSLASH = 92;  /* \ */
const int KEY_RIGHT_BRACKET = 93;  /* ] */
const int KEY_GRAVE_ACCENT = 96;  /* ` */
const int KEY_WORLD_1 = 161;  /* non-US #1 */
const int KEY_WORLD_2 = 162;  /* non-US #2 */
const int KEY_ESCAPE = 256; 
const int KEY_ENTER = 257; 
const int KEY_TAB = 258; 
const int KEY_BACKSPACE = 259; 
const int KEY_INSERT = 260; 
const int KEY_DELETE = 261; 
const int KEY_RIGHT = 262; 
const int KEY_LEFT = 263; 
const int KEY_DOWN = 264; 
const int KEY_UP = 265; 
const int KEY_PAGE_UP = 266; 
const int KEY_PAGE_DOWN = 267; 
const int KEY_HOME = 268; 
const int KEY_END = 269; 
const int KEY_CAPS_LOCK = 280; 
const int KEY_SCROLL_LOCK = 281; 
const int KEY_NUM_LOCK = 282; 
const int KEY_PRINT_SCREEN = 283; 
const int KEY_PAUSE = 284; 
const int KEY_F1 = 290; 
const int KEY_F2 = 291; 
const int KEY_F3 = 292; 
const int KEY_F4 = 293; 
const int KEY_F5 = 294; 
const int KEY_F6 = 295; 
const int KEY_F7 = 296; 
const int KEY_F8 = 297; 
const int KEY_F9 = 298; 
const int KEY_F10 = 299; 
const int KEY_F11 = 300; 
const int KEY_F12 = 301; 
const int KEY_F13 = 302; 
const int KEY_F14 = 303; 
const int KEY_F15 = 304; 
const int KEY_F16 = 305; 
const int KEY_F17 = 306; 
const int KEY_F18 = 307; 
const int KEY_F19 = 308; 
const int KEY_F20 = 309; 
const int KEY_F21 = 310; 
const int KEY_F22 = 311; 
const int KEY_F23 = 312; 
const int KEY_F24 = 313; 
const int KEY_F25 = 314; 
const int KEY_KP_0 = 320; 
const int KEY_KP_1 = 321; 
const int KEY_KP_2 = 322; 
const int KEY_KP_3 = 323; 
const int KEY_KP_4 = 324; 
const int KEY_KP_5 = 325; 

const int RELEASE = 0;
const int PRESS = 1;
const int REPEAT = 2;
const int KEY_UNKNOWN = -1;

alias GLFWwindow = void;
alias GLFWmonitor = void;

extern fn int init() @extern("glfwInit");
extern fn void window_hint(int, int) @extern("glfwWindowHint");
extern fn void make_context_current(GLFWwindow*) @extern("glfwMakeContextCurrent");
extern fn bool window_should_close(GLFWwindow*) @extern("glfwWindowShouldClose");
extern fn void set_window_should_close(GLFWwindow*, bool) @extern("glfwSetWindowShouldClose");
extern fn void swap_buffers(GLFWwindow*) @extern("glfwSwapBuffers");
extern fn void poll_events() @extern("glfwPollEvents");
extern fn void terminate() @extern("glfwTerminate");
extern fn int get_key(GLFWwindow*, int) @extern("glfwGetKey");
extern fn void clear_color(float, float, float, float) @extern("glClearColor");
extern fn void clear(int) @extern("glClear");
extern fn float get_time() @extern("glfwGetTime");
extern fn void enable(int) @extern("glEnable");

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
extern fn int get_uniform_location(uint, char*) @extern("glGetUniformLocation");
extern fn void program_uniform_f(uint, int, float) @extern("glProgramUniform1f");
extern fn void program_uniform_matrix4_fv(uint, int, int, bool, float*) @extern("glProgramUniformMatrix4fv");
extern fn void delete_vertex_arrays(int, uint*) @extern("glDeleteVertexArrays");
extern fn void delete_buffers(int, uint*) @extern("glDeleteBuffers");

extern fn void texture_parameter_i(int, int, int) @extern("glTextureParameteri");
extern fn void texture_parameter_f(int, int, float) @extern("glTextureParameterf");
extern fn void texture_parameter_fv(int, int, float[]) @extern("glTextureParameterfv");

// Textures
extern fn void gen_textures(int, uint*) @extern("glGenTextures");
extern fn void bind_texture(int, uint) @extern("glBindTexture");
extern fn void tex_image_2d(int, int, int, uint, uint, int, int, int, char*) @extern("glTexImage2D");
extern fn void generate_mipmap(int) @extern("glGenerateMipmap");

extern fn void vertex_attrib_pointer(uint, int, int, bool, int, void*) @extern("glVertexAttribPointer");
extern fn void enable_vertex_attrib_array(uint) @extern("glEnableVertexAttribArray");
extern fn void gen_vertex_arrays(uint, uint*) @extern("glGenVertexArrays");
extern fn void bind_vertex_array(uint) @extern("glBindVertexArray");
extern fn void draw_arrays(int, uint, uint) @extern("glDrawArrays");
extern fn void draw_elements(int, uint, int, void*) @extern("glDrawElements");

extern fn GLFWwindow* create_window(int, int, char*, GLFWmonitor*, GLFWmonitor*) @extern("glfwCreateWindow");
extern fn GLFWmonitor* get_primary_monitor() @extern("glfwGetPrimaryMonitor");

extern fn void viewport(int, int, int, int) @extern("glViewport");

alias CallbackSize = fn void(GLFWwindow*, int, int);
extern fn void set_framebuffer_size_callback(GLFWwindow*, CallbackSize) @extern("glfwSetFramebufferSizeCallback");


