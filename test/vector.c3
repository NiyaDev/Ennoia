
import std::io;
import std::math;
import ennoia::vector;
import ennoia::matrix;


const Matrix TRANSFORM_TEST = {
  1,0,0,1,
  0,1,0,1,
  0,0,1,1,
  0,0,0,1,
};


fn void v2_overloads() @test {
  assert((Vector2)          {10,10} == {10,10},   "Equivalent failed");
  assert((Vector2){10,10} + {10,10} == {20,20},   "Addition failed");
  assert((Vector2){10,10} - {10,10} == {0,0},     "Subtraction failed");
  assert((Vector2){10,10} * {10,10} == {100,100}, "Multiplication failed");
  assert((Vector2){10,10} / {10,10} == {1,1},     "Division failed");
}

fn void v2_overloads_assign() @test {
  Vector2 addition       = {10,10};
  Vector2 subtraction    = {10,10};
  Vector2 multiplication = {10,10};
  Vector2 division       = {10,10};

  addition       += {10,10};
  subtraction    -= {10,10};
  multiplication *= {10,10};
  division       /= {10,10};

  assert(addition       == {20,20},   "Addition failed");
  assert(subtraction    == {0,0},     "Subtraction failed");
  assert(multiplication == {100,100}, "Multiplication failed");
  assert(division       == {1,1},     "Division failed");
}

fn void v2_overloads_float() @test {
  assert((Vector2){10,10} + 10 == {20,20},   "Addition failed");
  assert((Vector2){10,10} - 10 == {0,0},     "Subtraction failed");
  assert((Vector2){10,10} * 10 == {100,100}, "Multiplication failed");
  assert((Vector2){10,10} / 10 == {1,1},     "Division failed");
}

fn void v2_overloads_assign_float() @test {
  Vector2 addition       = {10,10};
  Vector2 subtraction    = {10,10};
  Vector2 multiplication = {10,10};
  Vector2 division       = {10,10};

  addition       += 10;
  subtraction    -= 10;
  multiplication *= 10;
  division       /= 10;

  assert(addition       == {20,20},   "Addition failed");
  assert(subtraction    == {0,0},     "Subtraction failed");
  assert(multiplication == {100,100}, "Multiplication failed");
  assert(division       == {1,1},     "Division failed");
}

fn void v2_func() @test {
  // Conversions
  assert((Vector2){10,10}.v3() == (Vector3){10,10,0},   "Conversion to v3 failed");
  assert((Vector2){10,10}.v4() == (Vector4){10,10,0,1}, "Conversion to v4 failed");

  // Length
  assert((Vector2){10,10}.length_sqr() == 200,                 "Length sqr failed");
  assert((Vector2){10,10}.length()     == 14.1421356201171875, "Length failed");

  // Dot Product
  assert((Vector2){10,10}.dot_product({10,10}) == 200, "Dot Product failed");

  // Distance
  assert((Vector2){10,10}.distance_sqr({0,0}) == 200,                 "Distance sqr failed");
  assert((Vector2){10,10}.distance({0,0})     == 14.1421356201171875, "Distance failed");

  // Angle
  assert((Vector2){0,0}.angle_rad({10,10}) == 0.7853981852531433, "Radian Angle failed");
  assert((Vector2){0,0}.angle_deg({10,10}) == 45,                 "Degree Angle failed");

  // Normalize
  assert((Vector2){10,10}.normalize() == (Vector2){0.7071068286895752,0.7071068286895752}, "Normalize failed");

  // Matrix Transform
  assert((Vector2){10,10}.transform(TRANSFORM_TEST) == {11,11}, "Translation failed");

  // Lerp
  assert((Vector2){10,10}.lerp({20,20},0.5) == {15,15}, "Lerp failed");

  // Reflection
  assert((Vector2){10,10}.reflect({0,1}) == {10,-10}, "Reflect failed");

  // Rotate
  assert((Vector2){10,10}.rotate_rad(0.7853982) == {0,14.1421356201171875}, "Radian rotation failed");
  assert((Vector2){10,10}.rotate_deg(45)        == {0,14.1421356201171875}, "Degree rotation failed");

  // Move towards
  assert((Vector2){10,10}.move_towards({20,20}, 5) == {13.5355339050292969,13.5355339050292969}, "Move towards failed [%.16f]", (Vector2){10,10}.move_towards({20,20}, 5).x);

  // Invert
  assert((Vector2){10,10}.invert() == {0.1,0.1}, "Invert failed");

  // Clamp
  assert((Vector2){10,10}.clamp({0,0},{5,5}) == {5,5},                                     "Clamp failed");
  assert((Vector2){100,100}.clamp_mag(0,5)   == {42.0448226928710938,42.0448226928710938}, "Magnitude Clamp failed");
}


