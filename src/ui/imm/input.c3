
module ennoia::ui::imm;
import ennoia::color;
import ennoia::keybinds;
import ennoia::font;
import ennoia::rectangle;
import ennoia::render;
import ennoia::texture;
import ennoia::vector;
import std::io;


enum CharRules {
  ALPHA,
  NUMERIC,
  ALPHANUMERIC,
}

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
  String illegalChars = "",
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
      char c = dat.check_key(illegalChars);
      if (index != input.len && (dat.down && !dat.repeat) && c != '\0') (*input)[index] = c;
    }
  }

  // Draw text
  if (font != "") {
    Font? f = ennoia::fonts.get(font);
    if (try f) {
      float xOffset = 5;
      float yOffset = ((f.dim.y + spacing.y) / 2) * textScale.y;
      Vec2f textPosition = {
        bounds.x + xOffset,
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

<* Checks whether input Key is a valid character *>
fn char KeyData.check_key(&self, String illegalChars = "") {
  char output;
  if (self.key >= 0x20 && self.key < 0x7F) {
    output = (char)self.key;

    // Check for shift
    if (self.mod == 1 || self.mod == 2) {
      // Capitalize if shifted
      if ((self.key >= 0x61 && self.key <= 0x7A)) output -= 0x20;

      switch (output) {
        case '1': output = '!';
        case '2': output = '@';
        case '3': output = '#';
        case '4': output = '$';
        case '5': output = '%';
        case '6': output = '^';
        case '7': output = '&';
        case '8': output = '*';
        case '9': output = '(';
        case '0': output = ')';
        case '-': output = '_';
        case '=': output = '+';
        case '`': output = '~';
        case '[': output = '{';
        case ']': output = '}';
        case '\\': output = '|';
        case ';': output = ':';
        case '\'': output = '"';
        case ',': output = '<';
        case '.': output = '>';
        case '/': output = '?';
      }

    }

    // Check for illegal characters
    for (int i; i < illegalChars.len; i++) {
      if (self.key == illegalChars[i]) return '\0';
    }
  }

  return output;
}

