
module ennoia::ui;
import std::io;
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
    Color color = color::WHITE,
) {
  font.draw(text, position, scale, spacing, color);
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
    Color color = color::WHITE,
) {
  // Check for bounds size
  Rectangle tileBounds = {
    bounds.x,
    bounds.y,
    ((bounds.w <= 0) ? (font.dim.x + spacing) * text.len + (textPadding.x + textPadding.z) : bounds.w),
    ((bounds.w <= 0) ? (font.dim.y + spacing) * ((float)text.count("\n") + 1) + (textPadding.y + textPadding.w) : bounds.h),
  };

  // change color when hovered or clicked down
  Color col = color;
  if (tileBounds.within(ennoia::mousePosition)) {
    if (keybinds::mouse_down(1)) {
      col *= color::DARKGRAY;
    } else {
      col *= color::LIGHTGRAY;
    }
  }
  
  // Draw background texture
  texture.draw_tiled(dest:tileBounds*scale, layout:THREE_ONE, color:col);

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
  font.draw(text, textPosition, scale, spacing, color);

  // Activate when let go on
  return (tileBounds.within(ennoia::mousePosition) && keybinds::mouse_up(1));
}
