
module ennoia::animation;
import std::collections;


struct AnimatedTexture {
  List{Texture} textures;
  List{TextureFrame} frames;
  List{Animation} animation;

  uint count;
  uint maxCount;
}

struct TextureFrame {
  uint textureid;
  uint 
}



