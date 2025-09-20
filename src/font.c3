
module ennoia::font;
import ennoia::color;
import ennoia::localization;
import ennoia::rectangle;
import ennoia::texture;
import ennoia::vector;
import std::io;
import std::collections;


struct Font {
  Texture atlas;
  Vector2 dim;
  HashMap{char, Rectangle} rects;
}

<* Loads font from file *>
fn Font load(String filename, Vector2 size) @export("font_load") {
  Font output;
  output.atlas = texture::load(filename);
  output.dim = size;

  float x = size.x;
  float y = size.y;

  // Lowercase
  output.rects.set('a', {x *  0, 0, x, y});
  output.rects.set('b', {x *  1, 0, x, y});
  output.rects.set('c', {x *  2, 0, x, y});
  output.rects.set('d', {x *  3, 0, x, y});
  output.rects.set('e', {x *  4, 0, x, y});
  output.rects.set('f', {x *  5, 0, x, y});
  output.rects.set('g', {x *  6, 0, x, y});
  output.rects.set('h', {x *  7, 0, x, y});
  output.rects.set('i', {x *  8, 0, x, y});
  output.rects.set('j', {x *  9, 0, x, y});
  output.rects.set('k', {x * 10, 0, x, y});
  output.rects.set('l', {x * 11, 0, x, y});
  output.rects.set('m', {x * 12, 0, x, y});
  output.rects.set('n', {x * 13, 0, x, y});
  output.rects.set('o', {x * 14, 0, x, y});
  output.rects.set('p', {x * 15, 0, x, y});
  output.rects.set('q', {x * 16, 0, x, y});
  output.rects.set('r', {x * 17, 0, x, y});
  output.rects.set('s', {x * 18, 0, x, y});
  output.rects.set('t', {x * 19, 0, x, y});
  output.rects.set('u', {x * 20, 0, x, y});
  output.rects.set('v', {x * 21, 0, x, y});
  output.rects.set('w', {x * 22, 0, x, y});
  output.rects.set('x', {x * 23, 0, x, y});
  output.rects.set('y', {x * 24, 0, x, y});
  output.rects.set('z', {x * 25, 0, x, y});
  // Uppercase
  output.rects.set('A', {x *  0, y, x, y});
  output.rects.set('B', {x *  1, y, x, y});
  output.rects.set('C', {x *  2, y, x, y});
  output.rects.set('D', {x *  3, y, x, y});
  output.rects.set('E', {x *  4, y, x, y});
  output.rects.set('F', {x *  5, y, x, y});
  output.rects.set('G', {x *  6, y, x, y});
  output.rects.set('H', {x *  7, y, x, y});
  output.rects.set('I', {x *  8, y, x, y});
  output.rects.set('J', {x *  9, y, x, y});
  output.rects.set('K', {x * 10, y, x, y});
  output.rects.set('L', {x * 11, y, x, y});
  output.rects.set('M', {x * 12, y, x, y});
  output.rects.set('N', {x * 13, y, x, y});
  output.rects.set('O', {x * 14, y, x, y});
  output.rects.set('P', {x * 15, y, x, y});
  output.rects.set('Q', {x * 16, y, x, y});
  output.rects.set('R', {x * 17, y, x, y});
  output.rects.set('S', {x * 18, y, x, y});
  output.rects.set('T', {x * 19, y, x, y});
  output.rects.set('U', {x * 20, y, x, y});
  output.rects.set('V', {x * 21, y, x, y});
  output.rects.set('W', {x * 22, y, x, y});
  output.rects.set('X', {x * 23, y, x, y});
  output.rects.set('Y', {x * 24, y, x, y});
  output.rects.set('Z', {x * 25, y, x, y});
  // Other
  output.rects.set('!', {x *  0, y * 2, x, y});
  output.rects.set('@', {x *  1, y * 2, x, y});
  output.rects.set('#', {x *  2, y * 2, x, y});
  output.rects.set('$', {x *  3, y * 2, x, y});
  output.rects.set('%', {x *  4, y * 2, x, y});
  output.rects.set('^', {x *  5, y * 2, x, y});
  output.rects.set('&', {x *  6, y * 2, x, y});
  output.rects.set('*', {x *  7, y * 2, x, y});
  output.rects.set('(', {x *  8, y * 2, x, y});
  output.rects.set(')', {x *  9, y * 2, x, y});
  output.rects.set('-', {x * 10, y * 2, x, y});
  output.rects.set('_', {x * 11, y * 2, x, y});
  output.rects.set('=', {x * 12, y * 2, x, y});
  output.rects.set('+', {x * 13, y * 2, x, y});
  output.rects.set('[', {x * 14, y * 2, x, y});
  output.rects.set(']', {x * 15, y * 2, x, y});
  output.rects.set('{', {x * 16, y * 2, x, y});
  output.rects.set('}', {x * 17, y * 2, x, y});
  output.rects.set('\\', {x * 18, y * 2, x, y});
  output.rects.set('|', {x * 19, y * 2, x, y});
  output.rects.set('`', {x * 20, y * 2, x, y});
  output.rects.set('~', {x * 21, y * 2, x, y});
  output.rects.set(';', {x * 22, y * 2, x, y});
  output.rects.set(':', {x * 23, y * 2, x, y});
  output.rects.set('\'', {x * 24, y * 2, x, y});
  output.rects.set('\"', {x * 25, y * 2, x, y});

  output.rects.set(',', {x *  0, y * 3, x, y});
  output.rects.set('.', {x *  1, y * 3, x, y});
  output.rects.set('<', {x *  2, y * 3, x, y});
  output.rects.set('>', {x *  3, y * 3, x, y});
  output.rects.set('/', {x *  4, y * 3, x, y});
  output.rects.set('?', {x *  5, y * 3, x, y});

  output.rects.set('0', {x *  6, y * 3, x, y});
  output.rects.set('1', {x *  7, y * 3, x, y});
  output.rects.set('2', {x *  8, y * 3, x, y});
  output.rects.set('3', {x *  9, y * 3, x, y});
  output.rects.set('4', {x * 10, y * 3, x, y});
  output.rects.set('5', {x * 11, y * 3, x, y});
  output.rects.set('6', {x * 12, y * 3, x, y});
  output.rects.set('7', {x * 13, y * 3, x, y});
  output.rects.set('8', {x * 14, y * 3, x, y});
  output.rects.set('9', {x * 15, y * 3, x, y});

  return output;
}
<* Loads font from data *>
fn Font load_from_mem(char[] data, Vector2 size) @export("font_loadfrommem") {
  Font output;
  output.atlas = texture::load_from_mem(data);
  output.dim = size;

  float x = size.x;
  float y = size.y;

  // Lowercase
  output.rects.set('a', {x *  0, 0, x, y});
  output.rects.set('b', {x *  1, 0, x, y});
  output.rects.set('c', {x *  2, 0, x, y});
  output.rects.set('d', {x *  3, 0, x, y});
  output.rects.set('e', {x *  4, 0, x, y});
  output.rects.set('f', {x *  5, 0, x, y});
  output.rects.set('g', {x *  6, 0, x, y});
  output.rects.set('h', {x *  7, 0, x, y});
  output.rects.set('i', {x *  8, 0, x, y});
  output.rects.set('j', {x *  9, 0, x, y});
  output.rects.set('k', {x * 10, 0, x, y});
  output.rects.set('l', {x * 11, 0, x, y});
  output.rects.set('m', {x * 12, 0, x, y});
  output.rects.set('n', {x * 13, 0, x, y});
  output.rects.set('o', {x * 14, 0, x, y});
  output.rects.set('p', {x * 15, 0, x, y});
  output.rects.set('q', {x * 16, 0, x, y});
  output.rects.set('r', {x * 17, 0, x, y});
  output.rects.set('s', {x * 18, 0, x, y});
  output.rects.set('t', {x * 19, 0, x, y});
  output.rects.set('u', {x * 20, 0, x, y});
  output.rects.set('v', {x * 21, 0, x, y});
  output.rects.set('w', {x * 22, 0, x, y});
  output.rects.set('x', {x * 23, 0, x, y});
  output.rects.set('y', {x * 24, 0, x, y});
  output.rects.set('z', {x * 25, 0, x, y});
  // Uppercase
  output.rects.set('A', {x *  0, y, x, y});
  output.rects.set('B', {x *  1, y, x, y});
  output.rects.set('C', {x *  2, y, x, y});
  output.rects.set('D', {x *  3, y, x, y});
  output.rects.set('E', {x *  4, y, x, y});
  output.rects.set('F', {x *  5, y, x, y});
  output.rects.set('G', {x *  6, y, x, y});
  output.rects.set('H', {x *  7, y, x, y});
  output.rects.set('I', {x *  8, y, x, y});
  output.rects.set('J', {x *  9, y, x, y});
  output.rects.set('K', {x * 10, y, x, y});
  output.rects.set('L', {x * 11, y, x, y});
  output.rects.set('M', {x * 12, y, x, y});
  output.rects.set('N', {x * 13, y, x, y});
  output.rects.set('O', {x * 14, y, x, y});
  output.rects.set('P', {x * 15, y, x, y});
  output.rects.set('Q', {x * 16, y, x, y});
  output.rects.set('R', {x * 17, y, x, y});
  output.rects.set('S', {x * 18, y, x, y});
  output.rects.set('T', {x * 19, y, x, y});
  output.rects.set('U', {x * 20, y, x, y});
  output.rects.set('V', {x * 21, y, x, y});
  output.rects.set('W', {x * 22, y, x, y});
  output.rects.set('X', {x * 23, y, x, y});
  output.rects.set('Y', {x * 24, y, x, y});
  output.rects.set('Z', {x * 25, y, x, y});
  // Other
  output.rects.set('!', {x *  0, y * 2, x, y});
  output.rects.set('@', {x *  1, y * 2, x, y});
  output.rects.set('#', {x *  2, y * 2, x, y});
  output.rects.set('$', {x *  3, y * 2, x, y});
  output.rects.set('%', {x *  4, y * 2, x, y});
  output.rects.set('^', {x *  5, y * 2, x, y});
  output.rects.set('&', {x *  6, y * 2, x, y});
  output.rects.set('*', {x *  7, y * 2, x, y});
  output.rects.set('(', {x *  8, y * 2, x, y});
  output.rects.set(')', {x *  9, y * 2, x, y});
  output.rects.set('-', {x * 10, y * 2, x, y});
  output.rects.set('_', {x * 11, y * 2, x, y});
  output.rects.set('=', {x * 12, y * 2, x, y});
  output.rects.set('+', {x * 13, y * 2, x, y});
  output.rects.set('[', {x * 14, y * 2, x, y});
  output.rects.set(']', {x * 15, y * 2, x, y});
  output.rects.set('{', {x * 16, y * 2, x, y});
  output.rects.set('}', {x * 17, y * 2, x, y});
  output.rects.set('\\', {x * 18, y * 2, x, y});
  output.rects.set('|', {x * 19, y * 2, x, y});
  output.rects.set('`', {x * 20, y * 2, x, y});
  output.rects.set('~', {x * 21, y * 2, x, y});
  output.rects.set(';', {x * 22, y * 2, x, y});
  output.rects.set(':', {x * 23, y * 2, x, y});
  output.rects.set('\'', {x * 24, y * 2, x, y});
  output.rects.set('\"', {x * 25, y * 2, x, y});

  output.rects.set(',', {x *  0, y * 3, x, y});
  output.rects.set('.', {x *  1, y * 3, x, y});
  output.rects.set('<', {x *  2, y * 3, x, y});
  output.rects.set('>', {x *  3, y * 3, x, y});
  output.rects.set('/', {x *  4, y * 3, x, y});
  output.rects.set('?', {x *  5, y * 3, x, y});

  output.rects.set('0', {x *  6, y * 3, x, y});
  output.rects.set('1', {x *  7, y * 3, x, y});
  output.rects.set('2', {x *  8, y * 3, x, y});
  output.rects.set('3', {x *  9, y * 3, x, y});
  output.rects.set('4', {x * 10, y * 3, x, y});
  output.rects.set('5', {x * 11, y * 3, x, y});
  output.rects.set('6', {x * 12, y * 3, x, y});
  output.rects.set('7', {x * 13, y * 3, x, y});
  output.rects.set('8', {x * 14, y * 3, x, y});
  output.rects.set('9', {x * 15, y * 3, x, y});

  return output;
}
<* Cleans up font data *>
fn void Font.clean(&self) @export("font_clean") {
  self.atlas.clean();
  self.rects.free();
}

