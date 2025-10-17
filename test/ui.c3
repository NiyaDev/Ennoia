
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

  UIButton but_1 = ui::button(text:"TEMP", bounds:{0,500,100,25}, func:&button_test);

  UIContainer vertical = ui::container(VERTICAL,{800,50,200,400},{5,5,5,5},{190,40},"texture", scale:{4,4});
  UIContainer horizontal = ui::container(HORIZONTAL,{600,450,400,200},{5,5,5,5},{40,190},"texture", scale:{4,4});

  UILabel cont_label = ui::label("Label",alignHori:CENTER,alignVert:CENTER);
  UITexture cont_texture = ui::texture("bar_fill",tiled:true);
  UIButton cont_button = ui::button("Button");
  UIBar cont_bar = ui::bar();

  vertical.push((any)&cont_label);
  vertical.push((any)&cont_texture);
  vertical.push((any)&cont_texture);
  vertical.push((any)&cont_button);
  vertical.push((any)&cont_label);
  vertical.push((any)&cont_texture);
  vertical.push((any)&cont_texture);
  vertical.push((any)&cont_button);
  vertical.push((any)&cont_label);
  vertical.push((any)&cont_texture);
  vertical.push((any)&cont_texture);
  vertical.push((any)&cont_button);
  
  horizontal.push((any)&cont_label);
  horizontal.push((any)&cont_texture);
  horizontal.push((any)&cont_texture);
  horizontal.push((any)&cont_button);

  float timer = 1000;
  float timerLength = 1000;

  cont_bar.value = &timer;
  cont_bar.max = &timerLength;
  vertical.push((any)&cont_bar);

  UIBar bar_progress = ui::bar(textureBG:"bar_bg",textureFG:"bar_fill",bounds:{0,(float)ennoia::renHeight-32,ennoia::renWidth,32},value:&timer,max:&timerLength);

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

    but_1.draw();
    
    bar_progress.draw();

    vertical.draw();

    ennoia::drawing();

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

fn void button_test() {
  io::printfn("Button test");
  unreachable();
}
