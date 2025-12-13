
module ennoia::animation;
import std::collections;
import ennoia;


struct AnimatedTexture {
  List{Texture} textures;
  List{TextureFrame} frames;
  List{Animation} animation;

  uint count;
  uint maxCount;
}

struct TextureFrame {
  uint textureid;
  uint animationid;
}


<**>
fn void? AnimatedTexture.draw(&self) {
  
}

