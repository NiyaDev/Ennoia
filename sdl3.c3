
module ennoia::sdl;



const CONTEXT_PROFILE_CORE          = 0x00000001;
const CONTEXT_PROFILE_COMPATIBILITY = 0x00000002;
const CONTEXT_PROFILE_ES            = 0x00000004;

const INIT_AUDIO    = 0x00000010; /**< `SDL_INIT_AUDIO` implies `SDL_INIT_EVENTS` */
const INIT_VIDEO    = 0x00000020; /**< `SDL_INIT_VIDEO` implies `SDL_INIT_EVENTS`, should be initialized on the main thread */
const INIT_JOYSTICK = 0x00000200; /**< `SDL_INIT_JOYSTICK` implies `SDL_INIT_EVENTS` */
const INIT_HAPTIC   = 0x00001000;
const INIT_GAMEPAD  = 0x00002000; /**< `SDL_INIT_GAMEPAD` implies `SDL_INIT_JOYSTICK` */
const INIT_EVENTS   = 0x00004000;
const INIT_SENSOR   = 0x00008000; /**< `SDL_INIT_SENSOR` implies `SDL_INIT_EVENTS` */
const INIT_CAMERA   = 0x00010000; /**< `SDL_INIT_CAMERA` implies `SDL_INIT_EVENTS` */

const WINDOW_FULLSCREEN          = 0x0000000000000001;    /**< window is in fullscreen mode */
const WINDOW_OPENGL              = 0x0000000000000002;    /**< window usable with OpenGL context */
const WINDOW_OCCLUDED            = 0x0000000000000004;    /**< window is occluded */
const WINDOW_HIDDEN              = 0x0000000000000008;    /**< window is neither mapped onto the desktop nor shown in the taskbar/dock/window list; SDL_ShowWindow() is required for it to become visible */
const WINDOW_BORDERLESS          = 0x0000000000000010;    /**< no window decoration */
const WINDOW_RESIZABLE           = 0x0000000000000020;    /**< window can be resized */
const WINDOW_MINIMIZED           = 0x0000000000000040;    /**< window is minimized */
const WINDOW_MAXIMIZED           = 0x0000000000000080;    /**< window is maximized */
const WINDOW_MOUSE_GRABBED       = 0x0000000000000100;    /**< window has grabbed mouse input */
const WINDOW_INPUT_FOCUS         = 0x0000000000000200;    /**< window has input focus */
const WINDOW_MOUSE_FOCUS         = 0x0000000000000400;    /**< window has mouse focus */
const WINDOW_EXTERNAL            = 0x0000000000000800;    /**< window not created by SDL */
const WINDOW_MODAL               = 0x0000000000001000;    /**< window is modal */
const WINDOW_HIGH_PIXEL_DENSITY  = 0x0000000000002000;    /**< window uses high pixel density back buffer if possible */
const WINDOW_MOUSE_CAPTURE       = 0x0000000000004000;    /**< window has mouse captured (unrelated to MOUSE_GRABBED) */
const WINDOW_MOUSE_RELATIVE_MODE = 0x0000000000008000;    /**< window has relative mode enabled */
const WINDOW_ALWAYS_ON_TOP       = 0x0000000000010000;    /**< window should always be above others */
const WINDOW_UTILITY             = 0x0000000000020000;    /**< window should be treated as a utility window, not showing in the task bar and window list */
const WINDOW_TOOLTIP             = 0x0000000000040000;    /**< window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window */
const WINDOW_POPUP_MENU          = 0x0000000000080000;    /**< window should be treated as a popup menu, requires a parent window */
const WINDOW_KEYBOARD_GRABBED    = 0x0000000000100000;    /**< window has grabbed keyboard input */
const WINDOW_VULKAN              = 0x0000000010000000;    /**< window usable for Vulkan surface */
const WINDOW_METAL               = 0x0000000020000000;    /**< window usable for Metal view */
const WINDOW_TRANSPARENT         = 0x0000000040000000;    /**< window with transparent buffer */
const WINDOW_NOT_FOCUSABLE       = 0x0000000080000000;    /**< window should not be focusable */

