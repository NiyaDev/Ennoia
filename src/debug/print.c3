
module ennoia::debug;
import ennoia;
import std::io;
import std::thread;


bool printing = false;

<* Print line into console and file *>
fn void println(String format, args...) {
  io::printfn(format, ...args);
  // Write to file
}

<* For program ending errors *>
fn void fatal(String err, args...) @export("debug_fatal") {
  while (printing) thread::sleep_ms(1);

  printing = true;
  io::print("[");
  io::print("FATAL".color({230, 41, 55, 255}));
  io::print("] - ");
  io::printfn(err, args);
  printing = false;
  
  // End game
  ennoia::forceClose = true;
}
<* For serious errors *>
fn void error(String err, args...) @export("debug_error") {
  while (printing) thread::sleep_ms(1);

  printing = true;
  io::print("[");
  io::print("ERROR".color({230, 41, 55, 255}));
  io::print("] - ");
  io::printfn(err, args);
  printing = false;
}
<* For warnings *>
fn void warning(String err, args...) @export("debug_warning") {
  while (printing) thread::sleep_ms(1);

  printing = true;
  io::print("[");
  io::print("WARNING".color(color::ORANGE));
  io::print("] - ");
  io::printfn(err, args);
  printing = false;
}
<* For info *>
fn void info(String err, args...) @export("debug_info") {
  while (printing) thread::sleep_ms(1);

  printing = true;
  io::print("[");
  io::print("INFO".color(color::GRAY));
  io::print("] - ");
  io::printfn(err, args);
  printing = false;
}


