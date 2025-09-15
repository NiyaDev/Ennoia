
module ennoia::texture;
import ennoia::color;
import ennoia::rectangle;
import ennoia::vector;
import std::io;
import stb;
import gl;


struct Texture {
  uint id;
  uint width, height;
  int mipmaps;
  int format;
  bool transparency;
}
enum TilingLayout {
  THREE_THREE,
  ONE_THREE,
  THREE_ONE,
}


<* Loads image from file *>
fn Texture load(String filename) @export("texture_load") {
  Texture output;

  // Load data from file
  stb::stbi_set_flip_vertically_on_load(true);
  uint channels;
  char* data = stb::stbi_load(filename.zstr_tcopy(), &output.width, &output.height, &channels, 0);
  assert(data != null, "[ERROR] - ENNOIA::TEXTURE::LOAD [Failed to load image]");

  // Check if transparent
  for (int i = 3; i < (output.width * output.height) * 4; i += 4) {
    if (data[i] != 255) {
      output.transparency = true;
      break;
    }
  }

  // Gen OpenGL texture
  gl::gen_textures(1, &output.id);
  gl::bind_texture(gl::TEXTURE_2D, output.id);

  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MIN_FILTER, gl::NEAREST);
  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MAG_FILTER, gl::NEAREST);

  gl::tex_image_2d(gl::TEXTURE_2D, 0, gl::RGBA, output.width, output.height, 0, gl::RGBA, gl::UNSIGNED_BYTE, data);
  gl::generate_mipmap(gl::TEXTURE_2D);
  assert(output.id != 0, "[ERROR] - ENNOIA::TEXTURE::LOAD [Failed to bind texture]");

  // Cleanup
  stb::stbi_image_free(data);

  return output;
}
<* Load texture from memory *>
fn Texture load_from_mem(char[] data) @export("texture_loadfrommem") {
  Texture output;

  stb::stbi_set_flip_vertically_on_load(true);

  uint channels;
  char* img = stb::stbi_load_from_memory((char*)data, (uint)data.len, &output.width, &output.height, &channels, 0);
  assert(img != null, "[ERROR] - ENNOIA::TEXTURE::LOAD [Failed to load image]");

  gl::gen_textures(1, &output.id);
  gl::bind_texture(gl::TEXTURE_2D, output.id);

  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MIN_FILTER, gl::NEAREST);
  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MAG_FILTER, gl::NEAREST);

  gl::tex_image_2d(gl::TEXTURE_2D, 0, gl::RGBA, output.width, output.height, 0, gl::RGBA, gl::UNSIGNED_BYTE, img);
  gl::generate_mipmap(gl::TEXTURE_2D);
  assert(output.id != 0, "[ERROR] - ENNOIA::TEXTURE::LOAD [Failed to bind texture]");

  stb::stbi_image_free(img);

  return output;
}
<* Create a new blank texture
  @param width: "The width of the image"
  @require width > 0
  @param height: "The height of the image"
  @require height > 0
 *>
fn Texture new(int width, int height) @export("texture_new") {
  Texture output;

  gl::gen_textures(1, &output.id);
  gl::bind_texture(gl::TEXTURE_2D, output.id);
  gl::tex_image_2d(gl::TEXTURE_2D, 0, gl::RGB, width, height, 0, gl::RGB, gl::UNSIGNED_BYTE, null);
  
  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MIN_FILTER, gl::LINEAR);
  gl::tex_parameter_i(gl::TEXTURE_2D, gl::TEXTURE_MAG_FILTER, gl::LINEAR);

  return output;
}
<* Cleans up texture *>
fn void Texture.clean(&self) @export("texture_clean") {
  gl::delete_textures(1, &self.id);
}

<* Draw texture to screen
  @param dst: "Area of screen to draw texture"
  @param src: "Area of the texture to draw"
  @param tint: "Color to tint texture"
 *>
