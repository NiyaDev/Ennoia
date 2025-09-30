
module ennoia::debug;
import std::io;


//<**>

<* Print line into console and file *>
fn void println(String format, args...) {
  io::printfn(format, ...args);
  // Write to file
}

<* Print Error *>
fn void error(String err, args...) {
  //io::print
}
//<* Print Warning *>



