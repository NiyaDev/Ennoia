
module ennoia;
import std::collections;
import sdl3;


SDL_Window* window;
SDL_Surface* surface;
SDL_GLContext* glcontext;
SDL_Event event;

Color   bgColor = color::PURPLE;
Mesh    textureMesh;
Texture defaultTexture;
Font    defaultFont;

double deltaTime @export("deltatime");
double lastFrame @export("lastframe");
bool forceClose @export("forceclose");

int scrWidth, scrHeight;
int renWidth, renHeight;
float renRes;
bool borderless, fullscreen;

Shader defaultShader2d;
Shader defaultShader3d;


Keybindings   keybinds;
List{KeyData} keyqueue;

Vector2 mousePosition;
bool[5] mouseButtons, mouseButtonsHeld, mouseButtonsUp;
float scrollwheel;

Options options;

Localization localization;
String language = "english";

HashMap{String, Texture} textures;
HashMap{String, Font}    fonts;
HashMap{String, Model}   models;
HashMap{String, Shader}  shaders;

