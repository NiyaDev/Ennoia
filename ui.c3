
module ennoia::ui;
import ennoia;


struct Element {
  ElementType type;
  void* data;
}

enum ElementType {
  EMPTY,

  LABEL,
  BUTTON,

  HORI_LIST,
  VERT_LIST,
  SQUARE_LIST,

  WINDOW,
}

