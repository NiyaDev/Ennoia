
/*
module ennoia::ui;
import ennoia::color;
import ennoia::rectangle;
import ennoia::vector;

alias Element = void;
alias FuncCallVoid = fn void();
enum ElementType {
  EMPTY,

  LABEL,
  BUTTON,
  BAR,

  CONTAINER_VERT,
  CONTAINER_HORI,
}
enum TextAlignmentHorizontal {
  RIGHT,
  CENTER,
  LEFT,
}
enum TextAlignmentVertical {
  TOP,
  CENTER,
  BOTTOM,
}

extern fn void add(String name, Element* e) @extern("ui_add");
extern fn bool exists(String name) @extern("ui_exists");
extern fn Element* get(String name) @extern("ui_get");

extern fn Element* new_label(String text = "NULL", long duration = 0, String font = "font", float spacing = 0, Color tint = color::WHITE, Vec2f position = {0,0}, Vec2f scale = {1,1}) @extern("ui_label");
extern fn Element* new_button(String text = "NULL", long duration = 0, String font = "font", float spacing = 0, Color textTint = color::WHITE, String texture = "texture", Color[3] textureTint = {{255, 255, 255, 255}, color::LIGHTGRAY, color::DARKGRAY}, Rectangle bounds = {0,0,64,16}, Vec4f textPadding = {2,2,2,2}, Vec2f scale = {1,1}, TextAlignmentHorizontal alignHori = CENTER, TextAlignmentVertical alignVert = CENTER, bool active = true, FuncCallVoid hover = null, FuncCallVoid click = null) @extern("ui_button");
extern fn Element* new_container(ElementType container = CONTAINER_VERT, long duration = 0, Rectangle bounds = {0,0,16,16}, Vec2f scale = {1,1}, Vec4f offset = {2,2,2,2}, float spacing = 0, String texture = "", Element*[] elements = {}) @extern("ui_container");
*/


module ennoia::ui::imm;
import ennoia::color;
import ennoia::rectangle;
import ennoia::vector;

extern fn void label(String text = "", String font = "font", float spacing = 0, Color tint = {255, 255, 255, 255}, Vec2f position = {0,0}, Vec2f scale = {1,1}, int priority = 0) @extern("imm_label");
extern fn void texture(String texture = "texture", Color tint = color::WHITE, Rectangle bounds = {0,0,64,16}, int priority = 0) @extern("imm_texture");
extern fn void texture_tiled(String texture = "texture", Color tint = color::WHITE, Rectangle bounds = {0,0,64,16}, Vec2f scale = {1,1}, int priority = 0) @extern("imm_texturetiled");
extern fn bool button(String text = "", String font = "font", float spacing = 0, Color textTint = {255, 255, 255, 255}, Vec2f textScale = {1,1}, String texture = "texture", Color[3] textureTint = {{255, 255, 255, 255},color::LIGHTGRAY,color::DARKGRAY}, Rectangle bounds = {0,0,64,16}, Vec2f textureScale = {1,1}, int priority = 0) @extern("imm_button");
extern fn void bar(String text = "", String font = "font", float spacing = 0, Color textTint = {255, 255, 255, 255}, Vec2f textScale = {1,1}, String textureBg = "", String textureFg = "", Color textureTint = {255, 255, 255, 255}, Rectangle bounds = {0,0,64,16}, Vec2f textureScale = {1,1}, int priority = 0, float* value = null, float* valueMax = null) @extern("imm_bar");
extern fn void input(bool* edit, String* input, Rectangle bounds = {0,0,64,16}, String texture = "", Vec2f textureScale = {1,1}, Color[3] textureTint = {color::WHITE, color::GRAY, color::DARKGRAY}, String font = "font", Vec2f textScale = {1,1}, Color textTint = color::BLACK, Vec2f spacing = {0,0}, String illegalChars = "") @extern("imm_input");

extern fn void container_drag(Vec2f* position, Rectangle dragArea = {0,0,32,8}) @extern("imm_contdrag");


module ennoia::ui;
import ennoia::color;
import ennoia::rectangle;
import ennoia::vector;
import std::collections;