fn void v3_overloads() @test {
  assert((Vector3)             {10,10,10} == {10,10,10},    "Equivalent failed");
  assert((Vector3){10,10,10} + {10,10,10} == {20,20,20},    "Addition failed");
  assert((Vector3){10,10,10} - {10,10,10} == {0,0,0},       "Subtraction failed");
  assert((Vector3){10,10,10} * {10,10,10} == {100,100,100}, "Multiplication failed");
  assert((Vector3){10,10,10} / {10,10,10} == {1,1,1},       "Division failed");
}

fn void v3_overloads_assign() @test {
  Vector3 addition       = {10,10,10};
  Vector3 subtraction    = {10,10,10};
  Vector3 multiplication = {10,10,10};
  Vector3 division       = {10,10,10};

  addition       += {10,10,10};
  subtraction    -= {10,10,10};
  multiplication *= {10,10,10};
  division       /= {10,10,10};

  assert(addition       == {20,20,20},    "Addition failed");
  assert(subtraction    == {0,0,0},       "Subtraction failed");
  assert(multiplication == {100,100,100}, "Multiplication failed");
  assert(division       == {1,1,1},       "Division failed");
}

fn void v3_overloads_float() @test {
  assert((Vector3){10,10,10} + 10 == {20,20,20},    "Addition failed");
  assert((Vector3){10,10,10} - 10 == {0,0,0},       "Subtraction failed");
  assert((Vector3){10,10,10} * 10 == {100,100,100}, "Multiplication failed");
  assert((Vector3){10,10,10} / 10 == {1,1,1},       "Division failed");
}

fn void v3_overloads_assign_float() @test {
  Vector3 addition       = {10,10,10};
  Vector3 subtraction    = {10,10,10};
  Vector3 multiplication = {10,10,10};
  Vector3 division       = {10,10,10};

  addition       += 10;
  subtraction    -= 10;
  multiplication *= 10;
  division       /= 10;

  assert(addition       == {20,20,20},    "Addition failed");
  assert(subtraction    == {0,0,0},       "Subtraction failed");
  assert(multiplication == {100,100,100}, "Multiplication failed");
  assert(division       == {1,1,1},       "Division failed");
}

