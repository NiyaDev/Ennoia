
module ennoia::ui::imm;
import ennoia::color;
import ennoia::keybinds;
import ennoia::font;
import ennoia::rectangle;
import ennoia::render;
import ennoia::texture;
import ennoia::vector;
import std::io;


<**>
fn void input(
  bool* edit,
  String* input,
 
  Rectangle bounds = {0,0,64,16},
  String texture = "",
  Vec2f textureScale = {1,1},
  Color[3] textureTint = {color::WHITE, color::GRAY, color::DARKGRAY},

  String font = "font",
  Vec2f textScale = {1,1},
  Color textTint = color::BLACK,
  Vec2f spacing = {0,0},
) @export("imm_input") {
  // Draw background texture
  if (texture != "") {
    Texture? t = ennoia::textures.get(texture);
    if (try t) {
      // Get texture tint
      Color col = textureTint[0];
      if (bounds.within(ennoia::mousePosition)) {
        col = keybinds::mouse_down(1) ? textureTint[2] : textureTint[1];
      }
      
      // Draw
      render::draw_texture_tiled(
        nameTexture: texture,
        dst: bounds,
        scale: textureScale,
        tint: col,
        priority: 2,
      );
    }
  }

  // Interaction logic
  if (keybinds::mouse_down(1)) {
    if (bounds.within(ennoia::mousePosition)) {
      *edit = true;
    } else { *edit = false; }
  }
  if (*edit) {
    Font? f = ennoia::fonts.get(font);
    KeyData? dat = ennoia::keyqueue.pop();
    if (try dat) {
      // Find last
      int index;
      for (; index < input.len; index++) {
        if ((*input)[index] == '\0') break;
      }
      // Check for backspace
      if ((char)dat.key == 8 && index != 0 && (dat.down && !dat.repeat)) (*input)[index-1] = '\0';
      // Input text
      if (index != input.len && dat.is_alphanumeric() && (dat.down && !dat.repeat)) (*input)[index] = (char)dat.key;
    }
  }
  //if ()
  //KeyData? dat = ennoia::keyqueue.pop();
  //if (try dat) {io::printfn("%s",dat.key);unreachable();}

  // Draw text
  if (font != "") {
    Font? f = ennoia::fonts.get(font);
    if (try f) {
      float xOffset = 5;
      float yOffset = ((f.dim.y + spacing.y) / 2) * textScale.y;
      Vec2f textPosition = {
        bounds.x + xOffset,
        //(bounds.x + (bounds.w / 2)) - xOffset,
        (bounds.y + (bounds.h / 2)) - yOffset,
      };

      render::draw_font(
        font,
        *input,
        textPosition,
        textScale,
        spacing,
        1,
      );
    }
  }
}

