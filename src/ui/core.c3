
module ennoia::ui::old;
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
    ElementBar bar;

    ElementVerticalContainer contVert;
  }
}
enum ElementType {
  EMPTY,

  LABEL,
  BUTTON,
  BAR,

  CONTAINER_VERT,
  CONTAINER_HORI,
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
  Vec2f spacing;
  Color tint;

  Vec2f position;
  Vec2f scale;
}
struct ElementButton {
  String text;
  String font;
  Vec2f spacing;
  Color textTint;

  String texture;
  Color[3] textureTint;

  Rectangle bounds;
  Vec4f textPadding;
  Vec2f scale;

  TextAlignmentHorizontal alignHori;
  TextAlignmentVertical   alignVert;

  bool active;
  FuncCallVoid hover;
  FuncCallVoid click;
}
struct ElementBar {
  String text;
  String font;
  Vec2f spacing;
  Color textTint;

  String textureBg;
  String textureFg;
  Color textureTint;

  Rectangle bounds;
  Vec4f textPadding;
  Vec2f scale;

  float* value;
  float* valueMax;
}

struct ElementVerticalContainer {
  Rectangle bounds;
  Vec2f scale;
  Vec4f offset;
  Vec2f spacing;

  String texture;

  Element*[] elements;
}


<* Creates a new Label element *>
fn Element* new_label(
  String text = "NULL",
  long duration = 0,
  String font = "font",
  Vec2f spacing = {0,0},
  Color tint = color::WHITE,
  Vec2f position = {0,0},
  Vec2f scale = {1,1},
) @export("ui_label") {
  Element* e = mem::new(Element);
  e.type = LABEL;
  e.temporary     = (duration <= 0 ? false : true);
  e.duration      = (duration <= 0 ? 0 : duration);
  e.durationTotal = (duration <= 0 ? 0 : duration);
  e.label = {text, font, spacing, tint, position, scale};

  return e;
}
<* Creates a new Button element *>
fn Element* new_button(
  String text = "NULL",
  long duration = 0,
  String font = "font",
  Vec2f spacing = {0,0},
  Color textTint = color::WHITE,

  String texture = "texture",
  Color[3] textureTint = {color::WHITE, color::LIGHTGRAY, color::DARKGRAY},
  Rectangle bounds = {0,0,64,16},
  Vec4f textPadding = {2,2,2,2},
  Vec2f scale = {1,1},

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
    text, font, spacing, textTint, texture,
    textureTint, bounds, textPadding, scale,
    alignHori, alignVert, active, hover, click,
  };

  return e;
}
<* Creates a new Bar element *>
fn Element* new_bar(
  long duration = 0,
  String text = "",
  String font = "font",
  Vec2f spacing = {0,0},
  Color textTint = color::WHITE,
  String textureBg = "texture",
  String textureFg = "texture",
  Color textureTint = color::WHITE,
  Rectangle bounds = {0,0,64,16},
  Vec4f textPadding = {2,2,2,2},
  Vec2f scale = {1,1},
  float* value = null,
  float* valueMax = null,
) @export("ui_bar") {
  Element* e = mem::new(Element);
  e.type = BAR;
  e.temporary     = (duration <= 0 ? false : true);
  e.duration      = (duration <= 0 ? 0 : duration);
  e.durationTotal = (duration <= 0 ? 0 : duration);
  e.bar = {
    text, font, spacing, textTint,
    textureBg, textureFg, textureTint,
    bounds, textPadding, scale,
    value, valueMax,
  };
  return e;
}

<* Creates a new Container elememt *>
fn Element* new_container(
  ElementType container = CONTAINER_VERT,
  long duration = 0,
  Rectangle bounds = {0,0,16,16},
  Vec2f scale = {1,1},
  Vec4f offset = {2,2,2,2},
  Vec2f spacing = {0,0},
  String texture = "",
  Element*[] elements = {},
) @export("ui_container") {
  Element* e = mem::new(Element);
  e.type = container;
  e.temporary     = (duration <= 0 ? false : true);
  e.duration      = (duration <= 0 ? 0 : duration);
  e.durationTotal = (duration <= 0 ? 0 : duration);

  
  switch (container) {
    case CONTAINER_VERT:
      e.contVert = {bounds, scale, offset, spacing, texture, elements};
    case CONTAINER_HORI:
    default:
      io::printfn("[ERROR] ENNOIA::UI::NEW_CONTAINER [Attempted to create a new container of a non container type]");
      free(e);
      return null;
  }

  return e;
}

