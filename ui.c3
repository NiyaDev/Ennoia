
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


<* Draws text to screen *>
fn void label(String text, Font font = ennoia::defaultFont, Vector2 position = {0,0,0}, Vector2 scale = {0,0,0}) {
  font.draw(text, position, scale);
}

