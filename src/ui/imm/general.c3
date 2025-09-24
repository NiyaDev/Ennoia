
module ennoia::ui::imm;
import ennoia;


<* Immediate mode Label *>
fn void label(
  String text = "",
  String font = "font",
  float spacing = 0,
  Color tint = color::WHITE,

  Vector2 position = {0,0},
  Vector2 scale = {1,1},
) @export("imm_label") {
  render::draw_font(
    font,
    text,
    position,
    scale,
    spacing,
    tint,
  );
}
<* Immediate mode Button *>
fn bool button(
  String text = "",
  String font = "font",
  float spacing = 0,
  Color textTint = color::WHITE,
  Vector2 textScale = {1,1},

  String texture = "",
  Color[3] textureTint = {color::WHITE,color::LIGHTGRAY,color::DARKGRAY},
  Rectangle bounds = {0,0,64,16},
  Vector2 textureScale = {1,1},
) @export("imm_button") {
  Font? f = ennoia::fonts.get(font);
  Texture? t = ennoia::textures.get(texture);

  // Get color
  Color col = textureTint[0];
  if (bounds.within(ennoia::mousePosition)) {
    col = (keybinds::mouse_down(1) ? textureTint[2] : textureTint[1]);
  }

  // Draw texture
  if (try t) {
    render::draw_texture_tiled(
      nameTexture: texture,
      dst:         bounds,
      scale:       textureScale,
      tint:        col,
    );
  }

  // Draw text
  if (try f) {
    String[] split = text.tsplit("\n");
    float longest;
    for (int i; i < split.len; i++) split[i].len > longest ? longest = split[i].len : 0;
    float yOffset = (((split.len * f.dim.y) + spacing) / 2) * textScale.y;
    float xOffset = (((longest   * f.dim.x) + spacing) / 2) * textScale.x;

    Vector2 textPosition = {
      (bounds.x + (bounds.w / 2)) - xOffset,
      (bounds.y + (bounds.h / 2)) - yOffset,
    };

    render::draw_font(font, text, textPosition, textScale, spacing, col);
  }

  // Interaction
  if (bounds.within(ennoia::mousePosition) && keybinds::mouse_up(1)) return true;
  return false;
}
<* Immediate mode Bar *>
fn void bar(
  String text = "",
  String font = "font",
  float spacing = 0,
  Color textTint = color::WHITE,
  Vector2 textScale = {1,1},

  String textureBg = "",
  String textureFg = "",
  Color textureTint = color::WHITE,

  Rectangle bounds = {0,0,64,16},
  Vector2 textureScale = {1,1},

  float* value = null,
  float* valueMax = null,
) @export("imm_bar") {
  Font? f = ennoia::fonts.get(font);
  Texture? bg = ennoia::textures.get(textureBg);
  Texture? fg = ennoia::textures.get(textureFg);

  // Draw Textures
  if (try bg) {
    render::draw_texture_tiled(
      nameTexture: textureBg,
      dst:         bounds,
      scale:       textureScale,
      tint:        textureTint,
    );
  }
  float percentage = value != null && valueMax != null ? *value / *valueMax : 1;
  if (try fg) {
    render::draw_texture_tiled(
      nameTexture: textureFg,
      dst:         bounds * (Rectangle){1,1,percentage,1},
      scale:       textureScale,
      tint:        textureTint,
    );
  }
  
  // Draw text
  if (try f) {
    String[] split = text.tsplit("\n");
    float longest;
    for (int i; i < split.len; i++) split[i].len > longest ? longest = split[i].len : 0;
    float yOffset = (((split.len * f.dim.y) + spacing) / 2) * textScale.y;
    float xOffset = (((longest   * f.dim.x) + spacing) / 2) * textScale.x;

    Vector2 textPosition = {
      (bounds.x + (bounds.w / 2)) - xOffset,
      (bounds.y + (bounds.h / 2)) - yOffset,
    };

    render::draw_font(font, text, textPosition, textScale, spacing, textTint);
  }
}

