
module ennoia;
import std::collections;


double deltaTime, lastFrame;

Shader defaultShader2d;
Shader defaultShader3d;


Keybindings   keybinds;
List{KeyData} keyqueue;

Options options;

Localization localization;
String language = "english";

HashMap{String, Texture} textures;
HashMap{String, Font}    fonts;
HashMap{String, Model}   models;
HashMap{String, Shader}  shaders;

