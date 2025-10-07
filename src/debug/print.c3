
module ennoia::debug;
import ennoia;
import std::io;


//<**>

<* Print line into console and file *>
fn void println(String format, args...) {
  io::printfn(format, ...args);
  // Write to file
}

<* Print Error *>
fn void error(bool cond, String err, args...) @export("debug_error") {
  if (cond) return;

  io::print("[");
  io::print("ERROR".color({230, 41, 55, 255}));
  io::print("] - ");
  io::printfn(err, args);
  
  // End game
  ennoia::forceClose = true;
}
<* Print Warning *>
fn void warning(bool cond, String err, args...) @export("debug_warning") {
  if (cond) return;

  io::print("[");
  io::print("WARNING".color(color::ORANGE));
  io::print("] - ");
  io::printfn(err, args);
}
<* Print Info *>
fn void info(bool cond, String err, args...) @export("debug_info") {
  if (cond) return;

  io::print("[");
  io::print("INFO".color(color::GRAY));
  io::print("] - ");
  io::printfn(err, args);
}


