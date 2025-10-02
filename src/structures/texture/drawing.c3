
module ennoia::texture;
import ennoia::color;
import ennoia::rectangle;
import ennoia::vector;


<* Draw texture to screen
  @param dst: "Area of screen to draw texture"
  @param src: "Area of the texture to draw"
  @param tint: "Color to tint texture"
 *>
fn void Texture.draw(&self, Rectangle dst = {0,0,-1,-1}, Rectangle src = {0,0,-1,-1}, Color tint = color::WHITE) @export("texture_draw") {
  // Calculating size on screen
  Vec2f newSize = {dst.w, dst.h};
  if (dst.w <= 0) newSize.x = (float)self.width;
  if (dst.h <= 0) newSize.y = (float)self.height;
  Vec2f scale = {
    newSize.x / (float)ennoia::renWidth,
    newSize.y / (float)ennoia::renHeight,
  };

  // Change texcoords
  Rectangle newSrc = src;
  if (src.w <= 0) newSrc.w = (float)self.width;
  if (src.h <= 0) newSrc.h = (float)self.height;
  Vec2f topLeft  = {newSrc.x  / (float)self.width,                                   1 - (newSrc.y  / (float)self.height)};
  Vec2f topRight = {(newSrc.x / (float)self.width) + (newSrc.w / (float)self.width), 1 - (newSrc.y  / (float)self.height)};
  Vec2f botLeft  = {newSrc.x  / (float)self.width,                                   1 - ((newSrc.y / (float)self.height) + (newSrc.h / (float)self.height))};
  Vec2f botRight = {(newSrc.x / (float)self.width) + (newSrc.w / (float)self.width), 1 - ((newSrc.y / (float)self.height) + (newSrc.h / (float)self.height))}; 
  ennoia::textureMesh.update_texcoords({topLeft, botLeft, botRight, topLeft, botRight, topRight});

  // Calculating position on screen
  Vec2f pos = {
    -(float)ennoia::renWidth  + (dst.x * 2) + newSize.x,
    -(float)ennoia::renHeight + (dst.y * 2) + newSize.y,
  };

  // Color
  Vec4f col = tint.normalize();
  ennoia::textureMesh.update_colors({col,col,col,col,col,col});

  // Draw
  ennoia::textureMesh.draw_2d(position:pos,scale:scale,texture:self);
  //ennoia::textureMesh.draw_2d_instanced({pos}, {scale}, {{topLeft, botLeft, botRight, topLeft, botRight, topRight}}, self);

  // Reset TexCoords
  ennoia::textureMesh.update_texcoords({{0,1}, {0,0}, {1,0}, {0,1}, {1,0}, {1,1}});
  ennoia::textureMesh.update_colors({{1,1,1,1}, {1,1,1,1}, {1,1,1,1}, {1,1,1,1}, {1,1,1,1}, {1,1,1,1}});
}
<* Draws multiple instances of the same texture
  @param dst: "Array of all locations on screen to draw texture"
  @param src: "Array of all sections of a texture to draw"
  @require dst.len == src.len
 *>
fn void Texture.draw_instanced(&self, Rectangle[] dst, Rectangle[] src, Color[] tint) {
  // Allocates memory for input
  Vec2f[] position     = mem::new_array(Vec2f, dst.len);
  Vec2f[] scale        = mem::new_array(Vec2f, dst.len);
  Vec4f[] texcoords    = mem::new_array(Vec4f, dst.len);

  for (int i; i < dst.len; i++) {
    // Calculating size on screen
    Vec2f newSize = {dst[i].w, dst[i].h};
    if (dst[i].w <= 0) newSize.x = (float)self.width;
    if (dst[i].h <= 0) newSize.y = (float)self.height;
    Vec2f sc = {
      newSize.x / (float)ennoia::renWidth,
      newSize.y / (float)ennoia::renHeight,
    };

    // Change texcoords
    Rectangle newSrc = src[i];
    if (src[i].w <= 0) newSrc.w = (float)self.width;
    if (src[i].h <= 0) newSrc.h = (float)self.height;
    Vec2f topLeft  = {newSrc.x  / (float)self.width,                                   1 - (newSrc.y  / (float)self.height)};
    Vec2f topRight = {(newSrc.x / (float)self.width) + (newSrc.w / (float)self.width), 1 - (newSrc.y  / (float)self.height)};
    Vec2f botLeft  = {newSrc.x  / (float)self.width,                                   1 - ((newSrc.y / (float)self.height) + (newSrc.h / (float)self.height))};
    Vec2f botRight = {(newSrc.x / (float)self.width) + (newSrc.w / (float)self.width), 1 - ((newSrc.y / (float)self.height) + (newSrc.h / (float)self.height))};
    
    // Calculating position on screen
    Vec2f pos = {
      -(float)ennoia::renWidth  + (dst[i].x * 2) + newSize.x,
      -(float)ennoia::renHeight + (dst[i].y * 2) + newSize.y,
    };

    // save all
    position[i]  = pos;
    scale[i]     = sc;
    texcoords[i] = {newSrc.x / self.width, newSrc.y / self.height, newSrc.w / self.width, newSrc.h / self.height};
  }
  
  // Color
  //Vector4 col = color::WHITE.normalize();
  //ennoia::textureMesh.update_colors({col,col,col,col,col,col});

  // Draw
  ennoia::textureMesh.draw_2d_instanced(position, scale, texcoords, tint, self);

  // Free memory
  free(position);
  free(scale);
  free(texcoords);
}