fn void Texture.draw(&self, Rectangle dst = {0,0,-1,-1}, Rectangle src = {0,0,-1,-1}, Color tint = color::WHITE) @export("texture_draw") {
  // Calculating size on screen
  Vector2 newSize = {dst.w, dst.h};
  if (dst.w <= 0) newSize.x = (float)self.width;
  if (dst.h <= 0) newSize.y = (float)self.height;
  Vector2 scale = {
    newSize.x / (float)ennoia::renWidth,
    newSize.y / (float)ennoia::renHeight,
  };

  // Change texcoords
  Rectangle newSrc = src;
  if (src.w <= 0) newSrc.w = (float)self.width;
  if (src.h <= 0) newSrc.h = (float)self.height;
  Vector2 topLeft  = {newSrc.x  / (float)self.width,                                   1 - (newSrc.y  / (float)self.height)};
  Vector2 topRight = {(newSrc.x / (float)self.width) + (newSrc.w / (float)self.width), 1 - (newSrc.y  / (float)self.height)};
  Vector2 botLeft  = {newSrc.x  / (float)self.width,                                   1 - ((newSrc.y / (float)self.height) + (newSrc.h / (float)self.height))};
  Vector2 botRight = {(newSrc.x / (float)self.width) + (newSrc.w / (float)self.width), 1 - ((newSrc.y / (float)self.height) + (newSrc.h / (float)self.height))}; 
  ennoia::textureMesh.update_texcoords({topLeft, botLeft, botRight, topLeft, botRight, topRight});

  // Calculating position on screen
  Vector2 pos = {
    -(float)ennoia::renWidth  + (dst.x * 2) + newSize.x,
    -(float)ennoia::renHeight + (dst.y * 2) + newSize.y,
  };

  // Color
  Vector4 col = tint.normalize();
  ennoia::textureMesh.update_colors({col,col,col,col,col,col});

  // Draw
  ennoia::textureMesh.draw_2d(position:pos,scale:scale,texture:self);
  //ennoia::textureMesh.draw_2d_instanced({pos}, {scale}, {{topLeft, botLeft, botRight, topLeft, botRight, topRight}}, self);

  // Reset TexCoords
  ennoia::textureMesh.update_texcoords({{0,1}, {0,0}, {1,0}, {0,1}, {1,0}, {1,1}});
  ennoia::textureMesh.update_colors({{1,1,1,1}, {1,1,1,1}, {1,1,1,1}, {1,1,1,1}, {1,1,1,1}, {1,1,1,1}});
}
<*
  @require dst.len == src.len
 *>
fn void Texture.draw_instanced(&self, Rectangle[] dst, Rectangle[] src) {
  Vector2[] position     = mem::new_array(Vector2, dst.len);
  Vector2[] scale        = mem::new_array(Vector2, dst.len);
  Vector2[6][] texcoords = mem::new_array(Vector2[6], dst.len);
  for (int i; i < dst.len; i++) {
    // Calculating size on screen
    Vector2 newSize = {dst[i].w, dst[i].h};
    if (dst[i].w <= 0) newSize.x = (float)self.width;
    if (dst[i].h <= 0) newSize.y = (float)self.height;
    Vector2 sc = {
      newSize.x / (float)ennoia::renWidth,
      newSize.y / (float)ennoia::renHeight,
    };

    // Change texcoords
    Rectangle newSrc = src[i];
    if (src[i].w <= 0) newSrc.w = (float)self.width;
    if (src[i].h <= 0) newSrc.h = (float)self.height;
    Vector2 topLeft  = {newSrc.x  / (float)self.width,                                   1 - (newSrc.y  / (float)self.height)};
    Vector2 topRight = {(newSrc.x / (float)self.width) + (newSrc.w / (float)self.width), 1 - (newSrc.y  / (float)self.height)};
    Vector2 botLeft  = {newSrc.x  / (float)self.width,                                   1 - ((newSrc.y / (float)self.height) + (newSrc.h / (float)self.height))};
    Vector2 botRight = {(newSrc.x / (float)self.width) + (newSrc.w / (float)self.width), 1 - ((newSrc.y / (float)self.height) + (newSrc.h / (float)self.height))};
    
    // Calculating position on screen
    Vector2 pos = {
      -(float)ennoia::renWidth  + (dst[i].x * 2) + newSize.x,
      -(float)ennoia::renHeight + (dst[i].y * 2) + newSize.y,
    };

    // save all
    position[i]  = pos;
    scale[i]     = sc;
    texcoords[i] = {topLeft, botLeft, botRight, topLeft, botRight, topRight};
  }
  
  // Color
  Vector4 col = color::WHITE.normalize();
  ennoia::textureMesh.update_colors({col,col,col,col,col,col});

  ennoia::textureMesh.draw_2d_instanced(position, scale, texcoords, self);

  ennoia::textureMesh.update_texcoords({{0,1}, {0,0}, {1,0}, {0,1}, {1,0}, {1,1}});
  ennoia::textureMesh.update_colors({{1,1,1,1}, {1,1,1,1}, {1,1,1,1}, {1,1,1,1}, {1,1,1,1}, {1,1,1,1}});

  free(position);
  free(scale);
  free(texcoords);
}

<* Draw tiled texture to screen
  @param dest: "Area of screen to draw texture"
  @param src: "Area of the texture to draw"
  @param layout: "Tiling layout"
 *>
