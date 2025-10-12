
module ennoia::ui::old;
import std::io;


<* Adds new UI element to handler *>
fn void add(String name, Element* e) @export("ui_add") {
  if (e == null) return;
  if (exists(name)) {
    free(e);
    return;
  }

  if (ennoia::uiElements.has_key(name)) {
    io::printfn("[WARNING] - ENNOIA::UI::ADD [Attempted to add ui element that already exists.]");
    return;
  }
  ennoia::uiElements.set(name, e);
}
<* Returns whether UI element exists *>
fn bool exists(String name) @export("ui_exists") {
  return ennoia::uiElements.has_key(name);
}
<* Returns named UI element *>
fn Element* get(String name) @export("ui_get") {
  return ennoia::uiElements[name]!!;
}

<* Cleans up all ui elements *>
fn void clean() {
  ennoia::uiElements.@each(; String key, Element* e) {
    switch (e.type) {
      case CONTAINER_VERT:
        for (int i; i < e.contVert.elements.len; i++) free(e.contVert.elements[i]);
        //free(e.contVert.elements);
      default:
    }
    free(e);
  };
  ennoia::uiElements.clear();
}

