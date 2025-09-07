
import ennoia;



fn void def_values() @test {
  assert(camera::main.target     == camera::DEF_TARGET,   "Camera default target incorect");
  assert(camera::main.distance   == camera::DEF_DISTANCE, "Camera default distance incorect");
  assert(camera::main.up         == camera::DEF_UP,       "Camera default up incorect");
  assert(camera::main.fov        == camera::DEF_FOV,      "Camera default fov incorect");
  assert(camera::main.rotation   == camera::DEF_ROTATION, "Camera default rotation incorect");
  assert(camera::main.rot_target == camera::DEF_ROTATION, "Camera default rot_target incorect");
}

fn void rotation() @test {
  Camera main = {camera::DEF_TARGET, camera::DEF_DISTANCE, camera::DEF_UP, camera::DEF_FOV, camera::DEF_ROTATION, camera::DEF_ROTATION};
  camera::rotate(180, &main);
  ennoia::deltaTime = 0.002;

  for (int i; i < 5000; i++) camera::update(&main);

  assert(main.rotation == 180, "Camera failed to rotate properly. %f", main.rotation);
}

