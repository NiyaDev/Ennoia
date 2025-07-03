
module ennoia::camera;
import ennoia::vector;
import ennoia::matrix;


Camera main = {{0,5,5}, {0,0,0}, {0,1,0}, 70};

struct Camera {
  Vector3 position, target, up;
  float fov;
}

<**>
fn Matrix get_matrix() {
  return matrix::look_at(main.position, main.target, main.up);
}
