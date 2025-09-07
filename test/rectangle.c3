
import ennoia::rectangle;
import ennoia::vector;



fn void overloads() @test {
  assert((Rectangle){10,10,10,10} == (Rectangle){10,10,10,10},                     "Equivalent failed");
  assert((Rectangle){10,10,10,10} + (Rectangle){10,10,10,10} == {20,20,20,20},     "Addition failed");
  assert((Rectangle){10,10,10,10} - (Rectangle){10,10,10,10} == {0,0,0,0},         "Subtraction failed");
  assert((Rectangle){10,10,10,10} * (Rectangle){10,10,10,10} == {100,100,100,100}, "Multiplication failed");
  assert((Rectangle){10,10,10,10} / (Rectangle){10,10,10,10} == {1,1,1,1},         "Division failed");
}

fn void overloads_assign() @test {
  Rectangle addition       = {10,10,10,10};
  Rectangle subtraction    = {10,10,10,10};
  Rectangle multiplication = {10,10,10,10};
  Rectangle division       = {10,10,10,10};

  addition       += (Rectangle){10,10,10,10};
  subtraction    -= (Rectangle){10,10,10,10};
  multiplication *= (Rectangle){10,10,10,10};
  division       /= (Rectangle){10,10,10,10};

  assert(addition       == {20,20,20,20},     "Addition failed");
  assert(subtraction    == {0,0,0,0},         "Subtraction failed");
  assert(multiplication == {100,100,100,100}, "Multiplication failed");
  assert(division       == {1,1,1,1},         "Division failed");
}

fn void overloads_vec2() @test {
  assert((Rectangle){10,10,10,10} + (Vector2){10,10} == {20,20,10,10},   "Addition failed");
  assert((Rectangle){10,10,10,10} - (Vector2){10,10} == {0,0,10,10},     "Subtraction failed");
  assert((Rectangle){10,10,10,10} * (Vector2){10,10} == {100,100,100,100}, "Multiplication failed");
  assert((Rectangle){10,10,10,10} / (Vector2){10,10} == {1,1,1,1},     "Division failed");
}

fn void overloads_assign_vec2() @test {
  Rectangle addition       = {10,10,10,10};
  Rectangle subtraction    = {10,10,10,10};
  Rectangle multiplication = {10,10,10,10};
  Rectangle division       = {10,10,10,10};

  addition       += (Vector2){10,10};
  subtraction    -= (Vector2){10,10};
  multiplication *= (Vector2){10,10};
  division       /= (Vector2){10,10};

  assert(addition       == {20,20,10,10},   "Addition failed");
  assert(subtraction    == {0,0,10,10},     "Subtraction failed");
  assert(multiplication == {100,100,100,100}, "Multiplication failed");
  assert(division       == {1,1,1,1},     "Division failed");
}

