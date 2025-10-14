
module ennoia::ui;


enum TextAlignmentHori {
  LEFT,
  CENTER,
  RIGHT,
}

enum TextAlignmentVert {
  TOP,
  CENTER,
  BOTTOM,
}

enum UIElementType {
  LABEL,
  TEXTURE,
  BUTTON,
  BAR,
  CONTAINER,
}
struct UIElement {
  UIElementType type;
  union {
    UILabel label;
    UITexture texture;
    UIButton button;
    UIBar bar;
    UIContainer cont;
  }
}

