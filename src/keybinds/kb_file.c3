
module ennoia::keybinds;
import std::io;


<* Saves all keybinds as a file *>
fn void save_keybinds() @export("keybinds_save") {
  // Calculate size of file
  usz length = ennoia::keybinds.len() * 6;
  ennoia::keybinds.@each(; String key, Keybind val) {
    length += key.len + 1;
  };

  // Create file
  ennoia::keybinds.@each(; String key, Keybind val) {
    File file = file::open(key, "wb")!!;
    file.write_int(val.key)!!;
    file.write_short(val.mod)!!;
    file.close()!!;
  };
}
<* Prints all information from keydata entry *>
fn void KeyData.print(&self) @export("keybinds_print") {
  io::printfn("%X - %X (%s|%s)",self.key, self.mod, self.down, self.repeat);
}

