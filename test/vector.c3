
import std::io;
import std::math;
import ennoia::vector;



const Matrix4f TRANSFORM_TEST = {
  1,0,0,0,
  0,1,0,0,
  0,0,1,0,
  1,1,1,1,
};


fn void v2_overloads() @test {
  assert((Vec2f)          {10,10} == {10,10},   "Equivalent failed");
  assert((Vec2f){10,10} + {10,10} == {20,20},   "Addition failed");
  assert((Vec2f){10,10} - {10,10} == {0,0},     "Subtraction failed");
  assert((Vec2f){10,10} * {10,10} == {100,100}, "Multiplication failed");
  assert((Vec2f){10,10} / {10,10} == {1,1},     "Division failed");
}

fn void v2_overloads_assign() @test {
  Vec2f addition       = {10,10};
  Vec2f subtraction    = {10,10};
  Vec2f multiplication = {10,10};
  Vec2f division       = {10,10};

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
  assert((Vec2f){10,10} + 10 == {20,20},   "Addition failed");
  assert((Vec2f){10,10} - 10 == {0,0},     "Subtraction failed");
  assert((Vec2f){10,10} * 10 == {100,100}, "Multiplication failed");
  assert((Vec2f){10,10} / 10 == {1,1},     "Division failed");
}

fn void v2_overloads_assign_float() @test {
  Vec2f addition       = {10,10};
  Vec2f subtraction    = {10,10};
  Vec2f multiplication = {10,10};
  Vec2f division       = {10,10};

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
  assert((Vec3f){10,10,0}.xy   == {10,10}, "Conversion to Vec3f failed");
  assert((Vec4f){10,10,0,1}.xy == {10,10}, "Conversion to Vec4f failed");
  assert((Vec2f){10,10}.xyx    == {10,10,10}, "Conversion to Vec3f failed");
  assert((Vec2f){10,10}.xyxx   == {10,10,10,10}, "Conversion to Vec4f failed");

  // Length
  assert((Vec2f){10,10}.length().pow(2) == 200,                 "Length sqr failed");
  assert((Vec2f){10,10}.length()        == 14.1421356201171875, "Length failed");

  // Dot Product
  assert((Vec2f){10,10}.dot({10,10}) == 200, "Dot Product failed");

  // Distance
  assert((Vec2f){10,10}.distance({0,0}).pow(2) == 200,                 "Distance sqr failed");
  assert((Vec2f){10,10}.distance({0,0})        == 14.1421356201171875, "Distance failed");

  // Angle
  assert((Vec2f){0,0}.angle_rad({10,10}) == 0.7853981852531433, "Radian Angle failed");
  assert((Vec2f){0,0}.angle_deg({10,10}) == 45,                 "Degree Angle failed");

  // Normalize
  assert((Vec2f){10,10}.normalize() == {0.7071068286895752,0.7071068286895752}, "Normalize failed");

  // Matrix Transform
  Vec2f temp = (Vec2f){10,10}.transform(TRANSFORM_TEST);
  assert((Vec2f){10,10}.transform(TRANSFORM_TEST) == {11,11}, "Translation failed [%s]",temp);

  // Lerp
  assert((Vec2f){10,10}.lerp({20,20},0.5) == {15,15}, "Lerp failed");

  // Reflection
  assert((Vec2f){10,10}.reflect({0,1}) == {10,-10}, "Reflect failed");

  // Rotate
  assert((Vec2f){10,10}.rotate_rad(0.7853982) == {0,14.1421356201171875}, "Radian rotation failed");
  assert((Vec2f){10,10}.rotate_deg(45)        == {0,14.1421356201171875}, "Degree rotation failed");

  // Move towards
  assert((Vec2f){10,10}.move_towards({20,20}, 5) == {13.5355339050292969,13.5355339050292969}, "Move towards failed [%.16f]", (Vec2f){10,10}.move_towards({20,20}, 5).x);

  // Invert
  assert((Vec2f){10,10}.invert() == {0.1,0.1}, "Invert failed");

  // Clamp
  assert((Vec2f){10,10}.clamp({0,0},{5,5}) == {5,5},                                     "Clamp failed");
  assert((Vec2f){100,100}.clamp_mag(0,5)   == {42.0448226928710938,42.0448226928710938}, "Magnitude Clamp failed");
}


