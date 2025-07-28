
module ennoia::keybinds;
import std::io;
import std::collections;
import sdl3;
import ennoia::bulk;


alias KeyboardKey = uint;
alias KeyboardMod = ushort;
alias Keybindings = HashMap{String, Keybind};

Keybindings binds;
List{KeyData} keyqueue;

struct KeyData {
  KeyboardKey key;
  KeyboardMod mod;
  bool down;
  bool repeat;
}
struct Keybind {
  KeyboardKey key;
  KeyboardMod mod;
}

<* Saves all keybinds as a file *>
fn void save_keybinds() {
  // Calculate size of file
  usz length = binds.len() * 6;
  binds.@each(; String key, Keybind val) {
    length += key.len + 1;
  };

  // Create file
  binds.@each(; String key, Keybind val) {
    File file = file::open(key, "wb")!!;
    file.write_int(val.key);
    file.write_short(val.mod);
    file.close()!!;
  };
}
<* Prints all information from keydata entry *>
fn void KeyData.print(&self) {
  io::printfn("%X - %X (%s|%s)",self.key, self.mod, self.down, self.repeat);
}

<* Sets any existing key in the queue to repeat and remove any that are still up *>
fn void update() {
  for (int i; i < keyqueue.len(); i++) {
    keyqueue[i].repeat = true;
    if (keyqueue[i].down == false) {
      keyqueue.remove_at(i);
      i--;
    }
  }
}
<* Returns the position of the input key in the queue or -1 if it's not there.
  @param data: "The keyboard event data to check for in queue"
 *>
fn int queue_contains(SDL_KeyboardEvent data) {
  int result;
  for (int i; i < keyqueue.len(); i++) {
    if (data.key == keyqueue[i].key && data.mod == keyqueue[i].mod) return i;
  }
  return -1;
}
<* Adds input input key to the queue.
  @param data: "Keyboard event data to add to queue"
 *>
fn void add_queue(SDL_KeyboardEvent data) {
  int val = queue_contains(data);
  if (val == -1) {
    keyqueue.push({
      data.key,
      data.mod,
      data.down,
      false,
    });
  } else {
    keyqueue[val].down = data.down;
    keyqueue[val].repeat = true;
  }
}
<* Removes input key from queue
  @param data: "Keyboard event data to remove"
 *>
fn void rem_queue(SDL_KeyboardEvent data) {
  int val = queue_contains(data);
  if (val != -1) keyqueue.remove_at(val);
}

<* Returns whether the input keybind is currently pressed down for the first time.
  @param key: "Name of keybind"
 *>
fn bool pressed(String key) {
  Keybind? kb = binds.get(key);
  if (catch kb) {
    io::printfn("[WARNING] - ENNOIA::KEYBINDS::PRESSED [Attempted to use keybinding that doesn't exist.]");
    return false;
  }

  for (int i; i < keyqueue.len(); i++) {
    if (kb.key == keyqueue[i].key &&
        kb.mod == keyqueue[i].mod &&
        keyqueue[i].down == true &&
        keyqueue[i].repeat == false) return true;
  }
  return false;
}
<* Returns whether the input keybind is currently held down.
  @param key: "Name of keybind"
 *>
fn bool down(String key) {
  Keybind? kb = binds.get(key);
  if (catch kb) {
    io::printfn("[WARNING] - ENNOIA::KEYBINDS::DOWN [Attempted to use keybinding that doesn't exist.]");
    return false;
  }
  for (int i; i < keyqueue.len(); i++) {
    if (kb.key == keyqueue[i].key &&
        kb.mod == keyqueue[i].mod &&
        keyqueue[i].down == true) return true;
  }
  return false;
}
<* Returns whether the input keybind is currently let go of.
  @param key: "Name of keybind"
 *>
fn bool up(String key) {
  Keybind? kb = binds.get(key);
  if (catch kb) {
    io::printfn("[WARNING] - ENNOIA::KEYBINDS::UP [Attempted to use keybinding that doesn't exist.]");
    return false;
  }

  for (int i; i < keyqueue.len(); i++) {
    if (kb.key == keyqueue[i].key &&
        kb.mod == keyqueue[i].mod &&
        keyqueue[i].down == false) return true;
  }
  return false;
}

