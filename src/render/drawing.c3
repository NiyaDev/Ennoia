
module ennoia::render;
import ennoia::rectangle;
import ennoia::texture;
import ennoia::vector;


<* Sends model info to renderpipline for rendering *>
fn void draw_mesh(
  String nameMesh = "cube",
  String nameTexture = "",
  Vector3 position = {},
  Vector3 scale = {1,1,1},
  Vector3 rotation = {},
) @export("render_mesh") {
  rp3.push({nameMesh, nameTexture, position, scale, rotation});
}
<* Sends texture info to renderpipeline for rendering *>
fn void draw_texture(
  String nameTexture = "texture",
  Rectangle dst = {0,0,-1,-1},
  Rectangle src = {0,0,-1,-1},
  //Vector3 rotation = {},
  //Color tint = color::WHITE,
) @export("render_texture") {
  rp2.push({nameTexture, dst, src});
}
<* Sends texture info for tiled textures *>
fn void draw_texture_tiled(
  String nameTexture = "texture",
  Rectangle dst = {0,0,-1,-1},
  Vector2 scale = {1,1},
  TilingLayout layout = THREE_THREE,
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
      Vector2 dstSize = {
        width  * scale.x,
        height * scale.y,
      };
      Vector2 numberOfTiles = {
        dst.w / dstSize.x,
        dst.h / dstSize.y,
      };

      //*
      rp2.push({
        nameTexture,
        {dst.x, dst.y, dstSize.x, dstSize.y},
        topleft,
      });
      
      //*/
      /*
      for (int y; y < numberOfTiles.y; y++) {
        for (int x; x < numberOfTiles.x; x++) {
          Rectangle src = {0,0,width,height};
          if (x > 0 && x < numberOfTiles.x) src.x = width;
          if (x == numberOfTiles.x) src.x = width*2;
          if (y > 0 && y < numberOfTiles.y) src.y = height;
          if (y == numberOfTiles.y) src.y = height*2;

          rp2.push({
            nameTexture,
            dst + (Rectangle){x*dstSize.x, y*dstSize.y, dstSize.x, dstSize.y},
            src,
          });
        }
      }
      */
    case THREE_ONE:
    case ONE_THREE:
  }
}

