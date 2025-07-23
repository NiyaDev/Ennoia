
module ennoia::bulk;
import ennoia;
import std::io;
import std::collections;


const char VERSION_MAJOR = 2;
const char VERSION_MINOR = 0;


<* Load file from Bulk
  @param filepath: "Path to bulk file"
  @param dataname: "Name of data inside bulk file"
 *>
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
      file.seek(file.read_long())!!;
      break;
    } else {
    }
  }

  char[] data = mem::new_array(char, length);
  for (int i; i < length; i++) data[i] = file.read_byte()!!;

  file.close()!!;

  return data;
}
<* Shorthand for loading a texture from a bulk file
  @param filepath: "Path to bulk file"
  @param dataname: "Name of data inside bulk file"
 *>
fn Texture load_texture(String filepath, String dataname) {
  char[] data = load(filepath, dataname);

  return texture::load_from_mem(data);
}
<* Shorthand for loading a keybind from a bulk file
  @param filepath: "Path to bulk file"
  @param dataname: "Name of data inside bulk file"
 *>
fn void load_keybind(String filepath, String dataname) {
  char[] data = load(filepath, dataname);

  Keybind kb = {
    ((uint)(data[0])) + ((uint)(data[1]) << 8) + ((uint)(data[2]) << 16) + ((uint)(data[3]) << 24),
    ((ushort)(data[4])) + ((ushort)(data[5]) << 8),
  };

  keybinds::binds.set(dataname,kb);
}
<* Shorthand for loading an option from a bulk file
  @param filepath: "Path to bulk file"
  @param dataname: "Name of data inside bulk file"
 *>
fn void load_option(String filepath, String dataname) {
  char[] data = load(filepath, dataname);

  Option opt;
  opt.type = OptionType.from_ordinal(data[0]);

  switch (opt.type) {
    case CHAR:
      opt.data.as_char   =    data[1];
    case SHORT:
      opt.data.as_short  = *(&data[1]);
    case INT:
      opt.data.as_int    = *(&data[1]);
    case LONG:
      opt.data.as_long   = *(&data[1]);

    case FLOAT:
      opt.data.as_float  = *(&data[1]);
    case DOUBLE:
      opt.data.as_double = *(&data[1]);
  }

  options::options.set(dataname, opt);
}

<* Loads all keybinds in file
  @param filepath: "File path of file to load"
 *>
fn void load_all_keybinds(String filepath) {
  String[] entries = bulk::get_entries(filepath);

  for (int i; i < entries.len; i++) {
    bulk::load_keybind(filepath, entries[i]);
  }
}
<* Loads all keybinds in file
  @param filepath: "File path of file to load"
 *>
fn void load_all_options(String filepath) {
  String[] entries = bulk::get_entries(filepath);

  for (int i; i < entries.len; i++) {
    bulk::load_option(filepath, entries[i]);
  }
}

<* Gets a list of entries inside bulk
  @param filepath: "Bulk file to get entries from"
 *>
fn String[] get_entries(String filepath) {
  if (file::get_size(filepath)!! < 4) return {};

  List{String} list;
  File file = file::open(filepath, "rb")!!;

  // Ensure correct version
  assert(file.read_byte()!! >= VERSION_MAJOR, "[ERROR] - ENNOIA::BULK::LOAD [Incompatible version]");
  assert(file.read_byte()!! == VERSION_MINOR, "[ERROR] - ENNOIA::BULK::LOAD [Incompatible version]");
  
  // Skip bytes
  file.read_byte()!!;
  file.read_byte()!!;

  // Find data
  while (true) {
    String name = file.read_string();
    if (name.len == 0) break;

    file.read_long();
    file.read_long();

    list.push(name);
  }

  String[] output = list.to_array(allocator::heap());
  list.free();

  return output;
}
<* Get length of entry data
  @param filepath: "Bulk file to get entry from"
  @param dataname: "Entry name to get length of"
 *>
fn usz get_entry_len(String filepath, String dataname) {
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
      return file.read_long();
    }
  }
}
<* Gets postion of data inside bulk file
  @param filepath: "Bulk file to get entry from"
  @param dataname: "Entry name to get position of"
 *>
fn usz get_entry_ptr(String filepath, String dataname) {
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
      file.read_long();
      return file.read_long();
    }
  }
}

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


<* Reads a short from file since the base language doesn't have one *>
fn void File.write_short(&self, short val) {
  self.write_byte((char)(val >>  0))!!;
  self.write_byte((char)(val >>  8))!!;
}
<* Reads a int from file since the base language doesn't have one *>
fn void File.write_int(&self, int val) {
  self.write_byte((char)(val >>  0))!!;
  self.write_byte((char)(val >>  8))!!;
  self.write_byte((char)(val >> 16))!!;
  self.write_byte((char)(val >> 24))!!;
}
<* Reads a long from file since the base language doesn't have one *>
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

<* Reads a float from file since the base language doesn't have one *>
fn void File.write_float(&self, float val) {
  char[] dat = mem::new_array(char, 4);
  mem::copy(dat, &val, 4);

  self.write_byte(dat[0])!!;
  self.write_byte(dat[1])!!;
  self.write_byte(dat[2])!!;
  self.write_byte(dat[3])!!;
}
<* Reads a double from file since the base language doesn't have one *>
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

