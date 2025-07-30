
module ennoia::camera;
import std::io;
import std::math;
import ennoia::vector;
import ennoia::matrix;


const Vector3 DEF_TARGET = {0,0,0};
const Vector3 DEF_DISTANCE = {0,5,5};
const Vector3 DEF_UP = {0,1,0};
const float   DEF_FOV = 70;
const float   DEF_ROTATION = 0;

Camera main = {DEF_TARGET, DEF_DISTANCE, DEF_UP, DEF_FOV, DEF_ROTATION, DEF_ROTATION};

struct Camera {
  Vector3 target, distance, up;
  float fov, rotation, rot_target;
}

<* Updates main camera rotation *>
fn void update(Camera* cam = &main) {
  if (!cam.rotation.close(cam.rot_target, 5)) {
    float dir;
    if ((cam.rot_target - cam.rotation) > 0) dir =  1;
    if ((cam.rot_target - cam.rotation) < 0) dir = -1;

    cam.rotation += dir * (500 * (float)ennoia::deltaTime);
  } else {
    cam.rotation = cam.rot_target;

    if (cam.rotation < 0) {
      cam.rotation += 360;
      cam.rot_target += 360;
    }
    if (cam.rotation > 360) {
      cam.rotation -= 360;
      cam.rot_target -= 360;
    }
  }
}
<* Creates matrix for camera position *>
fn Matrix get_matrix(Camera* cam = &main) {
  return matrix::look_at(cam.target.rotate(cam.distance, cam.rotation), cam.target, cam.up);
}

<* Adds to the main cameras current rotation
  @param target: "The amount to add to the rotation"
 *>
fn void rotate(float target, Camera* cam = &main) {
  cam.rot_target += target;
}
<* Returns true if the main camera is currently rotating *>
fn bool is_rotating(Camera* cam = &main) {
  return cam.rotation != cam.rot_target;
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

