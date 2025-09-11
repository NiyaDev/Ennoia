
module ennoia::ui;
import ennoia;
import std::io;


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

<* Draws text label *>
fn void label(
  String text,
  Font font = ennoia::defaultFont,
  Vector2 position = {},
  Vector2 scale = {1,1},
  float spacing = 0,
  Color tint = color::WHITE,
) {
  font.draw(text, position, scale, spacing, tint);
}

<* Draw button and returns whether it's been clicked *>
fn bool button(
  String text = "",
  Font font = ennoia::defaultFont,
  Texture texture = ennoia::defaultTexture,
  Rectangle bounds = {0,0,-1,-1},
  Vector4 textPadding = {10,10,10,10},
  TextAlignmentHorizontal alignHor = CENTER,
  TextAlignmentVertical   alignVer = CENTER,
  Vector2 scale = {1,1},
  float spacing = 0,
  Color tint = color::WHITE,
) {
  // Check bounds size
  Rectangle tileBounds = {
    bounds.x,
    bounds.y,
    (bounds.w <= 0 ? (font.dim.x + spacing) * text.len + (textPadding.x + textPadding.z) : bounds.w),
    (bounds.h <= 0 ? (font.dim.y + spacing) * ((float)text.count("\n") + 1) + (textPadding.y + textPadding.w) : bounds.h),
  };

  // Change color
  Color col = tint;
  if (tileBounds.within(ennoia::mousePosition)) {
    col *= (keybinds::mouse_down(1) ? color::DARKGRAY : color::LIGHTGRAY);
  }

  // Draw bg texture
  texture.draw_tiled(dest:tileBounds*scale, layout:THREE_ONE, tint:col);

  // Caluclate text position
  Vector2 textPosition;
  switch (alignHor) {
    case RIGHT:
      textPosition = (tileBounds.v2() + textPadding.v2()) * scale;
    case CENTER:
      textPosition.x = ((tileBounds.x + (tileBounds.w / 2)) - (((font.dim.x + spacing) * text.len) / 2)) * scale.x;
      textPosition.y = ((tileBounds.y + (tileBounds.h / 2)) - (((font.dim.y + spacing) * ((float)text.count("\n") + 1)) / 2)) * scale.y;
    case LEFT:
      textPosition.x = (tileBounds.x + tileBounds.w - textPadding.z - ((font.dim.x + spacing) * text.len)) * scale.x;
      textPosition.y = (tileBounds.y + textPadding.y) * scale.y;
  }

  // Draw text
  font.draw(text, textPosition, scale, spacing, tint);

  // Activate when let go of
  return (tileBounds.within(ennoia::mousePosition) && keybinds::mouse_up(1));
}
