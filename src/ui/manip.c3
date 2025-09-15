
module ennoia::ui;
import std::io;


<* Adds new UI element to handler *>
fn void add(String name, Element* e) @export("ui_add") {
  if (ennoia::uiElements.has_key(name)) {
    io::printfn("[WARNING] - ENNOIA::UI::ADD [Attempted to add ui element that already exists.]");
    return;
  }
  ennoia::uiElements.set(name, e);
}

<* Cleans up all ui elements *>
fn void clean() {
  ennoia::uiElements.@each(; String key, Element* e) {
    free(e);
  };
  ennoia::uiElements.clear();
}

