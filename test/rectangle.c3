
import ennoia::rectangle;
import ennoia::vector;



fn void overloads() @test {
  assert((Rectangle){10,10,10,10} == (Rectangle){10,10,10,10},                                 "Equivalent failed");
  assert((Rectangle){10,10,10,10} +  (Rectangle){10,10,10,10} == (Rectangle){20,20,20,20},     "Addition failed");
  assert((Rectangle){10,10,10,10} -  (Rectangle){10,10,10,10} == (Rectangle){0,0,0,0},         "Subtraction failed");
  assert((Rectangle){10,10,10,10} *  (Rectangle){10,10,10,10} == (Rectangle){100,100,100,100}, "Multiplication failed");
  assert((Rectangle){10,10,10,10} /  (Rectangle){10,10,10,10} == (Rectangle){1,1,1,1},         "Division failed");
}

fn void overloads_assign() @test {
  Rectangle addition       = (Rectangle){10,10,10,10};
  Rectangle subtraction    = (Rectangle){10,10,10,10};
  Rectangle multiplication = (Rectangle){10,10,10,10};
  Rectangle division       = (Rectangle){10,10,10,10};

  addition       += (Rectangle){10,10,10,10};
  subtraction    -= (Rectangle){10,10,10,10};
  multiplication *= (Rectangle){10,10,10,10};
  division       /= (Rectangle){10,10,10,10};

  assert(addition       == (Rectangle){20,20,20,20},     "Addition failed");
  assert(subtraction    == (Rectangle){0,0,0,0},         "Subtraction failed");
  assert(multiplication == (Rectangle){100,100,100,100}, "Multiplication failed");
  assert(division       == (Rectangle){1,1,1,1},         "Division failed");
}

fn void overloads_vec2() @test {
  assert((Rectangle){10,10,10,10} + (Vec2f){10,10} == (Rectangle){20,20,10,10},   "Addition failed");
  assert((Rectangle){10,10,10,10} - (Vec2f){10,10} == (Rectangle){0,0,10,10},     "Subtraction failed");
  assert((Rectangle){10,10,10,10} * (Vec2f){10,10} == (Rectangle){100,100,100,100}, "Multiplication failed");
  assert((Rectangle){10,10,10,10} / (Vec2f){10,10} == (Rectangle){1,1,1,1},     "Division failed");
}

fn void overloads_assign_vec2() @test {
  Rectangle addition       = (Rectangle){10,10,10,10};
  Rectangle subtraction    = (Rectangle){10,10,10,10};
  Rectangle multiplication = (Rectangle){10,10,10,10};
  Rectangle division       = (Rectangle){10,10,10,10};

  addition       += (Vec2f){10,10};
  subtraction    -= (Vec2f){10,10};
  multiplication *= (Vec2f){10,10};
  division       /= (Vec2f){10,10};

  assert(addition       == (Rectangle){20,20,10,10},     "Addition failed");
  assert(subtraction    == (Rectangle){0,0,10,10},       "Subtraction failed");
  assert(multiplication == (Rectangle){100,100,100,100}, "Multiplication failed");
  assert(division       == (Rectangle){1,1,1,1},         "Division failed");
}

