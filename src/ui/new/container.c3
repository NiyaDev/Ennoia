
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

  UITexture background;
  List{UIElement} elements;
}

<* Create new container *>
fn UIContainer container(
  UIContainerType type = VERTICAL,
  Rectangle bounds = {0,0,-1,-1},
  
  String texture = "texture",
  Color tint = color::WHITE,
  Vec2f scale = {1,1},
) {
  return {
    type,
    bounds,

    ui::texture(texture, true, tint, bounds, scale),
    {},
  };
}

<* Draw container *>
fn void UIContainer.draw(&self) {}

<* Push new element into container *>
fn void UIContainer.push(&self, any value) {}

