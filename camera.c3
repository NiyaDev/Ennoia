
module ennoia::camera;
import std::math;
import ennoia::vector;
import ennoia::matrix;


Camera main = {{0,0,0}, {0,5,5}, {0,1,0}, 70, 0, 0};

struct Camera {
  Vector3 target, distance, up;
  float fov, rotation, rot_target;
}

<* Creates matrix for camera position *>
fn Matrix get_matrix() {
  if (!main.rotation.close(main.rot_target, 5)) {
    float dir;
    if ((main.rot_target - main.rotation) > 0) dir =  1;
    if ((main.rot_target - main.rotation) < 0) dir = -1;

    main.rotation += dir * (500 * ennoia::deltaTime);
  } else {
    if (main.rotation < 0) {
      main.rotation += 360;
      main.rot_target += 360;
    }
    if (main.rotation > 360) {
      main.rotation -= 360;
      main.rot_target -= 360;
    }
  }

  return matrix::look_at(main.target.rotate(main.distance, main.rotation), main.target, main.up);
}

<**>
fn void rotate(float target) {
  main.rot_target += target;
}

