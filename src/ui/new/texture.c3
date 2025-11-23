
module ennoia::ui;
import ennoia::color;
import ennoia::rectangle;
import ennoia::render;
import ennoia::texture;
import ennoia::vector;
import ennoia::debug;


struct UITexture {
  String texture;
  bool tiled;
  Color tint;

  Rectangle bounds;
  Vec2f scale;
}

<* Create new UI texture *>
fn UITexture texture(
  String texture = "texture",
  bool tiled = false,
  Color tint = color::WHITE,
  Rectangle bounds = {0,0,-1,-1},
  Vec2f scale = {1,1},
) @export("hui_texturenew") {
  return {
    texture,
    tiled,
    tint,

    bounds,
    scale,
  };
}

<* Draw UI texture *>
fn void UITexture.draw(&self, Vec2f posOffset = {0,0}, Vec2f scaleMulti = {1,1}) @export("hui_texturedraw") {
  Texture? texture = ennoia::textures.get(self.texture);
  if (catch texture) {
    debug::warning("Attempted to draw using Texture [%s] that doesn't exist.", self.texture);
    self.texture = "texture";
  }

  if (self.tiled) {
    render::draw_texture_tiled(
      self.texture,
      self.bounds + (Rectangle){posOffset.x, posOffset.y, scaleMulti.x, scaleMulti.y},
      self.scale * scaleMulti,
      THREE_THREE,
      self.tint,
      2,
    );
  } else {
    render::draw_texture(
      self.texture,
      self.bounds + (Rectangle){posOffset.x, posOffset.y, scaleMulti.x, scaleMulti.y},
      {0,0,-1,-1}, // TODO:
      self.tint,
      2,
    );
  }
}

