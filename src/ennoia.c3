
module ennoia;
import std::collections;
import sdl3;


SDL_Window* window;
SDL_GLContext* glcontext;
SDL_Event event;

Color bgColor @export("bgcolor") = color::PURPLE;
Mesh  textureMesh;

double deltaTime @export("deltatime");
double lastFrame @export("lastframe");
bool forceClose @export("forceclose");

int scrWidth, scrHeight;
int renWidth @export("renderwidth");
int renHeight @export("renderheight");
float renRes;
bool borderless, fullscreen;

Shader defaultShader2d;
Shader defaultShader3d;


Keybindings   keybinds;
List{KeyData} keyqueue;

Vector2 mousePosition @export("mouseposition");
bool[5] mouseButtons, mouseButtonsHeld, mouseButtonsUp;
float scrollwheel @export("scrollwheel");

Options options;

Localization localization;
String language = "english";

HashMap{String, Texture}  textures;
HashMap{String, Font}     fonts;
HashMap{String, Mesh}     meshes;
HashMap{String, Shader}   shaders;
HashMap{String, Element*} uiElements;