enum GLAttr {
  RED_SIZE,                    /**< the minimum number of bits for the red channel of the color buffer; defaults to 8. */
  GREEN_SIZE,                  /**< the minimum number of bits for the green channel of the color buffer; defaults to 8. */
  BLUE_SIZE,                   /**< the minimum number of bits for the blue channel of the color buffer; defaults to 8. */
  ALPHA_SIZE,                  /**< the minimum number of bits for the alpha channel of the color buffer; defaults to 8. */
  BUFFER_SIZE,                 /**< the minimum number of bits for frame buffer size; defaults to 0. */
  DOUBLEBUFFER,                /**< whether the output is single or double buffered; defaults to double buffering on. */
  DEPTH_SIZE,                  /**< the minimum number of bits in the depth buffer; defaults to 16. */
  STENCIL_SIZE,                /**< the minimum number of bits in the stencil buffer; defaults to 0. */
  ACCUM_RED_SIZE,              /**< the minimum number of bits for the red channel of the accumulation buffer; defaults to 0. */
  ACCUM_GREEN_SIZE,            /**< the minimum number of bits for the green channel of the accumulation buffer; defaults to 0. */
  ACCUM_BLUE_SIZE,             /**< the minimum number of bits for the blue channel of the accumulation buffer; defaults to 0. */
  ACCUM_ALPHA_SIZE,            /**< the minimum number of bits for the alpha channel of the accumulation buffer; defaults to 0. */
  STEREO,                      /**< whether the output is stereo 3D; defaults to off. */
  MULTISAMPLEBUFFERS,          /**< the number of buffers used for multisample anti-aliasing; defaults to 0. */
  MULTISAMPLESAMPLES,          /**< the number of samples used around the current pixel used for multisample anti-aliasing. */
  ACCELERATED_VISUAL,          /**< set to 1 to require hardware acceleration, set to 0 to force software rendering; defaults to allow either. */
  RETAINED_BACKING,            /**< not used (deprecated). */
  CONTEXT_MAJOR_VERSION,       /**< OpenGL context major version. */
  CONTEXT_MINOR_VERSION,       /**< OpenGL context minor version. */
  CONTEXT_FLAGS,               /**< some combination of 0 or more of elements of the SDL_GLContextFlag enumeration; defaults to 0. */
  CONTEXT_PROFILE_MASK,        /**< type of GL context (Core, Compatibility, ES). See SDL_GLProfile; default value depends on platform. */
  SHARE_WITH_CURRENT_CONTEXT,  /**< OpenGL context sharing; defaults to 0. */
  FRAMEBUFFER_SRGB_CAPABLE,    /**< requests sRGB capable visual; defaults to 0. */
  CONTEXT_RELEASE_BEHAVIOR,    /**< sets context the release behavior. See SDL_GLContextReleaseFlag; defaults to FLUSH. */
  CONTEXT_RESET_NOTIFICATION,  /**< set context reset notification. See SDL_GLContextResetNotification; defaults to NO_NOTIFICATION. */
  CONTEXT_NO_ERROR,
  FLOATBUFFERS,
  EGL_PLATFORM,
}

union SDL_Event {
  uint type;
  
  char[128] padding;
}

// Basic events
const FIRSTEVENT              = 0x0000;
const QUIT                    = 0x0100;
const APP_TERMINATING         = 0x0101;
const APP_LOWMEMORY           = 0x0102;
const APP_WILLENTERBACKGROUND = 0x0103;
const APP_DIDENTERBACKGROUND  = 0x0104;
const APP_WILLENTERFOREGROUND = 0x0105;
const APP_DIDENTERFOREGROUND  = 0x0106;

// Keyboard events
const KEYDOWN       = 0x0300;
const KEYUP         = 0x0301;
const TEXTEDITING   = 0x0302;
const TEXTINPUT     = 0x0303;
const KEYMAPCHANGED = 0x0304;

// Mouse events
const MOUSEMOTION     = 0x0400;
const MOUSEBUTTONDOWN = 0x0401;
const MOUSEBUTTONUP   = 0x0402;
const MOUSEWHEEL      = 0x0403;

// TODO:
// Controller events
// Touch events
// Window events
// Touch device events
// Drag and drop events
// Clipboard events


//struct SDL_ {}

alias SDL_Window = void;
alias SDL_Surface = void;
alias SDL_GLContext = void;

extern fn bool init(uint) @extern("SDL_Init");
extern fn SDL_Window* create_window(char*, int, int, uint) @extern("SDL_CreateWindow");
extern fn SDL_Surface* create_surface(int, int, uint, void*, int) @extern("SDL_CreateSurface");
extern fn bool poll_event(SDL_Event*) @extern("SDL_PollEvent");
extern fn ulong get_ticks() @extern("SDL_GetTicks");
extern fn void destroy_window(SDL_Window*) @extern("SDL_DestroyWindow");
extern fn void quit() @extern("SDL_Quit");
extern fn char* get_error() @extern("SDL_GetError");

extern fn SDL_GLContext* gl_create_context(SDL_Window*) @extern("SDL_GL_CreateContext");
extern fn bool gl_make_current(SDL_Window*, SDL_GLContext*) @extern("SDL_GL_MakeCurrent");
extern fn bool gl_set_attribute(GLAttr, int) @extern("SDL_GL_SetAttribute");
extern fn bool gl_swap_window(SDL_Window*) @extern("SDL_GL_SwapWindow");

