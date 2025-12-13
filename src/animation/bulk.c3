
module ennoia::bulk;
import ennoia;


<**>
fn AnimatedTexture load_animation(String filepath, String dataname) {
  char[] data = bulk::load(filepath, dataname);
  defer free(data);
  usz index;
  
  AnimatedTexture output;

  // Textures
  output.textures.init(mem);
  uint texLen;
  mem::copy(&texLen, (char*)data + index, uint.sizeof);
  index += uint.sizeof;
  for (int i; i < texLen; i++) {
    uint textureLength;
    mem::copy(&textureLength, (char*)data + index, uint.sizeof);
    index += uint.sizeof;

    Texture tex = texture::load_from_mem(data[index:textureLength]);
    output.texture.push(tex);
    String fmt = string::tformat("%s_%s",filepath,dataname);
    ennoia::textures.set(fmt, tex);

    index += textureLength;
  }

  // Frames
  uint framesLen;
  mem::copy(&framesLen, (char*)data + index, uint.sizeof);
  index += uint.sizeof;
  for (int i; i < framesLen; i++) {
    TextureFrame frame;
    mem::copy(&frame.textureid, (char*)data + index, uint.sizeof);
    index += uint.sizeof;
    mem::copy(&frame.animationid, (char*)data + index, uint.sizeof);
    index += uint.sizeof;

    output.frames.push(frame);
  }

  // Animations
  uint aniLen;
  mem::copy(&anilen, (char*)data + index, uint.sizeof);
  index += uint.sizeof;
  for (int i; i < aniLen; i++) {
    Animation animation;
    mem::copy(&animation.type, (char*)data + index, AnimationType.sizeof);
    index += AnimationType.sizeof;

    mem::copy(&animation.timeLeft, (char*)data + index, uint.sizeof);
    index += uint.sizeof;

    switch (type) {
      //case :
      default:
    }
  }

  mem::copy(&output.maxCount, (char*)data + index, uint.sizeof);

  return output;
}

