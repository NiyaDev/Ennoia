
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
fn void label(String text, Font font = ennoia::defaultFont, Vector2 position = {0,0,0}, Vector2 scale = {1,1}) {
  font.draw(text, position, scale);
}
<* Draws button to screen *>
fn bool button(String text, Font font = ennoia::defaultFont, Texture texture = ennoia::defaultTexture, Rectangle bounds = {0,0,100,50}, Vector4 textPadding = {5,5,5,5}, Vector2 scale = {1,1}) {
  Rectangle textOffset = bounds + textPadding;
  font.draw(text, {textOffset.x, textOffset.y}, scale);
  texture.draw_tiled(dest:bounds*scale);
  return false;
}
