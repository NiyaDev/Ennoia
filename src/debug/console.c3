
module ennoia::console;
import ennoia::color;
import std::io;


<**>
fn void print_color(String text, Color color) @export("console_printcolor") {
  io::printf("\e[38;2;%d;%d;%dm%s\e[0m", color.r, color.g, color.b, text);
}

<**>
fn String String.color(self, Color color) @export("console_textcolor") {
  return string::tformat("\e[38;2;%d;%d;%dm%s\e[0m", color.r, color.g, color.b, self);
}