<* Draws font to screen
  @param textIn: "Text to draw in font"
  @require textIn != ""
  @param position: "Position on screen to draw"
  @param scale: "Multiplier to size of font"
  @require scale.x > 0.0
  @require scale.y > 0.0
  @param spacing: "Space inbetween chaarcters"
 *>
fn void Font.draw(&self, String textIn, Vector2 position = {0,0}, Vector2 scale = {1,1}, float spacing = 0, Color tint = color::WHITE) @export("font_draw") {
  String text = textIn;

  float char_x = 0;
  float char_y = 0;
  for (int i; i < text.len; i++) {
    // Checks for newline written out
    if (text[i] == '\\' && text[i+1] == 'n') {
      i++;
      char_x = 0;
      char_y++;
      continue;
    }
    // Checks for newline character
    if (text[i] == '\n') {
      char_x = 0;
      char_y++;
      continue;
    }
    // Checks for space
    if (text[i] == ' ') {
      char_x++;
      continue;
    }
    // Checks for localization
    if (text[i] == '@' && text[i+1] == '{') {
      i += 2;
      List{char} localName;
      for (int j; j < text.len - i; j++) {
        if (text[i+j] != '}') {
          localName.push(text[i+j]);
        } else {
          String local = (String)localName.to_tarray();
          String localReplace = string::tformat("@{%s}",local);
          if (localization::contains(local)) {
            text = text.treplace(localReplace, localization::get(local));
          }
          break;
        }
      }
      i -= 2;
    }
    Vector2 space;
    if (char_x > 0) space.x = ((spacing * scale.x) * char_x);
    if (char_y > 0) space.y = ((spacing * scale.y) * char_y);
    /*
    render::draw_texture(
      dst: {
        position.x + (char_x * (self.dim.x * scale.x) / 1) + space.x,
        position.y + (char_y * (self.dim.y * scale.y) / 1) + space.y,
        self.dim.x * scale.x,
        self.dim.y * scale.y,
      },
      src: self.rects[text[i]]!!,
    );
    */
    /*
    self.atlas.draw(
      dst:{
        position.x + (char_x * (self.dim.x * scale.x) / 1) + space.x,
        position.y + (char_y * (self.dim.y * scale.y) / 1) + space.y,
        self.dim.x * scale.x,
        self.dim.y * scale.y,
      },
      src:self.rects[text[i]]!!,
      tint: tint,
    );
    */
    char_x++;
  }
}