fn void v3_overloads() @test {
  assert((Vec3f)             {10,10,10} == {10,10,10},    "Equivalent failed");
  assert((Vec3f){10,10,10} + {10,10,10} == {20,20,20},    "Addition failed");
  assert((Vec3f){10,10,10} - {10,10,10} == {0,0,0},       "Subtraction failed");
  assert((Vec3f){10,10,10} * {10,10,10} == {100,100,100}, "Multiplication failed");
  assert((Vec3f){10,10,10} / {10,10,10} == {1,1,1},       "Division failed");
}

fn void v3_overloads_assign() @test {
  Vec3f addition       = {10,10,10};
  Vec3f subtraction    = {10,10,10};
  Vec3f multiplication = {10,10,10};
  Vec3f division       = {10,10,10};

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
  assert((Vec3f){10,10,10} + 10 == {20,20,20},    "Addition failed");
  assert((Vec3f){10,10,10} - 10 == {0,0,0},       "Subtraction failed");
  assert((Vec3f){10,10,10} * 10 == {100,100,100}, "Multiplication failed");
  assert((Vec3f){10,10,10} / 10 == {1,1,1},       "Division failed");
}

fn void v3_overloads_assign_float() @test {
  Vec3f addition       = {10,10,10};
  Vec3f subtraction    = {10,10,10};
  Vec3f multiplication = {10,10,10};
  Vec3f division       = {10,10,10};

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
  assert((Vec3f){10,10,10}.xy   == {10,10}, "Conversion to Vec2f failed");
  assert((Vec3f){10,10,10}.xyzx == {10,10,10,10}, "Conversion to Vec4f failed");

  // Cross Product
  assert((Vec3f){10,10,10}.cross_product({10,10,10}) == {0,0,0}, "Cross Product failed");

  // Perpendicular
  assert((Vec3f){10,10,0}.perpendicular() == {10,-10,0}, "Perpendicular failed");
  
  // Length
  assert((Vec3f){10,10,10}.length().pow(2) == 300.0000305175781,  "Length sqr failed");
  assert((Vec3f){10,10,10}.length()        == 17.320508956909179, "Length failed");

  // Dot Product
  assert((Vec3f){10,10,10}.dot({10,10,10}) == 300, "Dot Product failed");

  // Distance
  assert((Vec3f){10,10,10}.distance({0,0,0}).pow(2) == 300.0000305175781,   "Distance sqr failed");
  assert((Vec3f){10,10,10}.distance({0,0,0})        == 17.3205089569091797, "Distance failed");

  // Angle
  assert((Vec3f){0,0,0}.angle_rad({10,10,10}) == 0, "Radian Angle failed");
  assert((Vec3f){0,0,0}.angle_deg({10,10,10}) == 0, "Degree Angle failed");

  // Normalize
  assert((Vec3f){10,10,10}.normalize() == {0.5773502,0.5773502,0.5773502}, "Normalize failed");

  // Project
  assert((Vec3f){10,10,10}.project({5,5,5}) == {9.999999,9.999999,9.999999}, "Project failed");

  // Reject
  assert((Vec3f){10,10,10}.reject({5,5,5}) == {0.0000009536743,0.0000009536743,0.0000009536743}, "Reject failed");

  // Orthonormalize
  Vec3f ortho1 = {10,10,10};
  Vec3f ortho2 = {10,-10,0};
  ortho1.orthonormalize(&ortho2);
  assert(ortho1 == {0.5773502,0.5773502,0.5773502} && ortho2 == {0.7071067,-0.7071067,0}, "Orthinormalize failed");
  
  // Matrix Transform
  assert((Vec3f){10,10,10}.transform(TRANSFORM_TEST) == {11,11,11}, "Translation failed");

  // Rotation
  assert((Vec3f){10,10,10}.rotate_quaternion({10,90,6,5}) == {-7.4101024,3.6250243,-10.000352}, "Rotate by Quaternion failed");
  assert((Vec3f){ 0, 0, 0}.rotate({0,10,10}, 90) == {-10,10,-0.0000004371139}, "Rotation failed");
  assert((Vec3f){ 0,10,10}.rotate_axis({0,1,0}, 1.5707963268) == {10,10,0}, "Axis rotation failed");

  // Move Towards / Lerp
  assert((Vec3f){10,10,10}.move_towards({20,20,20}, 5) == {12.886751,12.886751,12.886751}, "Move towards failed");
  assert((Vec3f){10,10,10}.lerp({20,20,20},0.5) == {15,15,15}, "Lerp failed");

  // Reflection
  assert((Vec3f){10,10,10}.reflect({0,1,0}) == {10,-10,10}, "Reflect failed");

  // Min/Max
  assert((Vec3f){10,10,10}.min({ 0, 0, 0}) == { 0, 0, 0}, "Minimum failed");
  assert((Vec3f){10,10,10}.max({20,20,20}) == {20,20,20}, "Maximum failed");

  // Barycenter
  assert((Vec3f){13.33,6.66,3.33}.barycenter({0,0,0}, {20,0,10}, {0,20,-10}) == {0.00050002336,0.66641664,0.33308333}, "Barycenter failed");

  // Invert
  assert((Vec3f){10,10,10}.invert() == {0.1,0.1,0.1}, "Invert failed");

  // Clamp
  assert((Vec3f){10,10,10}.clamp({0,15,10}, {8,20,20}) == {8,15,10}, "Clamp failed");
  assert((Vec3f){100,100,100}.clamp_mag(0,5)   == {2.8867514, 2.8867514, 2.8867514}, "Magnitude Clamp failed");

  // Close
  assert((Vec3f){10,10,10.004}.close({10,10,10}, 0.005), "Close failed");
}


