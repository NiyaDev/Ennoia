
module ennoia::bounds;
import ennoia;


struct BoundingBox {
  Vector3 min,max;
}

<**>
// TODO:
fn bool check_boxes(BoundingBox b1, BoundingBox b2) {
  return (b2.max.x < b1.min.x || b2.min.x > b1.max.x);
}

