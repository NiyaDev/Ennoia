
module ennoia::ui;
import ennoia::font;
import ennoia::render;
import ennoia::vector;
import ennoia::debug;


struct UILabel {
  String text;
  String font;

  TextAlignmentHori alignHori;
  TextAlignmentVert alignVert;

  Vec2f position;
  Vec2f scale;
  Vec2f spacing;
}

<* Creates a new Label *>
fn UILabel label(
  String text = "NULL",
  String font = "font",
  TextAlignmentHori alignHori = LEFT,
  TextAlignmentVert alignVert = TOP,
  Vec2f position = {0,0},
  Vec2f scale = {1,1},
  Vec2f spacing = {0,0},
) {
  return {
    text,
    font,

    alignHori,
    alignVert,

    position,
    scale,
    spacing,
  };
}

<* Draws label *>
fn void UILabel.draw(&self, Vec2f posOffset = {0,0}, Vec2f scaleMulti = {1,1}) {
  Font? font = ennoia::fonts.get(self.font);
  if (catch font) {
    debug::warning(false,"Attempted to draw using Font [%s] that doesn't exist.", self.font);
    self.font = "font";
  }

  Vec2f newPos;

  // Set position x
  switch (self.alignHori) {
    case LEFT:
      newPos.x = self.position.x + posOffset.x;
    case CENTER:
      String[] splitText = self.text.tsplit("\n");
      int longest;
      for (int i; i < splitText.len; i++) {
        if (splitText[i].len > longest) longest = splitText[i].len;
      }
      newPos.x = self.position.x + posOffset.x - (((font!!.dim.x + self.spacing.x) * longest) / 2);
    case RIGHT:
      String[] splitText = self.text.tsplit("\n");
      int longest;
      for (int i; i < splitText.len; i++) {
        if (splitText[i].len > longest) longest = splitText[i].len;
      }
      newPos.x = self.position.x + posOffset.x - ((font!!.dim.x + self.spacing.x) * longest);
  }

  // Set position y
  switch (self.alignVert) {
    case TOP:
      newPos.y = self.position.y + posOffset.y;
    case CENTER:
      usz count = self.text.count("\n") + 1;
      newPos.y = self.position.y + posOffset.y - (((font!!.dim.y + self.spacing.y) * count) / 2);
    case BOTTOM:
      usz count = self.text.count("\n") + 1;
      newPos.y = self.position.y + posOffset.y - ((font!!.dim.y + self.spacing.y) * count);
  }
  
  render::draw_font(
    self.font,
    self.text,
    newPos,
    self.scale * scaleMulti,
    self.spacing,
    1,
  );
}

