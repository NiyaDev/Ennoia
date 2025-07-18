
module ennoia::bulk;
import std::io;
import std::collections;


const char VERSION_MAJOR = 2;
const char VERSION_MINOR = 0;
//const char VERSION_PATCH = 0;

//alias Entry = char[];
/*
struct Bulk {
  String name;
  String path;

  char major, minor, patch;

  HashMap{String, Entry} entries;
}

struct Entry {
  Compression compression;

  char[] data;
}

enum Compression {
  NONE,
  DEFLATE,
}
*/


<**>
fn char[] load(String filepath, String dataname) {
  File file = file::open(filepath, "rb")!!;

  // Ensure correct version
  assert(file.read_byte()!! >= VERSION_MAJOR, "[ERROR] - ENNOIA::BULK::LOAD [Incompatible version]");
  assert(file.read_byte()!! == VERSION_MINOR, "[ERROR] - ENNOIA::BULK::LOAD [Incompatible version]");
  
  // Skip bytes
  file.read_byte()!!;
  file.read_byte()!!;

  // Find data
  usz length;
  for (int i; true; i++) {
    String str = file.read_string();
    if (str == dataname) {
      length = file.read_long();
      io::printfn("%d", length);
      file.seek(file.read_long())!!;
      break;
    } else {
      file.read_long();
      file.read_long();
    }
  }

  char[] data = mem::new_array(char, length);
  for (int i; i < length; i++) data[i] = file.read_byte()!!;

  file.close()!!;

  return data;
}


<* Reads a short from file since the base language doesn't have one *>
fn short File.read_short(&self) {
  return ((short)self.read_byte()!!)       + ((short)self.read_byte()!! <<  8);
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

  char curr_char = 'b';
  for (int i; curr_char != '\0'; i++) {
    curr_char = self.read_byte()!!;
    if (curr_char == '\0') break;
    
    constr.push(curr_char);
  }

  String output = (String)constr.to_array(allocator::heap());
  constr.free();
  return output;
}

