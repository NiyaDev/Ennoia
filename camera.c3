
module ennoia::camera;
import std::io;
import std::math;
import ennoia::vector;
import ennoia::matrix;


Camera main = {{0,0,0}, {0,5,5}, {0,1,0}, 70, 0, 0};

struct Camera {
  Vector3 target, distance, up;
  float fov, rotation, rot_target;
}

<* Updates main camera rotation *>
fn void update() {
  if (!main.rotation.close(main.rot_target, 5)) {
    float dir;
    if ((main.rot_target - main.rotation) > 0) dir =  1;
    if ((main.rot_target - main.rotation) < 0) dir = -1;

    main.rotation += dir * (500 * (float)ennoia::deltaTime);
  } else {
    main.rotation = main.rot_target;

    if (main.rotation < 0) {
      main.rotation += 360;
      main.rot_target += 360;
    }
    if (main.rotation > 360) {
      main.rotation -= 360;
      main.rot_target -= 360;
    }
  }
}
<* Creates matrix for camera position *>
fn Matrix get_matrix() {
  return matrix::look_at(main.target.rotate(main.distance, main.rotation), main.target, main.up);
}

<* Adds to the main cameras current rotation
  @param target: "The amount to add to the rotation"
 *>
fn void rotate(float target) {
  main.rot_target += target;
}
<* Returns true if the main camera is currently rotating *>
fn bool is_rotating() {
  return main.rotation != main.rot_target;
}

<* Prints all data about the main camera *>
fn void Camera.print(&self) {
  io::printfn(
    "target: {%f,%f,%f}\ndistance: {%f,%f,%f}\nfov: %f\nrotation: %f -> %f",
    self.target.x, self.target.y, self.target.z,
    self.distance.x, self.distance.y, self.distance.z,
    self.fov,
    self.rotation, self.rot_target,
  );
}

