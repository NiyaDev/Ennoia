
module ennoia::bounds;
import ennoia;


struct BoundingBox {
  Vector3 min,max;
}

<* Check if two bounding boxes overlap *>
fn bool check_boxes(BoundingBox b1, BoundingBox b2) {
  bool output = true;

  if ((b1.max.x >= b2.min.x) && (b1.min.x <= b2.max.x)) {
    if ((b1.max.y < b2.min.y) || (b1.min.y > b2.max.y)) output = false;
    if ((b1.max.z < b2.min.z) || (b1.min.z > b2.max.z)) output = false;
  } else { output = false; }

  return output;
}

