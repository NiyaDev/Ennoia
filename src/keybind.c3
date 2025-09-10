
module ennoia::keybinds;
import std::io;
import std::collections;
import sdl3;
import ennoia;


alias KeyboardKey = uint;
alias KeyboardMod = ushort;
alias Keybindings = HashMap{String, Keybind};

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
fn void save_keybinds() @export("keybinds_save") {
  // Calculate size of file
  usz length = ennoia::keybinds.len() * 6;
  ennoia::keybinds.@each(; String key, Keybind val) {
    length += key.len + 1;
  };

  // Create file
  ennoia::keybinds.@each(; String key, Keybind val) {
    File file = file::open(key, "wb")!!;
    file.write_int(val.key);
    file.write_short(val.mod);
    file.close()!!;
  };
}
<* Prints all information from keydata entry *>
fn void KeyData.print(&self) @export("keybinds_print") {
  io::printfn("%X - %X (%s|%s)",self.key, self.mod, self.down, self.repeat);
}

<* Sets any existing key in the queue to repeat and remove any that are still up *>
fn void update() @export("keybinds_update") {
  for (int i; i < ennoia::keyqueue.len(); i++) {
    ennoia::keyqueue[i].repeat = true;
    if (ennoia::keyqueue[i].down == false) {
      ennoia::keyqueue.remove_at(i);
      i--;
    }
  }
  for (int i; i < ennoia::mouseButtons.len; i++) {
    switch (true) {
      case  ennoia::mouseButtons[i] && !ennoia::mouseButtonsHeld[i] && !ennoia::mouseButtonsUp[i]:
        ennoia::mouseButtonsHeld[i] = true;
      case  ennoia::mouseButtons[i]                                 &&  ennoia::mouseButtonsUp[i]:
        ennoia::mouseButtons[i] = false;
        ennoia::mouseButtonsHeld[i] = false;
      case !ennoia::mouseButtons[i] && !ennoia::mouseButtonsHeld[i] &&  ennoia::mouseButtonsUp[i]:
        ennoia::mouseButtonsUp[i] = false;
    }
  }
}

<* Returns the position of the input key in the queue or -1 if it's not there.
  @param data: "The keyboard event data to check for in queue"
 *>
fn int queue_contains(SDL_KeyboardEvent data) @export("keybinds_queuecontains") {
  int result;
  for (int i; i < ennoia::keyqueue.len(); i++) {
    if (data.key == ennoia::keyqueue[i].key && data.mod == ennoia::keyqueue[i].mod) return i;
  }
  return -1;
}
<* Adds input input key to the queue.
  @param data: "Keyboard event data to add to queue"
 *>
fn void add_queue(SDL_KeyboardEvent data) @export("keybinds_queueadd") {
  int val = queue_contains(data);
  if (val == -1) {
    ennoia::keyqueue.push({
      data.key,
      data.mod,
      data.down,
      false,
    });
  } else {
    ennoia::keyqueue[val].down = data.down;
    ennoia::keyqueue[val].repeat = true;
  }
}
<* Removes input key from queue
  @param data: "Keyboard event data to remove"
 *>
fn void rem_queue(SDL_KeyboardEvent data) @export("keybinds_queueremove") {
  int val = queue_contains(data);
  if (val != -1) ennoia::keyqueue.remove_at(val);
}

<* Returns whether the input keybind is currently pressed down for the first time.
  @param key: "Name of keybind"
 *>
fn bool pressed(String key) @export("keybinds_pressed") {
  Keybind? kb = ennoia::keybinds.get(key);
  if (catch kb) {
    io::printfn("[WARNING] - ENNOIA::KEYBINDS::PRESSED [Attempted to use keybinding that doesn't exist.]");
    return false;
  }

  for (int i; i < ennoia::keyqueue.len(); i++) {
    if (kb.key == ennoia::keyqueue[i].key &&
        kb.mod == ennoia::keyqueue[i].mod &&
        ennoia::keyqueue[i].down == true &&
        ennoia::keyqueue[i].repeat == false) return true;
  }
  return false;
}
<* Returns whether the input keybind is currently held down.
  @param key: "Name of keybind"
 *>
fn bool down(String key) @export("keybinds_down") {
  Keybind? kb = ennoia::keybinds.get(key);
  if (catch kb) {
    io::printfn("[WARNING] - ENNOIA::KEYBINDS::DOWN [Attempted to use keybinding that doesn't exist. %s]", key);
    return false;
  }
  for (int i; i < ennoia::keyqueue.len(); i++) {
    if (kb.key == ennoia::keyqueue[i].key &&
        kb.mod == ennoia::keyqueue[i].mod &&
        ennoia::keyqueue[i].down == true) return true;
  }
  return false;
}
<* Returns whether the input keybind is currently let go of.
  @param key: "Name of keybind"
 *>
fn bool up(String key) @export("keybinds_up") {
  Keybind? kb = ennoia::keybinds.get(key);
  if (catch kb) {
    io::printfn("[WARNING] - ENNOIA::KEYBINDS::UP [Attempted to use keybinding that doesn't exist.]");
    return false;
  }

  for (int i; i < ennoia::keyqueue.len(); i++) {
    if (kb.key == ennoia::keyqueue[i].key &&
        kb.mod == ennoia::keyqueue[i].mod &&
        ennoia::keyqueue[i].down == false) return true;
  }
  return false;
}

<* Returns whether the input mouse button is currently pressed *>
fn bool mouse_pressed(uint button) @export("keybinds_mousepressed") {
  return (ennoia::mouseButtons[button-1] && !ennoia::mouseButtonsHeld[button-1]);
}
<* Returns whether the input mouse button is currently down *>
fn bool mouse_down(uint button) @export("keybinds_mousedown") {
  return (ennoia::mouseButtons[button-1] && ennoia::mouseButtonsHeld[button-1]);
}
<* Returns whether the input mouse button is currently up *>
fn bool mouse_up(uint button) @export("keybinds_mouseup") {
  return (!ennoia::mouseButtons[button-1] && ennoia::mouseButtonsUp[button-1]);
}


