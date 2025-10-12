
import ennoia;
import std::io;

/*
fn void list() @test {
  ennoia::init();
  defer ennoia::clean();

  bulk::load_all("resources/030");

  float timer = 1000;
  float timerLength = 1000;

  
  ui::add("label_1", ui::new_label("TESTIFICATE"));
  ui::add("label_2", ui::new_label("TESTIFICATE", 100));
  
  ui::add("button_1", ui::new_button(
    text:    "abcdefghijklmnopqrstuvwxyz",
    texture: "bar_bg",
    bounds:  {400,100,128,32},
    scale:   {1,1},
    click:   &testfn,
  ));
  ui::add("button_2", ui::new_button(
    text:    "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    texture: "bar_bg",
    bounds:  {400,200,128,32},
    scale:   {1,1},
    click:   &testfn,
  ));
  ui::add("button_3", ui::new_button(
    text:    "!@#$%^&*()-_=+[]\\|`~;:'\"",
    texture: "bar_bg",
    bounds:  {400,300,128,32},
    scale:   {1,1},
    click:   &testfn,
  ));
  ui::add("button_4", ui::new_button(
    text:    ",.<>/?0123456789",
    texture: "bar_bg",
    bounds:  {400,400,128,32},
    scale:   {1,1},
    click:   &testfn,
  ));

  ui::add("bar_1", ui::new_bar(
    textureBg: "bar_bg",
    textureFg: "bar_fill",
    bounds:    {0,200,128,32},
    scale:     {3,3},
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
  //assert( ui::exists("label_1"), "Failed to create label.");
  //Element* label_1 = ui::get("label_1");
  //assert( label_1.label.text == "TESTIFICATE", "Failed to write text to label.");
  //assert(!ui::exists("label_2"), "Failed to delete label.");
}
*/

fn void hybrid() @test {
  ennoia::init();
  defer ennoia::clean();

  bulk::load_all("resources/030");

  UITexture tex_top = ui::texture(bounds:{198,-2,4,4});
  UILabel label_left_top = ui::label(text:"left:top",     alignHori:LEFT,  alignVert:TOP,   position:{200,0});
  UILabel label_cent_top = ui::label(text:"center:top",   alignHori:CENTER,alignVert:TOP,   position:{200,24});
  UILabel label_righ_top = ui::label(text:"right:top",    alignHori:RIGHT, alignVert:TOP,   position:{200,48});

  UITexture tex_cen = ui::texture(bounds:{198,198,4,4});
  UILabel label_left_cen = ui::label(text:"left:center",  alignHori:LEFT,  alignVert:CENTER,position:{200,200});
  UILabel label_cent_cen = ui::label(text:"center:center",alignHori:CENTER,alignVert:CENTER,position:{200,224});
  UILabel label_righ_cen = ui::label(text:"right:center", alignHori:RIGHT, alignVert:CENTER,position:{200,248});

  UITexture tex_bot = ui::texture(bounds:{198,398,4,4});
  UILabel label_left_bot = ui::label(text:"left:bottom",  alignHori:LEFT,  alignVert:BOTTOM,position:{200,400});
  UILabel label_cent_bot = ui::label(text:"center:bottom",alignHori:CENTER,alignVert:BOTTOM,position:{200,424});
  UILabel label_righ_bot = ui::label(text:"right:bottom", alignHori:RIGHT, alignVert:BOTTOM,position:{200,448});

  float timer = 1000;
  float timerLength = 1000;

  while (!ennoia::window_should_close()) {

    if (keybinds::pressed("debug")) {}

    tex_top.draw();
    label_left_top.draw();
    label_cent_top.draw();
    label_righ_top.draw();

    tex_cen.draw();
    label_left_cen.draw();
    label_cent_cen.draw();
    label_righ_cen.draw();

    tex_bot.draw();
    label_left_bot.draw();
    label_cent_bot.draw();
    label_righ_bot.draw();
    
    ennoia::start_drawing();


    ennoia::end_drawing();

    if (timer <= 0) ennoia::forceClose = true;
    timer--;
  }
}

fn void immediate_mode() @test {
  ennoia::init();
  defer ennoia::clean();

  bulk::load_all("resources/030");

  float timer = 1000;
  float timerLength = 1000;

  while (!ennoia::window_should_close()) {

    if (keybinds::pressed("debug")) {}

    imm::label("<c=255,161,0,255>fug</c>an<c=0,255,0,255>dulu</c>");
    if (imm::button(text:"and", bounds:{0,100,64,16})) {
      imm::label(text:"ulu", position:{0,50});
    }

    imm::bar(
      textureBg: "bar_bg",
      textureFg: "bar_fill",
      textureTint: color::RED,
      bounds:{0,(float)ennoia::renHeight-32,ennoia::renWidth,32},
      value:     &timer,
      valueMax:  &timerLength,
    );
    
    ennoia::start_drawing();


    ennoia::end_drawing();

    if (timer <= 0) ennoia::forceClose = true;
    timer--;
  }
}


