
import ennoia;

///*
fn void test() @test {
  ennoia::init();
  defer ennoia::clean();

  bool draw = true;

  while (!ennoia::window_should_close()) {

    if (keybinds::pressed("debug")) draw = !draw;
    
    ennoia::start_drawing();

    if (draw) {
      for (int i; i < 1000; i++) {
        /*
        render::draw_mesh(
          nameMesh: "cube",
          position: {(float)(i%32) - 16,0,(float)(i/32) - 16},
          scale:    {0.5,0.5,0.5},
          rotation: {0, (float)(i % 180), 0},
        );
        */
        //render::draw_texture("texture");
        //ennoia::textures["texture"]!!.draw(
        render::draw_texture(
          nameTexture: "texture",
          dst: {(float)(i%32) * 16,(float)(i/32) * 16, 16, 16},
        );
      }
    }

    ennoia::end_drawing();
  }
}
//*/



