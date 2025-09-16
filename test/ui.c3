
import ennoia;
import std::io;


///*
fn void test() @test {
  ennoia::init();
  defer ennoia::clean();

  
  ui::add("test_1", ui::new_label("TESTIFICATE"));
  ui::add("test_2", ui::new_button(
    text:"fug",
    bounds:{0,100,128,32},
    click: &testfn,
  ));

  ui::add("test_container",
    ui::new_container(bounds:{200,0, 64, 640}, elements:{
      ui::new_label("fug"),
      ui::new_label("and", 100),
      ui::new_label("ulu"),
    }),
  );

  while (!ennoia::window_should_close()) {

    if (keybinds::pressed("debug")) {
      
    }
    
    ennoia::start_drawing();


    ennoia::end_drawing();
  }
}
//*/

fn void testfn() {
  ui::add("test_info", ui::new_label("Fug",100));
}

