
module ennoia::console;
import ennoia::color;
import std::io;


<**>
fn void print_color(String text, Color color) {
  io::printf("\e[%d;%d;%d;249m%s\e[0m", color.r, color.g, color.b, text);
}

