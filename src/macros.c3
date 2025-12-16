
module ennoia::debug;


<**>
macro void? @error(#a, #b, #c) {
  if (catch excuse = #a) {
    warning(#b, #c);
    return excuse?;
  }
}

<**>
macro void? @error_b(#a, #b, #c, #d) {
  if (!#a) {
    warning(#b, #c);
    return #d?;
  }
}

