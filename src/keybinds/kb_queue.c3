
module ennoia::keybinds;
import sdl3;
import ennoia;


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

