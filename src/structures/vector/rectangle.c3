
module ennoia::rectangle;
import ennoia::vector;
import std::io;


union Rectangle {
  struct { float x, y, w, h; }
  float[<4>] f;
}


<* == Overload *>
fn bool Rectangle.equals(self, Rectangle rhs) @operator(==) @export("rect_equals") {
  return (self.x == rhs.x && self.y == rhs.y && self.w == rhs.w && self.h == rhs.h);
}
<* + Overload *>
fn Rectangle Rectangle.add(self, Rectangle rhs) @operator(+) @export("rect_add") {
  return {
    self.x + rhs.x,
    self.y + rhs.y,
    self.w + rhs.w,
    self.h + rhs.h,
  };
}
<* + Overload with vector2 *>
fn Rectangle Rectangle.add_v2(self, Vec2f rhs) @operator_s(+) @export("rect_addv2") {
  return {
    self.x + rhs.x,
    self.y + rhs.y,
    self.w,
    self.h,
  };
}
<* + Overload with vector4 *>
fn Rectangle Rectangle.add_v4(self, Vec4f rhs) @operator_s(+) @export("rect_addv4") {
  return {
    self.x + rhs.x,
    self.y + rhs.y,
    self.w - rhs.z,
    self.h - rhs.w,
  };
}
<* - Overload *>
fn Rectangle Rectangle.sub(self, Rectangle rhs) @operator(-) @export("rect_sub") {
  return {
    self.x - rhs.x,
    self.y - rhs.y,
    self.w - rhs.w,
    self.h - rhs.h,
  };
}
<* - Overload with vector2 *>
fn Rectangle Rectangle.sub_v2(self, Vec2f rhs) @operator_s(-) @export("rect_subv2") {
  return {
    self.x - rhs.x,
    self.y - rhs.y,
    self.w,
    self.h,
  };
}
<* * Overload *>
fn Rectangle Rectangle.mul(self, Rectangle rhs) @operator(*) @export("rect_mul") {
  return {
    self.x * rhs.x,
    self.y * rhs.y,
    self.w * rhs.w,
    self.h * rhs.h,
  };
}
<* * Overload with vector2 *>
fn Rectangle Rectangle.mul_v2(self, Vec2f rhs) @operator_s(*) @export("rect_mulv2") {
  return {
    self.x * rhs.x,
    self.y * rhs.y,
    self.w * rhs.x,
    self.h * rhs.y,
  };
}
<* / Overload *>
fn Rectangle Rectangle.div(self, Rectangle rhs) @operator(/) @export("rect_div") {
  return {
    self.x / rhs.x,
    self.y / rhs.y,
    self.w / rhs.w,
    self.h / rhs.h,
  };
}
<* / Overload with vector2 *>
fn Rectangle Rectangle.div_v2(self, Vec2f rhs) @operator_s(/) @export("rect_divv2") {
  return {
    self.x / rhs.x,
    self.y / rhs.y,
    self.w / rhs.x,
    self.h / rhs.y,
  };
}

<* Converts rectangle to a Vector2 *>
fn Vec2f Rectangle.v2(self) @export("rect_v2") {
  return {
    self.x,
    self.y,
  };
}
<* Converts rectangle to a Vector2 *>
fn Vec4f Rectangle.v4(self) @export("rect_v4") {
  return {
    self.x,
    self.y,
    self.w,
    self.h,
  };
}


<* Returns whether Vector2 is within rectangle *>
fn bool Rectangle.within(&self, Vec2f rhs) @export("rect_within") {
  return ((rhs.x >= self.x && rhs.x <= self.x + self.w) && (rhs.y >= self.y && rhs.y <= self.y + self.h));
}

<* Prints info on rectangle *>
fn void Rectangle.print(&self) {
  io::printfn("[X: %f, Y: %f, Width: %f, Height: %f]",self.x,self.y,self.w,self.h);
}