fn void v3_func() @test {
  // Conversions
  assert((Vector3){10,10,10}.v2() == (Vector2){10,10},      "Conversion to v2 failed");
  assert((Vector3){10,10,10}.v4() == (Vector4){10,10,10,1}, "Conversion to v4 failed");
  assert((Vector3){10,10,10}.to_array() == {10,10,10},      "Conversion to array failed");
  assert((Vector3){10,10,10}.to_int_array() == {10,10,10},  "Conversion to int array failed");

  // Cross Product
  assert((Vector3){10,10,10}.cross_product({10,10,10}) == {0,0,0}, "Cross Product failed");

  // Perpendicular
  assert((Vector3){10,10,0}.perpendicular() == (Vector3){10,10,0}.cross_product({0,1,0}), "Perpendicular failed");
  
  // Length
  assert((Vector3){10,10,10}.length_sqr() == 300,                 "Length sqr failed");
  assert((Vector3){10,10,10}.length()     == 17.3205089569091797, "Length failed");

  // Dot Product
  assert((Vector3){10,10,10}.dot_product({10,10,10}) == 300, "Dot Product failed");

  // Distance
  assert((Vector3){10,10,10}.distance_sqr({0,0,0}) == 300,                 "Distance sqr failed");
  assert((Vector3){10,10,10}.distance({0,0,0})     == 17.3205089569091797, "Distance failed");

  // Angle
  assert((Vector3){0,0,0}.angle_rad({10,10,10}) == 0, "Radian Angle failed");
  assert((Vector3){0,0,0}.angle_deg({10,10,10}) == 0, "Degree Angle failed");

  // Normalize
  assert((Vector3){10,10,10}.normalize() == {0.5773502,0.5773502,0.5773502}, "Normalize failed");

  // Project
  assert((Vector3){10,10,10}.project({5,5,5}) == {10,10,10}, "Project failed");

  // Reject
  assert((Vector3){10,10,10}.reject({5,5,5}) == {0,0,0}, "Reject failed");

  // Orthonormalize
  Vector3 ortho1 = {10,10,10};
  Vector3 ortho2 = {10,-10,0};
  ortho1.orthonormalize(&ortho2);
  assert(ortho1 == {0.5773502,0.5773502,0.5773502} && ortho2 == {0.7071067,-0.7071067,0}, "Orthinormalize failed");
  
  // Matrix Transform
  assert((Vector3){10,10,10}.transform(TRANSFORM_TEST) == {11,11,11}, "Translation failed");

  // Rotation
  assert((Vector3){10,10,10}.rotate_quaternion({10,90,6,5}) == {-6.356373,13.1085825,-9.368116}, "Rotate by Quaternion failed");
  assert((Vector3){ 0, 0, 0}.rotate({0,10,10}, 90) == {-10,10,-0.0000004371139}, "Rotation failed");
  assert((Vector3){ 0,10,10}.rotate_axis({0,1,0}, 3.141593) == {-40,10,0}, "Axis rotation failed");

  // Move Towards / Lerp
  assert((Vector3){10,10,10}.move_towards({20,20,20}, 5) == {12.886751,12.886751,12.886751}, "Move towards failed");
  assert((Vector3){10,10,10}.lerp({20,20,20},0.5) == {15,15,15}, "Lerp failed");

  // Reflection
  assert((Vector3){10,10,10}.reflect({0,1,0}) == {10,-10,10}, "Reflect failed");

  // Min/Max
  assert((Vector3){10,10,10}.min({ 0, 0, 0}) == { 0, 0, 0}, "Minimum failed");
  assert((Vector3){10,10,10}.max({20,20,20}) == {20,20,20}, "Maximum failed");

  // Barycenter
  assert((Vector3){13.33,6.66,3.33}.barycenter({0,0,0}, {20,0,10}, {0,20,-10}) == {0.00050002336,0.66641664,0.33308333}, "Barycenter failed");

  // Invert
  assert((Vector3){10,10,10}.invert() == {0.1,0.1,0.1}, "Invert failed");

  // Clamp
  assert((Vector3){10,10,10}.clamp({0,15,10}, {8,20,20}) == {8,15,10}, "Clamp failed");
  assert((Vector3){100,100,100}.clamp_mag(0,5)   == {2.8867514, 2.8867514, 2.8867514}, "Magnitude Clamp failed");

  // Close
  assert((Vector3){10,10,10.004}.close({10,10,10}, 0.005), "Close failed");
}


fn void v4_overloads() @test {
  assert((Vector4)                {10,10,10,10} == {10,10,10,10},     "Equivalent failed");
  assert((Vector4){10,10,10,10} + {10,10,10,10} == {20,20,20,20},     "Addition failed");
  assert((Vector4){10,10,10,10} - {10,10,10,10} == {0,0,0,0},         "Subtraction failed");
  assert((Vector4){10,10,10,10} * {10,10,10,10} == {100,100,100,100}, "Multiplication failed");
  assert((Vector4){10,10,10,10} / {10,10,10,10} == {1,1,1,1},         "Division failed");
}

