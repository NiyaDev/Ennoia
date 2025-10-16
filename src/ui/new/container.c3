
module ennoia::ui;
import ennoia;
import std::collections;


enum UIContainerType {
  VERTICAL,
  HORIZONTAL,
  SQUARE,
}
struct UIContainer {
  UIContainerType type;
  Rectangle bounds;
  Vec4f slot;

  UITexture background;
  List{UIElement} elements;
}

<* Create new container *>
fn UIContainer container(
  UIContainerType type = VERTICAL,
  Rectangle bounds = {0,0,-1,-1},
  Vec4f slot = {0,0,0,0},
  
  String texture = "",
  Color tint = color::WHITE,
  Vec2f scale = {1,1},
) {
  return {
    type,
    bounds,
    slot,

    ui::texture(texture, true, tint, bounds, scale),
    {},
  };
}

<* Draw container *>
fn void UIContainer.draw(&self, Vec2f posOffset = {0,0}, Vec2f scaleMulti = {1,1}) {
  // Draw background
  if (self.background.texture != "") {
    self.background.draw();
  }

  for (int i; i < self.elements.len(); i++) {
    UIElement e = self.elements[i];
    Vec2f pos = posOffset;

    Vec2f off;

    switch (self.type) {
      case VERTICAL:
        //off = {self.bounds.f.x + (self.bounds.w - self.slot.w)/2, self.bounds.f.y * ((float)i+1)};
      default:
    }
    switch (e.type) {
      case LABEL:
        e.label.draw(pos+off);
      case TEXTURE:
        //e.texture.bounds.f = self.slot + off;
        e.texture.draw(pos);
      case BUTTON:
        //e.button.set_bounds(self.slot + off);
        e.button.draw(pos);
      case BAR:
        e.bar.draw(pos);
      case CONTAINER:
        e.cont.draw(pos);
      default:
    }
  }
}

<* Push new element into container *>
fn void UIContainer.push(&self, any value) {
  UIElement ele;
  switch (value.type) {
    case UILabel:
      ele = {.type=LABEL, .label=*(UILabel*)value};
    case UITexture:
      ele = {.type=TEXTURE, .texture=*(UITexture*)value};
      //ele.texture.bounds = self.slot;
    case UIButton:
      ele = {.type=BUTTON, .button=*(UIButton*)value};
      //ele.button.set_bounds(self.slot);
    case UIBar:
      ele = {.type=BAR, .bar=*(UIBar*)value};
      //ele.bar.set_bounds(self.slot);
    case UIContainer:
      ele = {.type=CONTAINER, .cont=*(UIContainer*)value};
    default:
      debug::error(false, "Attempted to push a non-HUI element into a container.");
      return;
  }
  self.elements.push(ele);
}

