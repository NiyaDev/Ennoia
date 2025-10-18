
module ennoia::ui;
import ennoia;
import std::collections;
import std::io;


enum UIContainerType {
  VERTICAL,
  HORIZONTAL,
  SQUARE,
}
struct UIContainer {
  UIContainerType type;
  Rectangle bounds;
  Vec4f padding;
  Vec2f slot;

  UITexture background;
  List{UIElement} elements;
}

<* Create new container *>
fn UIContainer container(
  UIContainerType type = VERTICAL,
  Rectangle bounds = {0,0,100,300},
  Vec4f padding = {5,5,5,5},
  Vec2f slot = {90,40},
  
  String texture = "",
  Color tint = color::WHITE,
  Vec2f scale = {1,1},
) @extern("hui_contnew") {
  return {
    type,
    bounds,
    padding,
    slot,

    ui::texture(texture, true, tint, bounds, scale),
    {},
  };
}

<* Draw container *>
fn void UIContainer.draw(&self, Vec2f posOffset = {0,0}, Vec2f scaleMulti = {1,1}) @extern("hui_contdraw") {
  // Draw background
  if (self.background.texture != "") {
    self.background.draw();
  }

  Vec2f posOffsetCont = self.bounds.f.xy;

  for (int i; i < self.elements.len(); i++) {
    UIElement e = self.elements[i];

    Rectangle slotPosition = {
      self.padding.x,
      self.padding.y,
      self.slot.x,
      self.slot.y,
    };

    switch (self.type) {
      case VERTICAL:
        slotPosition += posOffsetCont;
        posOffsetCont.y += slotPosition.h + self.padding.w;
        if (slotPosition.y+slotPosition.h > self.bounds.y+self.bounds.h) return;
        
      case HORIZONTAL:
      case SQUARE:
      default:
    }

    switch (e.type) {
      case LABEL:
        e.label.draw(posOffset + slotPosition.f.xy + {slotPosition.f.zw / 2}, scaleMulti);
      case TEXTURE:
        e.texture.bounds = slotPosition;
        e.texture.draw(posOffset, scaleMulti);
      case BUTTON:
        e.button.set_bounds(slotPosition);
        e.button.draw(posOffset, scaleMulti);
      case BAR:
        e.bar.set_bounds(slotPosition);
        e.bar.draw(posOffset, scaleMulti);
      case CONTAINER:
      default:
    }
  }
}

<* Push new element into container *>
fn void UIContainer.push(&self, any value) @extern("hui_contpush") {
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

