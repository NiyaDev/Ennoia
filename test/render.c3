
import ennoia;


fn void test() @test {
  ennoia::init();
  defer ennoia::clean();

  bool draw = true;

  while (!ennoia::window_should_close()) {

    if (keybinds::pressed("debug")) draw = !draw;
    
    ennoia::start_drawing();

    if (draw) {
      for (int i; i < (16*16)*4; i++) {
        render::draw_mesh(
          nameMesh: "cube",
          nameTexture: "texture",
          position: {(float)(i%32) - 16,0,(float)(i/32) - 16},
          rotation: {0, (float)(i % 180), 0},
        );
        render::draw_texture(
          nameTexture: "texture",
          dst: {(float)(i%32) * 16,(float)(i/32) * 16, 16, 16},
        );
      }
    }

    ennoia::end_drawing();
  }
}

