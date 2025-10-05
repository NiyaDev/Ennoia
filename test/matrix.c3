
import std::io;
import std::math;



fn void std() @test {
  Matrix4f mat1 = MATRIX4F_IDENTITY;
  Matrix4f mat2 = MATRIX4F_IDENTITY.translate({2,10,0});
  Matrix4f temp = MATRIX4F_IDENTITY;

  assert(mat1 != mat2, "Equivalent failed");

  assert(temp + mat2 == (Matrix4f){2,0,0, 2,0,2,0, 10,0,0,2,0,0,0,0,2}, "Addition failed");
  assert(temp - mat2 == (Matrix4f){0,0,0,-2,0,0,0,-10,0,0,0,0,0,0,0,0}, "Subtraction failed");
  assert(mat2 * mat2 == (Matrix4f){1,0,0, 4,0,1,0, 20,0,0,1,0,0,0,0,1}, "Multiplication failed");
  assert(mat2.determinant() == 1, "Determinate failed");
  assert(mat2.trace() == 4, "Trace failed");
  assert(mat2.transpose() == (Matrix4f){1,0,0,0,0,1,0,0,0,0,1,0, 2, 10,0,1}, "Transpose failed");
  assert(mat2.inverse()!! == (Matrix4f){1,0,0,-2,0,1,0,-10,0,0,1,0,0,0,0,1}, "Inverse failed");

  assert(mat2.translate({2,-2,1}) == (Matrix4f){1,0,0,4,0,1,0,8,0,0,1,1,0,0,0,1}, "Translate failed");
  assert(mat2.rotate_x(90 * (math::PI / 180)) == (Matrix4f){1,0,0,2, 0,-0.00000004371139,-1,10, 0,1,-0.00000004371139,0, 0,0,0,1}, "X Rotation failed");
  assert(mat2.rotate_y(90 * (math::PI / 180)) == (Matrix4f){-0.00000004371139,0,-1,2,  0,1,0,10, 1,0,-0.00000004371139,0, 0,0,0,1}, "Y Rotation failed");
  assert(mat2.rotate_z(90 * (math::PI / 180)) == (Matrix4f){-0.00000004371139,-1,0,2, 1,-0.00000004371139,0,10, 0,0,1,0, 0,0,0,1}, "Z Rotation failed");
  assert(mat2.scale({1.5,1.5,1.5}) == (Matrix4f){1.5,0,0,2, 0,1.5,0,10, 0,0,1.5,0, 0,0,0,1}, "Scale failed");

  // TODO: Frustum
  assert(matrix::perspective{float}(70 * (math::PI / 180), 1.777, 0.1, 100) == (Matrix4f){
    0.8036849, 0,         0,         0,
    0,         1.428148,  0,         0,
    0,         0,        -1.002002, -0.2002002,
    0,         0,        -1,         0,
  }, "Perspective matrix failed");
  // TODO: Ortho
  assert(matrix::look_at{float}({0,10,5}, {0,0,0}, {0,1,0}) == (Matrix4f){
    0.99999994, 0,          0,            0,
    0,          0.4472136, -0.8944272,    0,
    0,          0.89442724, 0.44721361, -11.18034,
    0,          0,          0,            1,
    }, "View matrix failed");
}

/*

  My version of the 4x4 float Matrix is gone,
  but this is here to memorialize the three days it took
  to realize the reason why it wasn't working after starting
  to use the std::math Matrix4f, was that i never transposed
  the Perspective matrix in system/core.c3...

fn void mine() @test {
  Matrix mat1 = matrix::IDENTITY;
  Matrix mat2 = matrix::IDENTITY.translate({2,10,0});
  Matrix temp = matrix::IDENTITY;

  assert(mat1 != mat2, "Equivalent failed");
  assert(temp + mat2 == {2,0,0,0,0,2,0,0,0,0,2,0, 2, 10,0,2}, "Addition failed");
  assert(temp - mat2 == {0,0,0,0,0,0,0,0,0,0,0,0,-2,-10,0,0}, "Subtraction failed");
  assert(mat2 * mat2 == {1,0,0,0,0,1,0,0,0,0,1,0, 4, 20,0,1}, "Multiplication failed");
  assert(mat2.determinant() == 1, "Determinate failed");
  assert(mat2.trace() == 4, "Trace failed");
  assert(mat2.transpose() == {1,0,0, 2,0,1,0, 10,0,0,1,0,0,0,0,1}, "Transpose failed");
  assert(mat2.invert() == {1,0,0,0,0,1,0,0,0,0,1,0,-2,-10,0,1}, "Inverse failed");
  
  assert(mat2.translate({2,-2,1}) == {1,0,0,0,0,1,0,0,0,0,1,0,4,8,1,1}, "Translate failed");
  assert(matrix::rotate_x(90 * (math::PI / 180)) * mat2 == {1,0,0,0, 0,-0.00000004371139,1,0, 0,-1,-0.00000004371139,0, 2,10,0,1}, "X Rotation failed");
  assert(matrix::rotate_y(90 * (math::PI / 180)) * mat2 == {-0.00000004371139,0,-1,0,  0,1,0,0, 1,0,-0.00000004371139,0, 2,10,0,1}, "Y Rotation failed");
  assert(matrix::rotate_z(90 * (math::PI / 180)) * mat2 == {-0.00000004371139,1,0,0, -1,-0.00000004371139,0,0, 0,0,1,0, 2,10,0,1}, "Z Rotation failed");
  assert(mat2.scale({1.5,1.5,1.5}) == {1.5,0,0,0, 0,1.5,0,0, 0,0,1.5,0, 2,10,0,1}, "Scale failed");

  matrix::perspective(70 * (math::PI / 180), 1.777, 0.1, 100).print();
  assert(matrix::perspective(70 * (math::PI / 180), 1.777, 0.1, 100) == {
    0.8036849, 0,         0,         0,
    0,         1.4281481, 0,         0,
    0,         0,        -1.002002, -1,
    0,         0,        -0.2002002, 0,
  }, "Perspective matrix failed");
  assert(matrix::look_at({0,10,5}, {0,0,0}, {0,1,0}) == {
    0.99999994,  0,            0,          0,
    0,           0.4472136,    0.89442724, 0,
    0,          -0.8944272,    0.44721362, 0,
    0,           0,          -11.18034,    1,
    }, "View matrix failed");
}
*

