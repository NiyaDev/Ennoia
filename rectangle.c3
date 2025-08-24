
module ennoia::rectangle;
import ennoia::vector;


struct Rectangle {
  float x, y, w, h;
}


<* == Overload *>
fn bool Rectangle.equals(self, Rectangle rhs) @operator(==) {
  return (self.x == rhs.x && self.y == rhs.y && self.w == rhs.w && self.h == rhs.h);
}
<* + Overload *>
fn Rectangle Rectangle.add(self, Rectangle rhs) @operator(+) {
  return {
    self.x + rhs.x,
    self.y + rhs.y,
    self.w + rhs.w,
    self.h + rhs.h,
  };
}
<* + Overload with vector2 *>
fn Rectangle Rectangle.add_v2(self, Vector2 rhs) @operator_s(+) {
  return {
    self.x + rhs.x,
    self.y + rhs.y,
    self.w,
    self.h,
  };
}
<* + Overload with vector4 *>
fn Rectangle Rectangle.add_v4(self, Vector4 rhs) @operator_s(+) {
  return {
    self.x + rhs.x,
    self.y + rhs.y,
    self.w - rhs.z,
    self.h - rhs.w,
  };
}
<* - Overload *>
fn Rectangle Rectangle.sub(self, Rectangle rhs) @operator(-) {
  return {
    self.x - rhs.x,
    self.y - rhs.y,
    self.w - rhs.w,
    self.h - rhs.h,
  };
}
<* - Overload with vector2 *>
fn Rectangle Rectangle.sub_v2(self, Vector2 rhs) @operator_s(-) {
  return {
    self.x - rhs.x,
    self.y - rhs.y,
    self.w,
    self.h,
  };
}
<* * Overload *>
fn Rectangle Rectangle.mul(self, Rectangle rhs) @operator(*) {
  return {
    self.x * rhs.x,
    self.y * rhs.y,
    self.w * rhs.w,
    self.h * rhs.h,
  };
}
<* * Overload with vector2 *>
fn Rectangle Rectangle.mul_v2(self, Vector2 rhs) @operator_s(*) {
  return {
    self.x * rhs.x,
    self.y * rhs.y,
    self.w * rhs.x,
    self.h * rhs.y,
  };
}
<* / Overload *>
fn Rectangle Rectangle.div(self, Rectangle rhs) @operator(/) {
  return {
    self.x / rhs.x,
    self.y / rhs.y,
    self.w / rhs.w,
    self.h / rhs.h,
  };
}
<* / Overload with vector2 *>
fn Rectangle Rectangle.div_v2(self, Vector2 rhs) @operator_s(/) {
  return {
    self.x / rhs.x,
    self.y / rhs.y,
    self.w,
    self.h,
  };
}

<* Returns whether Vector2 is within rectangle *>
fn bool Rectangle.within(&self, Vector2 rhs) {
  return ((rhs.x >= self.x && rhs.x <= self.x + self.w) && (rhs.y >= self.y && rhs.y <= self.y + self.h));
}

