
module ennoia::keybinds;
import ennoia;


<* "Presses" a key *>
fn void set(String key, bool down = true, bool repeat = false) @export("keybinds_set") {
  Keybind? kb = ennoia::keybinds.get(key);
  if (catch excuse = kb) {
    debug::warning("Attempted to use keybinding that doesn't exist. [%s]", key);
    return;
  }

  ennoia::keyqueue.push({kb.key, kb.mod, down, repeat});
}

<* Returns whether the input keybind is currently pressed down for the first time.
  @param key: "Name of keybind"
 *>
fn bool pressed(String key) @export("keybinds_pressed") {
  Keybind? kb = ennoia::keybinds.get(key);
  if (catch kb) {
    debug::warning("Attempted to use keybinding that doesn't exist. [%s]", key);
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
    debug::warning("Attempted to use keybinding that doesn't exist. [%s]", key);
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
    debug::warning("Attempted to use keybinding that doesn't exist. [%s]", key);
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


