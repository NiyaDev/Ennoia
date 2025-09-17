
import ennoia;
import std::io;


///*
fn void test() @test {
  ennoia::init();
  defer ennoia::clean();

  bulk::load_all("resources/030");

  float timer = 1000;
  float timerLength = 1000;

  
  ui::add("label_1", ui::new_label("TESTIFICATE"));
  ui::add("label_2", ui::new_label("TESTIFICATE", 100));
  
  ui::add("button_1", ui::new_button(
    text:    "fug",
    texture: "bar_bg",
    bounds:  {0,100,128,32},
    scale:   {2,2},
    click:   &testfn,
  ));

  ui::add("bar_1", ui::new_bar(
    textureBg: "bar_bg",
    textureFg: "bar_fill",
    bounds:    {0,200,128,32},
    value:     &timer,
    valueMax:  &timerLength,
  ));

  ui::add("container_1",
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

    if (timer <= 0) ennoia::forceClose = true;
    timer--;
  }
  
  // Testing Label
  assert( ui::exists("label_1"), "Failed to create label.");
  Element* label_1 = ui::get("label_1");
  assert( label_1.label.text == "TESTIFICATE", "Failed to write text to label.");
  assert(!ui::exists("label_2"), "Failed to delete label.");
}
//*/

fn void testfn() {
  ui::add("test_info", ui::new_label("Fug",100));
}

