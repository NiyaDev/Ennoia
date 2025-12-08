
module bulk_packer;
import std::io;
import ennoia;


macro void? @err(#a, #b, #c) {
  if (catch excuse = #a) {
    io::print("- ");
    io::printfn(#b.color(color::RED), #c);
    return excuse?;
  }
}

