
module ennoia::camera;
import ennoia::vector;


Camera main = {{0,1,-1}, {0,0,0}, {0,1,0}, 70};

struct Camera {
  Vector3 position, target, up;
  float fov;
}