enum TextAlignmentHori {
  LEFT,
  CENTER,
  RIGHT,
}

enum TextAlignmentVert {
  TOP,
  CENTER,
  BOTTOM,
}

enum UIElementType {
  LABEL,
  TEXTURE,
  BUTTON,
  BAR,
  CONTAINER,
}
struct UIElement {
  UIElementType type;
  union {
    UILabel label;
    UITexture texture;
    UIButton button;
    UIBar bar;
UIContainer cont;
  }
}


struct UILabel {
  String text;
  String font;

  TextAlignmentHori alignHori;
  TextAlignmentVert alignVert;

  Vec2f position;
  Vec2f scale;
  Vec2f spacing;
}

extern fn UILabel label(String text = "", String font = "font", TextAlignmentHori alignHori = LEFT, TextAlignmentVert alignVert = TOP, Vec2f position = {0,0}, Vec2f scale = {1,1}, Vec2f spacing = {0,0}) @extern("hui_labelnew");
extern fn void UILabel.draw(&self, Vec2f posOffset = {0,0}, Vec2f scaleMulti = {1,1}) @extern("hui_labeldraw");


struct UITexture {
  String texture;
  bool tiled;
  Color tint;

  Rectangle bounds;
  Vec2f scale;
}

extern fn UITexture texture(String texture = "texture", bool tiled = false, Color tint = color::WHITE, Rectangle bounds = {0,0,-1,-1}, Vec2f scale = {1,1}) @extern("hui_texturenew");
extern fn void UITexture.draw(&self, Vec2f posOffset = {0,0}, Vec2f scaleMulti = {1,1}) @extern("hui_texturedraw");


alias ButtonFunc = fn void();
struct UIButton {
  UILabel label;
  UITexture texture;

  Color[3] tints;
  ButtonFunc func;
}

extern fn UIButton button(String text = "", String font = "font", Vec2f txScale = {1,1}, Vec2f spacing = {0,0}, String texture = "texture", Color[3] tints = {color::WHITE,color::GRAY, color::DARKGRAY}, Rectangle bounds = {0,0,-1,-1}, Vec2f teScale = {1,1}, ButtonFunc func = null) @extern("hui_buttonnew");
extern fn void UIButton.draw(&self, Vec2f posOffset = {0,0}, Vec2f scaleMulti = {1,1}) @extern("hui_buttondraw");
extern fn void UIButton.set_bounds(&self, Rectangle bounds) @extern("hui_buttonbounds");


struct UIBar {
  UILabel label;
  UITexture fg;
  UITexture bg;

  float* value;
  float* max;
}

extern fn UIBar bar(String text = "", String font = "font", Vec2f txScale = {1,1}, Vec2f spacing = {0,0}, String texture   = "texture", String textureBG = "", String textureFG = "", Color[2] tints = {color::WHITE, color::GREEN}, Rectangle bounds = {0,0,-1,-1}, Vec2f teScale = {1,1}, float* value = null, float* max   = null) @extern("hui_barnew");
extern fn void UIBar.draw(&self, Vec2f posOffset = {0,0}, Vec2f scaleMulti = {1,1}) @extern("hui_bardraw");
extern fn void UIBar.set_bounds(&self, Rectangle bounds) @extern("hui_barbounds");


enum UIContainerType {
  VERTICAL,
  HORIZONTAL,
  SQUARE,
}
struct UIContainer {
  UIContainerType type;
  Rectangle bounds;
  Vec4f padding;
  Vec2f slot;

  UITexture background;
  List{UIElement} elements;
}

extern fn UIContainer container(UIContainerType type = VERTICAL, Rectangle bounds = {0,0,100,300}, Vec4f padding = {5,5,5,5}, Vec2f slot = {90,40}, String texture = "", Color tint = color::WHITE, Vec2f scale = {1,1}) @extern("hui_contnew");
extern fn void UIContainer.draw(&self, Vec2f posOffset = {0,0}, Vec2f scaleMulti = {1,1}) @extern("hui_contdraw");
extern fn void UIContainer.push(&self, any value) @extern("hui_contpush");

