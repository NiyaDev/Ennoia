
module ennoia::ui;
import ennoia;


alias ButtonFunc = fn void();
struct UIButton {
  UILabel label;
  UITexture texture;

  Color[3] tints;
  ButtonFunc func;
}

<* Create a new button *>
fn UIButton button(
  String text = "",
  String font = "font",
  Vec2f txScale = {1,1},
  Vec2f spacing = {0,0},
  
  String texture = "texture",
  Color[3] tints = {color::WHITE,color::GRAY, color::DARKGRAY},
  Rectangle bounds = {0,0,-1,-1},
  Vec2f teScale = {1,1},

  ButtonFunc func = null,
) {
  return {
    ui::label(text:text, font:font, alignHori:CENTER, alignVert:CENTER, scale:txScale, spacing:spacing),
    ui::texture(texture:texture, tiled:true, bounds:bounds, scale:teScale),

    tints,
    func,
  };
}

<* Draws button *>
fn void UIButton.draw(&self, Vec2f posOffset = {0,0}, Vec2f scaleMulti = {1,1}) {
  // Select color to use on texture
  Color col = self.tints[0];
  bool within = self.texture.bounds.within(ennoia::mousePosition);
  if (within) {
    if (keybinds::mouse_down(1)) {
      col = self.tints[2];
    } else { col = self.tints[1]; }
  }

  // Draw texture
  self.texture.tint = col;
  self.texture.draw(posOffset, scaleMulti);

  // Draw label
  self.label.position = {self.texture.bounds.x + (self.texture.bounds.w / 2), self.texture.bounds.y + (self.texture.bounds.h / 2)};
  self.label.draw(posOffset, scaleMulti);

  if (keybinds::mouse_up(1) && self.func != null) self.func();
}

