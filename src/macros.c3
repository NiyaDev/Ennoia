
module ennoia::debug;


<* Returns excuse if there is one *>
macro void? @error(#a, #b, #c) {
  if (catch excuse = #a) {
    warning(#b, #c);
    return excuse?;
  }
}

<* Returns excuse if fist input is false *>
macro void? @error_b(#a, #b, #c, #d) {
  if (!#a) {
    warning(#b, #c);
    return #d?;
  }
}

