
//import ennoia;


fn void screenshot() @test {
  ennoia::init();
  defer ennoia::clean();

  bool runonce = true;

  while (!ennoia::window_should_close() && runonce == true) {
    ennoia::end_drawing();
    render::save_screenshot();

    runonce = false;
  }
}