fn void v4_overloads_assign() @test {
  Vector4 addition       = {10,10,10,10};
  Vector4 subtraction    = {10,10,10,10};
  Vector4 multiplication = {10,10,10,10};
  Vector4 division       = {10,10,10,10};

  addition       += {10,10,10,10};
  subtraction    -= {10,10,10,10};
  multiplication *= {10,10,10,10};
  division       /= {10,10,10,10};

  assert(addition       == {20,20,20,20},     "Addition failed");
  assert(subtraction    == {0,0,0,0},         "Subtraction failed");
  assert(multiplication == {100,100,100,100}, "Multiplication failed");
  assert(division       == {1,1,1,1},         "Division failed");
}

fn void v4_overloads_float() @test {
  assert((Vector4){10,10,10,10} + 10 == {20,20,20,20},     "Addition failed");
  assert((Vector4){10,10,10,10} - 10 == {0,0,0,0},         "Subtraction failed");
  assert((Vector4){10,10,10,10} * 10 == {100,100,100,100}, "Multiplication failed");
  assert((Vector4){10,10,10,10} / 10 == {1,1,1,1},         "Division failed");
}

fn void v4_overloads_assign_float() @test {
  Vector4 addition       = {10,10,10,10};
  Vector4 subtraction    = {10,10,10,10};
  Vector4 multiplication = {10,10,10,10};
  Vector4 division       = {10,10,10,10};

  addition       += 10;
  subtraction    -= 10;
  multiplication *= 10;
  division       /= 10;

  assert(addition       == {20,20,20,20},     "Addition failed");
  assert(subtraction    == {0,0,0,0},         "Subtraction failed");
  assert(multiplication == {100,100,100,100}, "Multiplication failed");
  assert(division       == {1,1,1,1},         "Division failed");
}

fn void v4_func() @test {
  // Length
  assert((Vector4){10,10,10,10}.length()     ==  20, "Length failed");
  assert((Vector4){10,10,10,10}.length_sqr() == 400, "Length square failed");

  // Dot product
  assert((Vector4){10,10,10,10}.dot_product({10,10,10,10}) == 400, "Dot product failed");

  // Distance
  assert((Vector4){10,10,10,10}.distance_sqr({20,20,20,20}) == 400, "Distance square failed");
  assert((Vector4){10,10,10,10}.distance({20,20,20,20})     ==  20, "Distance failed");

  // Normalize
  assert((Vector4){10,10,10,10}.normalize() == {0.5,0.5,0.5,0.5}, "Normalize failed");

  // Min/Max
  assert((Vector4){10,10,10,10}.min({ 0, 0, 0, 0}) == { 0, 0, 0, 0}, "Minimum failed");
  assert((Vector4){10,10,10,10}.max({20,20,20,20}) == {20,20,20,20}, "Maximum failed");

  // Move towards/Lerp
  assert((Vector4){10,10,10,10}.move_towards({20,20,20,20}, 5) == {12.5,12.5,12.5,12.5}, "Move towards failed");
  assert((Vector4){10,10,10,10}.lerp({20,20,20,20},0.5) == {15,15,15,15}, "Lerp failed");

  // Invert
  assert((Vector4){10,10,10,10}.invert() == {0.1,0.1,0.1,0.1}, "Invert failed");
}


fn void q_func() @test {
  // Conversions
  assert((vector::Quaternion){10,10,10,10}.v2() == (Vector2){10,10},       "Conversion to v2 failed");
  assert((vector::Quaternion){10,10,10,10}.v3() == (Vector3){10,10,10},    "Conversion to v3 failed");
  assert((vector::Quaternion){10,10,10,10}.v4() == (Vector4){10,10,10,10}, "Conversion to v4 failed");

  // Length
  assert((vector::Quaternion){10,10,10,10}.length_sqr() == 400, "Length sqr failed");
  assert((vector::Quaternion){10,10,10,10}.length()     ==  20, "Length failed");

  // Dot Product
  assert((vector::Quaternion){10,10,10,10}.dot_product({10,10,10,10}) == 400, "Dot Product failed");

  // Normalize
  assert((vector::Quaternion){10,10,10,10}.normalize() == (vector::Quaternion){0.5,0.5,0.5,0.5}, "Normalize failed");
}

