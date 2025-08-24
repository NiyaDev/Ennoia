
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

enum TextAlignment {
  RIGHT,
  CENTER,
  LEFT,
}


<* Draws text to screen *>
fn void label(
    String text,
    Font font = ennoia::defaultFont,
    Vector2 position = {0,0,0},
    Vector2 scale = {1,1},
    float spacing = 0,
) {
  font.draw(text, position, scale, spacing);
}
<* Draws button to screen *>
fn bool button(
    String text,
    Font font = ennoia::defaultFont,
    Texture texture = ennoia::defaultTexture,
    Rectangle bounds = {0,0,-1,-1},
    Vector4 textPadding = {10,10,10,10},
    TextAlignment textAlignment = CENTER,
    Vector2 scale = {1,1},
    float spacing = 0,
) {
  // Check for bounds size
  Rectangle tileBounds = {
    bounds.x,
    bounds.y,
    ((bounds.w <= 0) ? (font.dim.x + spacing) * text.len + (textPadding.x + textPadding.z) : bounds.w),
    ((bounds.w <= 0) ? (font.dim.y + spacing) * ((float)text.count("\n") + 1) + (textPadding.y + textPadding.w) : bounds.h),
  };

  // Draw background texture
  texture.draw_tiled(dest:tileBounds*scale, layout:THREE_THREE);

  // Calculate text position
  Vector2 textPosition;
  switch (textAlignment) {
    case RIGHT:
      textPosition = {
        (tileBounds.x + textPadding.x) * scale.x,
        (tileBounds.y + textPadding.y) * scale.y,
      };
    case CENTER:
      textPosition = {
        ((tileBounds.x + (tileBounds.w / 2)) - (((font.dim.x + spacing) * text.len) / 2)) * scale.x,
        ((tileBounds.y + (tileBounds.h / 2)) - (((font.dim.y + spacing) * ((float)text.count("\n") + 1)) / 2)) * scale.y,
      };
    case LEFT:
      textPosition = {
        (tileBounds.x + tileBounds.w - textPadding.z - ((font.dim.x + spacing) * text.len)) * scale.x,
        (tileBounds.y + textPadding.y) * scale.y,
      };
  }

  // Draw text
  font.draw(text, textPosition, scale, spacing);

  // change color when clicked down
  // Activate when let go on
  return tileBounds.within(ennoia::mousePosition) && keybinds::mouse_up(1);
}
