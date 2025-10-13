
module ennoia::ui;
import ennoia;


struct UIBar {
  UILabel label;
  UITexture fg;
  UITexture bg;

  float* value;
  float* max;
}

<* Creates a new Bar *>
fn UIBar bar(
  String text = "",
  String font = "font",
  Vec2f txScale = {1,1},
  Vec2f spacing = {0,0},

  String texture   = "texture",
  String textureBG = "",
  String textureFG = "",
  Color[2] tints = {color::WHITE, color::GREEN},
  
  Rectangle bounds = {0,0,-1,-1},
  Vec2f teScale = {1,1},

  float* value = null,
  float* max   = null,
) {
  return {
    ui::label(text, font, CENTER, CENTER, {0,0}, txScale, spacing),

    ui::texture(textureFG != "" ? textureFG : texture, true, tints[1], bounds, teScale),
    ui::texture(textureBG != "" ? textureBG : texture, true, tints[0], bounds, teScale),

    value,
    max,
  };
}

<* Draw UI Bar*>
fn void UIBar.draw(&self, Vec2f posOffset = {0,0}, Vec2f scaleMulti = {1,1}) {
  // Update size of FG
  self.fg.bounds.w = self.bg.bounds.w * (*self.value / *self.max);

  // Draw
  self.bg.draw(posOffset, scaleMulti);
  self.fg.draw(posOffset, scaleMulti);
  self.label.draw(posOffset, scaleMulti);
}

