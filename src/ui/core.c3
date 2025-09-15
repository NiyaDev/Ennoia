
module ennoia::ui;
import ennoia;
import std::io;


struct Element {
  ElementType type;

  bool temporary;
  long duration;
  long durationTotal;

  union {
    ElementLabel label;
    ElementButton button;
  }
}
enum ElementType {
  EMPTY,

  LABEL,
  BUTTON,
}

alias FuncCallVoid = fn void();

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

struct ElementLabel {
  String text;
  String font;
  float spacing;
  Color tint;

  Vector2 position;
  Vector2 scale;
}
struct ElementButton {
  String text;
  String font;
  float spacing;
  Color textTint;

  String texture;
  Color[3] textureTint;

  Rectangle bounds;
  Vector4 textPadding;
  Vector2 scale;

  TextAlignmentHorizontal alignHori;
  TextAlignmentVertical   alignVert;

  bool active;
  FuncCallVoid hover;
  FuncCallVoid click;
}



<* Creates a new Label element *>
fn Element* new_label(
  String text = "NULL",
  long duration = 0,
  String font = "font",
  float spacing = 0,
  Color tint = color::WHITE,
  Vector2 position = {0,0},
  Vector2 scale = {1,1},
) @export("ui_label") {
  Element* e = mem::new(Element);
  e.type = LABEL;
  e.temporary     = (duration <= 0 ? false : true);
  e.duration      = (duration <= 0 ? 0 : duration);
  e.durationTotal = (duration <= 0 ? 0 : duration);
  e.label = {
    text,
    font,
    spacing,
    tint,
    position,
    scale,
  };

  return e;
}
<* Creates a new Button element *>
fn Element* new_button(
  String text = "NULL",
  long duration = 0,
  String font = "font",
  float spacing = 0,
  Color textTint = color::WHITE,

  String texture = "texture",
  Color[3] textureTint = {color::WHITE, color::LIGHTGRAY, color::DARKGRAY},
  Rectangle bounds = {0,0,64,16},
  Vector4 textPadding = {2,2,2,2},
  Vector2 scale = {1,1},

  TextAlignmentHorizontal alignHori = CENTER,
  TextAlignmentVertical   alignVert = CENTER,

  bool active = true,
  FuncCallVoid hover = null,
  FuncCallVoid click = null,
) @export("ui_button") {
  Element* e = mem::new(Element);
  e.type = BUTTON;
  e.temporary     = (duration <= 0 ? false : true);
  e.duration      = (duration <= 0 ? 0 : duration);
  e.durationTotal = (duration <= 0 ? 0 : duration);
  e.button = {
    text,
    font,
    spacing,
    textTint,
    texture,
    textureTint,
    bounds,
    textPadding,
    scale,
    alignHori,
    alignVert,
    active,
    hover,
    click,
  };

  return e;
}


