
module ennoia::render;
import ennoia::color;
import ennoia::font;
import ennoia::localization;
import ennoia::rectangle;
import ennoia::texture;
import ennoia::vector;
import std::collections;
import std::io;


<* Sends model info to renderpipline for rendering *>
fn void draw_mesh(
  String nameMesh = "cube",
  String nameTexture = "",
  Vec3f position = {},
  Vec3f scale = {1,1,1},
  Vec3f rotation = {},
) @export("render_mesh") {
  rp3.push({nameMesh, nameTexture, position, scale, rotation});
}

<* Sends texture info to renderpipeline for rendering *>
fn void draw_texture(
  String nameTexture = "texture",
  Rectangle dst = {0,0,-1,-1},
  Rectangle src = {0,0,-1,-1},
  //Vector3 rotation = {},
  Color tint = color::WHITE,
  int priority = 1,
) @export("render_texture") {
  rp2.push({nameTexture, dst, src, tint, priority});
}
<* Sends texture info for tiled textures *>
fn void draw_texture_tiled(
  String nameTexture = "texture",
  Rectangle dst = {0,0,-1,-1},
  Vec2f scale = {1,1},
  TilingLayout layout = THREE_THREE,
  Color tint = color::WHITE,
  int priority = 1,
) @export("render_texture_tiled") {
  switch (layout) {
    case THREE_THREE:
      Texture textureRef = ennoia::textures[nameTexture]!!;

      float width  = (float)textureRef.width/3;
      float height = (float)textureRef.height/3;

      // Get src for each tile
      Rectangle topleft  = {0,       0,        width, height};
      Rectangle top      = {width,   0,        width, height};
      Rectangle topright = {width*2, 0,        width, height};
      Rectangle midleft  = {0,       height,   width, height};
      Rectangle mid      = {width,   height,   width, height};
      Rectangle midright = {width*2, height,   width, height};
      Rectangle botleft  = {0,       height*2, width, height};
      Rectangle bot      = {width  , height*2, width, height};
      Rectangle botright = {width*2, height*2, width, height};

      // Calculate dst
      dst = {
        dst.x, dst.y,
        (dst.w > 0 ? dst.w : width*3),
        (dst.h > 0 ? dst.h : height*3),
      };
      Vec2f dstSize = {
        width  * scale.x,
        height * scale.y,
      };
      Vec2f numberOfTiles = {
        (dst.w / dstSize.x)-1,
        (dst.h / dstSize.y)-1,
      };

      //*
      // Top
      rp2.push({
        nameTexture,
        {dst.x, dst.y, dstSize.x, dstSize.y},
        topleft,
        tint,
        priority,
      });
      for (int i = 1; i < numberOfTiles.x; i++) {
        rp2.push({
          nameTexture,
          {dst.x+(dstSize.x*i), dst.y, dstSize.x, dstSize.y},
          top,
          tint,
          priority,
        });
      }
      rp2.push({
        nameTexture,
        {dst.x+(dstSize.x*(numberOfTiles.x)), dst.y, dstSize.x, dstSize.y},
        topright,
        tint,
        priority,
      });
      
      // Middle
      for (int j = 1; j < numberOfTiles.y; j++) {
        rp2.push({
          nameTexture,
          {dst.x, dst.y+(dstSize.y*j), dstSize.x, dstSize.y},
          midleft,
          tint,
          priority,
        });
        for (int i = 1; i < numberOfTiles.x; i++) {
          rp2.push({
            nameTexture,
            {dst.x+(dstSize.x*i), dst.y+(dstSize.y*j), dstSize.x, dstSize.y},
            mid,
            tint,
            priority,
          });
        }
        rp2.push({
          nameTexture,
          {dst.x+(dstSize.x*(numberOfTiles.x)), dst.y+(dstSize.y*j), dstSize.x, dstSize.y},
          midright,
          tint,
          priority,
        });
      }
      
      // Bottom
      //*
      rp2.push({
        nameTexture,
        {dst.x, dst.y+(dstSize.y*(numberOfTiles.y)), dstSize.x, dstSize.y},
        botleft,
        tint,
        priority,
      });
      for (int i = 1; i < numberOfTiles.x; i++) {
        rp2.push({
          nameTexture,
          {dst.x+(dstSize.x*i), dst.y+(dstSize.y*(numberOfTiles.y)), dstSize.x, dstSize.y},
          bot,
          tint,
          priority,
        });
      }
      rp2.push({
        nameTexture,
        {dst.x+(dstSize.x*(numberOfTiles.x)), dst.y+(dstSize.y*(numberOfTiles.y)), dstSize.x, dstSize.y},
        botright,
        tint,
        priority,
      });
    case THREE_ONE:
    case ONE_THREE:
  }
}

<* Sends texture info for tiled textures *>
fn void draw_font(
  String nameFont,
  String textIn,
  Vec2f position = {0,0},
  Vec2f scale = {1,1},
  Vec2f spacing = {0,0},
  int priority = 1,
) {
  Font* font = ennoia::fonts.get_ref(nameFont)!!;
  String text = textIn;
  Color col = color::WHITE;

  float char_x = 0;
  float char_y = 0;
  for (int i; i < text.len; i++) {
    // Check for null characters
    if (text[i] == '\0') {
      continue;
    }
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
    // Check for tags
    if (text[i] == '<') {
      switch (text[i+1]) {
        case 'c': // Color
          i += 3;
          col = text.break_into_color(&i);
        default:
      }
      // Check for ending tags
      if (text[i+1] == '/') {
        switch (text[i+2]) {
          case 'c': // Color
            col = color::WHITE;
            i += 3;
            continue;
          default:
        }
      }
    }
    Vec2f space;
    if (char_x > 0) space.x = ((spacing.x * scale.x) * char_x);
    if (char_y > 0) space.y = ((spacing.y * scale.y) * char_y);
    render::draw_texture(
      nameFont,
      dst: {
        position.x + (char_x * (font.dim.x * scale.x) / 1) + space.x,
        position.y + (char_y * (font.dim.y * scale.y) / 1) + space.y,
        font.dim.x * scale.x,
        font.dim.y * scale.y,
      },
      src: font.rects[text[i]]!!,
      tint: col,
      priority: priority,
    );
    char_x++;
  }

}

<* Breaks string at index up into Color *>
fn Color String.break_into_color(self, int* index) {
  Color output;

  for (int i; i < 4; i++) {
    int count;
    for (int j = *index; j < self.len; j++) {
      if (self[j] != ',' && self[j] != '>') {
        count++;
        continue;
      }
      break;
    }
    output[i] = self[*index:count].to_uchar()!!;
    *index += count + 1;
  }

  return output;
}

