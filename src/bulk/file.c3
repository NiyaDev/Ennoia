
module ennoia::bulk;
import std::io;
import std::collections;


<* Reads a short from file since the base language doesn't have one *>
fn short File.read_short(&self) {
  return ((short)self.read_byte()!!) + ((short)self.read_byte()!! <<  8);
}
<* Reads an int from file since the base language doesn't have one *>
fn int File.read_int(&self) {
  return ((int)self.read_byte()!!)       + ((int)self.read_byte()!! <<  8) +
         ((int)self.read_byte()!! << 16) + ((int)self.read_byte()!! << 24);
}
<* Reads a long from file since the base language doesn't have one *>
fn long File.read_long(&self) {
  return ((long)self.read_byte()!!)       + ((long)self.read_byte()!! <<  8) +
         ((long)self.read_byte()!! << 16) + ((long)self.read_byte()!! << 24) +
         ((long)self.read_byte()!! << 32) + ((long)self.read_byte()!! << 40) +
         ((long)self.read_byte()!! << 48) + ((long)self.read_byte()!! << 56);
}

<* Reads a float from file since the base language doesn't have one *>
fn float File.read_float(&self) {
  float output;
  char[] arr = mem::new_array(char, 4);
  self.read(arr)!!;
  mem::copy(&output, arr, 4);
  free(arr);

  return output;
}
<* Reads a double from file since the base language doesn't have one *>
fn double File.read_double(&self) {
  double output;
  char[] arr = mem::new_array(char, 8);
  self.read(arr)!!;
  mem::copy(&output, arr, 8);
  free(arr);

  return output;
}

<* Reads a string from file since the base language doesn't have one *>
fn String File.read_string(&self) {
  List{char} constr;

  // Copy all bytes into list until null termination
  char curr_char = 'b';
  for (int i; curr_char != '\0'; i++) {
    curr_char = self.read_byte()!!;
    if (curr_char == '\0') break;
    
    constr.push(curr_char);
  }

  // Copy list to String
  String output = (String)constr.to_tarray();
  // Cleanup list
  constr.free();

  return output;
}


<* Writes a short to file since the base language doesn't have one *>
fn void File.write_short(&self, short val) {
  self.write_byte((char)(val >>  0))!!;
  self.write_byte((char)(val >>  8))!!;
}
<* Writes a int to file since the base language doesn't have one *>
fn void File.write_int(&self, int val) {
  self.write_byte((char)(val >>  0))!!;
  self.write_byte((char)(val >>  8))!!;
  self.write_byte((char)(val >> 16))!!;
  self.write_byte((char)(val >> 24))!!;
}
<* Writes a long to file since the base language doesn't have one *>
fn void File.write_long(&self, long val) {
  self.write_byte((char)(val >>  0))!!;
  self.write_byte((char)(val >>  8))!!;
  self.write_byte((char)(val >> 16))!!;
  self.write_byte((char)(val >> 24))!!;
  self.write_byte((char)(val >> 32))!!;
  self.write_byte((char)(val >> 40))!!;
  self.write_byte((char)(val >> 48))!!;
  self.write_byte((char)(val >> 56))!!;
}

<* Writes a float to file since the base language doesn't have one *>
fn void File.write_float(&self, float val) {
  char[] dat = mem::new_array(char, 4);
  mem::copy(dat, &val, 4);

  self.write_byte(dat[0])!!;
  self.write_byte(dat[1])!!;
  self.write_byte(dat[2])!!;
  self.write_byte(dat[3])!!;
}
<* Writes a double to file since the base language doesn't have one *>
fn void File.write_double(&self, double val) {
  char[] dat = mem::new_array(char, 8);
  mem::copy(dat, &val, 8);

  self.write_byte(dat[0])!!;
  self.write_byte(dat[1])!!;
  self.write_byte(dat[2])!!;
  self.write_byte(dat[3])!!;
  self.write_byte(dat[4])!!;
  self.write_byte(dat[5])!!;
  self.write_byte(dat[6])!!;
  self.write_byte(dat[7])!!;
}
<* Writes a string to file since the base language doesn't have one *>
fn void File.write_string(&self, String val) {
  for (int i; i < val.len; i++) {
    self.write_byte(val[i])!!;
  }
  self.write_byte('\0')!!;
}