fn void v4_overloads() @test {
  assert((Vec4f)                {10,10,10,10} == {10,10,10,10},     "Equivalent failed");
  assert((Vec4f){10,10,10,10} + {10,10,10,10} == {20,20,20,20},     "Addition failed");
  assert((Vec4f){10,10,10,10} - {10,10,10,10} == {0,0,0,0},         "Subtraction failed");
  assert((Vec4f){10,10,10,10} * {10,10,10,10} == {100,100,100,100}, "Multiplication failed");
  assert((Vec4f){10,10,10,10} / {10,10,10,10} == {1,1,1,1},         "Division failed");
}

fn void v4_overloads_assign() @test {
  Vec4f addition       = {10,10,10,10};
  Vec4f subtraction    = {10,10,10,10};
  Vec4f multiplication = {10,10,10,10};
  Vec4f division       = {10,10,10,10};

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
  assert((Vec4f){10,10,10,10} + 10 == {20,20,20,20},     "Addition failed");
  assert((Vec4f){10,10,10,10} - 10 == {0,0,0,0},         "Subtraction failed");
  assert((Vec4f){10,10,10,10} * 10 == {100,100,100,100}, "Multiplication failed");
  assert((Vec4f){10,10,10,10} / 10 == {1,1,1,1},         "Division failed");
}

fn void v4_overloads_assign_float() @test {
  Vec4f addition       = {10,10,10,10};
  Vec4f subtraction    = {10,10,10,10};
  Vec4f multiplication = {10,10,10,10};
  Vec4f division       = {10,10,10,10};

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
  // Conversions
  assert((Vec4f){10,10,10,10}.xy  == {10,10}, "Conversion to Vec2f failed");
  assert((Vec4f){10,10,10,10}.xyz == {10,10,10}, "Conversion to Vec4f failed");
  
  // Length
  assert((Vec4f){10,10,10,10}.length()        ==  20, "Length failed");
  assert((Vec4f){10,10,10,10}.length().pow(2) == 400, "Length square failed");

  // Dot product
  assert((Vec4f){10,10,10,10}.dot({10,10,10,10}) == 400, "Dot product failed");

  // Distance
  assert((Vec4f){10,10,10,10}.distance({20,20,20,20}).pow(2) == 400, "Distance square failed");
  assert((Vec4f){10,10,10,10}.distance({20,20,20,20})        ==  20, "Distance failed");

  // Normalize
  assert((Vec4f){10,10,10,10}.normalize() == {0.5,0.5,0.5,0.5}, "Normalize failed");

  // Min/Max
  assert((Vec4f){10,10,10,10}.min({ 0, 0, 0, 0}) == { 0, 0, 0, 0}, "Minimum failed");
  assert((Vec4f){10,10,10,10}.max({20,20,20,20}) == {20,20,20,20}, "Maximum failed");

  // Move towards/Lerp
  assert((Vec4f){10,10,10,10}.move_towards({20,20,20,20}, 5) == {12.5,12.5,12.5,12.5}, "Move towards failed");
  assert((Vec4f){10,10,10,10}.lerp({20,20,20,20},0.5) == {15,15,15,15}, "Lerp failed");

  // Invert
  assert((Vec4f){10,10,10,10}.invert() == {0.1,0.1,0.1,0.1}, "Invert failed");
}