fn void Texture.draw_tiled(
  &self,
  Rectangle dest = {0,0,-1,-1},
  Rectangle src = {0,0,-1,-1},
  TilingLayout layout = THREE_THREE,
  Color tint = color::WHITE,
) @export("texture_drawtiled") {
  // TODO: Add a vector2 for the size of each tile
  switch (layout) {
    case THREE_THREE:
      // Calculate sizes
      float width  = ((src.w <= 0) ? (float)self.width  / 3 : (float)src.w / 3);
      float height = ((src.h <= 0) ? (float)self.height / 3 : (float)src.h / 3);
      float middleWidth  = ((dest.w <= 0) ? (float)self.width  - (width  * 2) : (float)dest.w - (width  * 2));
      float middleHeight = ((dest.h <= 0) ? (float)self.height - (height * 2) : (float)dest.h - (height * 2));

      // Top row
      self.draw({dest.x, dest.y, width, height}, {0, 0, width, height}, tint);
      for (int i; i <= (usz)(middleWidth / width); i++) {
        self.draw({dest.x + (((float)i+1) * width), dest.y, width, height}, {width, 0, width, height}, tint);
      }
      self.draw({dest.x + middleWidth + width, dest.y, width, height}, {width*2, 0, width, height}, tint);
      
      // Middle row
      for (int y; y <= (usz)(middleHeight / height); y++) {
        self.draw({dest.x, dest.y + (((float)y+1) * height), width, height}, {0, height, width, height}, tint);
        for (int i; i <= (usz)(middleWidth / width); i++) {
          self.draw({dest.x + (((float)i+1) * width), dest.y + (((float)y+1) * height), width, height}, {width, height, width, height}, tint);
        }
        self.draw({dest.x + middleWidth + width, dest.y + (((float)y+1) * height), width, height}, {width*2, height, width, height}, tint);
      }

      // Draw bottom row
      self.draw({dest.x, dest.y + middleHeight + height, width, height}, {0, height*2, width, height}, tint);
      for (int i; i <= (usz)(middleWidth / width); i++) {
        self.draw({dest.x + (((float)i+1) * width), dest.y + middleHeight + height, width, height}, {width, height*2, width, height}, tint);
      }
      self.draw({dest.x + middleWidth + width, dest.y + middleHeight + height, width, height}, {width*2, height*2, width, height}, tint);
    case ONE_THREE:
      float dstWidth     = ((dest.w <= 0) ? (float)self.width      : (float)dest.w);
      float dstHeight    = ((dest.h <= 0) ? (float)self.height     : (float)dest.h);
      float dstHeightPer = dstWidth / 3;
      float srcWidth     = ((src.w  <= 0) ? (float)self.width      : (float)src.w);
      float srcHeight    = ((src.h  <= 0) ? (float)self.height / 3 : (float)src.h / 3);
      float middleCount  = (dstHeight - (dstHeightPer * 2)) / dstHeightPer;

      self.draw({dest.x, dest.y, dstWidth, dstHeightPer}, {0, 0, srcWidth, srcHeight}, tint);
      for (int y; y <= middleCount; y++) {
        self.draw({dest.x, dest.y + (((float)y+1) * dstHeightPer), dstWidth, dstHeightPer}, {0, srcHeight, srcWidth, srcHeight}, tint);
      }
      self.draw({dest.x, dest.y + (dstHeight - dstHeightPer), dstWidth, dstHeightPer}, {0, srcHeight*2, srcWidth, srcHeight}, tint);
    case THREE_ONE:
      float dstWidth    = ((dest.w <= 0) ? (float)self.width      : (float)dest.w);
      float dstHeight   = ((dest.h <= 0) ? (float)self.height     : (float)dest.h);
      float dstWidthPer = dstHeight / 3;
      float srcWidth    = ((src.w  <= 0) ? (float)self.width  / 3 : (float)src.w  / 3);
      float srcHeight   = ((src.h  <= 0) ? (float)self.height     : (float)src.h);
      float middleCount = (dstWidth - (dstWidthPer * 2)) / dstWidthPer;

      self.draw({dest.x, dest.y, dstWidthPer*3, dstHeight}, {0, 0, srcWidth, srcHeight}, tint);
      for (int i; i < middleCount.round(); i++) {
        self.draw({dest.x + (((float)i+1) * dstWidthPer), dest.y, dstWidthPer, dstHeight}, {srcWidth, 0, srcWidth, srcHeight}, tint);
      }
      self.draw({dest.x + (dstWidth - dstWidthPer), dest.y, dstWidthPer*3, dstHeight}, {srcWidth*2, 0, srcWidth, srcHeight}, tint);
  }
}


