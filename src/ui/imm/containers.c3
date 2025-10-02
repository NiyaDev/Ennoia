
module ennoia::ui::imm;
import ennoia;
import std::io;


<* Immediate mode Draggable container *>
fn void container_drag(
  Vec2f* position,
  Rectangle dragArea = {0,0,32,8},
) @export("imm_contdrag") {
  if ((dragArea + *position).within(ennoia::mousePosition) && keybinds::mouse_down(1)) {
    io::printfn("[%f,%f] + [%f,%f] = [%f,%f]",
      position.x, position.y,
      ennoia::mouseDelta.x, ennoia::mouseDelta.y,
      position.x + ennoia::mouseDelta.x,
      position.y + ennoia::mouseDelta.y,
    );
    *position += ennoia::mouseDelta;
    //Vector2 posInDrag = ennoia::mousePosition - dragArea.v2();
    
  }
}

