
module ennoia::keybinds;
import std::collections;


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


<* Sets any existing key in the queue to repeat and remove any that are still up *>
fn void update() @export("keybinds_update") {
  ennoia::mouseDelta = {0,0};

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

