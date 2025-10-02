
import ennoia::color;
import ennoia::vector;
import std::io;


fn void overloads() @test {
  Color color = color::PURPLE;

  assert(color == {200, 122, 255, 255}, "Equivalent failed.");
  assert(color * 10 == {208,196,246,246}, "Multiplication failed. [%s]", color * 10);
}

fn void conversions() @test {
  Color color = color::ORANGE;

  // Hex
  uint hex = color.to_int();
  assert(hex == 0xFFA100FF, "Failed to convert to hexadecimal.");
  assert(color == hex.to_color(), "Failed to convert hex to Color.");

  // HSV
  Vec3f hsv = color.to_hsv();
  assert(hsv == {37.8828125, 1, 1}, "Failed to convert to HSV.");
  assert(hsv.color() == color, "Failed to convert hsv to color.");

  // Normalize
  Vec4f norm = color.normalize();
  assert(norm == {1, 0.631372549019, 0, 1}, "Failed to normalize.");
}

fn void changes() @test {
  Color color = color::YELLOW; // FDF900FF / {253, 249, 0, 255}

  assert(color.fade(0.5) == {253, 249, 0, 127}, "Failed to Fade.");
  assert(color.tint(color::LIGHTGRAY) == {198,195,0,255}, "Failed to tint color.");
  assert(color.brightness(-0.25) == {189,186,0,255}, "Failed to change brightness.");
  assert(color.contrast(-0.25) == {198,195,55,255}, "Failed to change contrast.");
  assert(color.alpha(0.5) == {253,249,0,127}, "Failed to set alpha.");
}

