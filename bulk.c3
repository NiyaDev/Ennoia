
module ennoia::bulk;
import ennoia;
import std::io;
import std::collections;


const char VERSION_MAJOR = 3;
const char VERSION_MINOR = 0;

struct TableEntry {
  String name;
  ulong length, pointer;
  DataType type;
  CompType comp;
}
enum DataType : short {
  EMPTY,
  RAW,
  TEXT,
  KEYBIND,
  OPTION,
  //LOCALIZATION,
  
  // OpenGL/SDL3
  TEXTURE,
  FONT,
  SHADER,
  MODEL,
  MATERIAL,
}
enum CompType : short {
  NONE,
  DEFLATE,
}
alias BulkTable = HashMap{String, TableEntry};



<* Load file from Bulk raw
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn char[] load(String filepath, String dataname) {
  File? file = file::open(filepath, "rb");
  if (catch file) {
    io::printfn("[ERROR] - ENNOIA::BULK::LOAD [Failed to open file %s]", filepath);
    return {};
  }

  // Ensure correct version
  assert(file.read_byte()!! >= VERSION_MAJOR, "[ERROR] - ENNOIA::BULK::LOAD [Incompatible Major version %s]",filepath);
  assert(file.read_byte()!! == VERSION_MINOR, "[ERROR] - ENNOIA::BULK::LOAD [Incompatible Minor version %s]",filepath);

  // Skip reserved
  file.read_byte()!!;
  file.read_byte()!!;

  // Read number of entries
  short num = file.read_short();

  TableEntry tableEntry = get_table_entry(filepath, dataname);
  file.seek(tableEntry.pointer)!!;
  
  // Read into array
  char[] data = mem::new_array(char, tableEntry.length);
  for (int i; i < tableEntry.length; i++) data[i] = file.read_byte()!!;

  // Decompress data

  file.close()!!;

  return data;
}


<* Shorthand for loading a texture from a bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn Texture load_texture(String filepath, String dataname, bool send = true) {
  char[] data = load(filepath, dataname);
  defer free(data);

  Texture tex = texture::load_from_mem(data);

  if (send) ennoia::textures.set(dataname, tex);

  return tex;
}
<* Shorthand for loading a font from a bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn Font load_font(String filepath, String dataname, bool send = true) {
  char[] data = load(filepath, dataname);
  defer free(data);

  Font font = font::load_from_mem(data[2..], {(float)data[0], (float)data[1]});

  if (send) ennoia::fonts.set(dataname, font);

  return font;
}
<* Shorthand for loading a font from a bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn Model load_model(String filepath, String dataname, bool send = true, bool getMaterial = true) {
  Model output;

  char[] data = load(filepath,dataname);
  defer free(data);
  char[] mtl;

  if (getMaterial) {
    // Get material name and load file
    String[] split = ((String)data).tsplit("\n");
    for (int i; i < split.len; i++) {
      String[] splitTwo = split[i].tsplit(" ");
      if (splitTwo[0] == "mtllib") {
        String[] nameSplit = splitTwo[1].tsplit(".");
        mtl = bulk::load(filepath,nameSplit[0]);
        break;
      }
    }

    // Load mesh
    output = mesh::load_from_mem((String)data);

    // Iterate through material file to find material and load data
    output.@each(; String key, Mesh val) {
      bool myMat = false;
      String[] mtlSplit = ((String)mtl).tsplit("\n");
      for (int i; i < mtlSplit.len; i++) {
        String[] line = mtlSplit[i].tsplit(" ");
        switch (line[0]) {
          case "newmtl": // Material definition
            if (line[1] == val.materialName) {
              myMat = true;
            } else { myMat = false; }
          case "map_Kd": // Texture name
            if (myMat) {
              String[] nameSplit = line[1].tsplit(".");
              Mesh* temp = output.get_ref(key)!!;
              temp.texture = mem::new(Texture);
              *temp.texture = bulk::load_texture(filepath, nameSplit[0]);
            }
        }
      }
    };
    free(mtl);
  } else {
    output = mesh::load_from_mem((String)data);
  }

  return output;

}
<* Shorthand for loading a font from a bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn Shader load_shader(String filepath, String dataname, bool send = true) {
  char[] data = load(filepath, dataname);
  defer free(data);

  usz counter;
  usz vsSize = (usz)data[counter++]        + ((usz)data[counter++] <<  8) +
              ((usz)data[counter++] << 16) + ((usz)data[counter++] << 24) +
              ((usz)data[counter++] << 32) + ((usz)data[counter++] << 40) +
              ((usz)data[counter++] << 48) + ((usz)data[counter++] << 56);
  usz fsSize = (usz)data[vsSize+counter++]        + ((usz)data[vsSize+counter++] <<  8) +
              ((usz)data[vsSize+counter++] << 16) + ((usz)data[vsSize+counter++] << 24) +
              ((usz)data[vsSize+counter++] << 32) + ((usz)data[vsSize+counter++] << 40) +
              ((usz)data[vsSize+counter++] << 48) + ((usz)data[vsSize+counter++] << 56);
  Shader shader = shader::compile((String)data[8:vsSize],(String)data[vsSize+16:fsSize]);

  return shader;
}
<* Shorthand for loading a keybind from a bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn Keybind load_keybind(String filepath, String dataname, bool send = true) {
  char[] data = load(filepath, dataname);
  defer free(data);

  Keybind kb = {
    ((uint)(data[0])) + ((uint)(data[1]) << 8) + ((uint)(data[2]) << 16) + ((uint)(data[3]) << 24),
    ((ushort)(data[4])) + ((ushort)(data[5]) << 8),
  };

  if (send) ennoia::keybinds.set(dataname,kb);

  return kb;
}
<* Shorthand for loading an option from a bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
  @param send: "If true, it adds it to the keybinds global registry"
 *>
fn Option load_option(String filepath, String dataname, bool send = true) {
  char[] data = load(filepath, dataname);
  defer free(data);

  Option opt;
  opt.type = OptionType.from_ordinal(data[0]); 

  switch (opt.type) {
    case CHAR:
      opt.data.as_char   = data[1];
    case SHORT:
      short sh;
      mem::copy(&sh, &data[1], 2);
      opt.data.as_short  = sh;
    case INT:
      int sh;
      mem::copy(&sh, &data[1], 4);
      opt.data.as_int    = sh;
    case LONG:
      long sh;
      mem::copy(&sh, &data[1], 8);
      opt.data.as_long   = sh;

    case FLOAT:
      float sh;
      mem::copy(&sh, &data[1], 4);
      opt.data.as_float  = sh;
    case DOUBLE:
      double sh;
      mem::copy(&sh, &data[1], 8);
      opt.data.as_double = sh;

    case STRING:
      String str = (String)mem::new_array(char,(usz)data[1]);
      mem::copy(&str, &data[2], data[1]);
      opt.data.as_string = str;
  }

  if (send) ennoia::options.set(dataname, opt);

  return opt;
}
<* Shorthand for loading a set of localization strings from a bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
  @param send: "If true, it adds it to the keybinds global registry"
 *>
fn Localization load_local(String filepath, String dataname, bool send = true) {
  char[] data = load(filepath,dataname);
  defer free(data);
  Yaml y = yaml::parse((String)data);

  Localization output;

  y.@each(; String key, TypedValue val) {
    Local local;
    assert(val.type == OBJECT, "[ERROR] - ENNOIA::BULK::LOAD_LOCAL [Attempted to load localization that wasn't in the proper format.]");
    
    //yaml::Object o = *((yaml::Object*)val.value);
    yaml::Object o = val.as_object;
    o.@each(; String key_inner, TypedValue val_inner) {
      assert(val_inner.type == STRING, "[ERROR] - ENNOIA::BULK::LOAD_LOCAL [Attempted to load localization that wasn't in the proper format.]");
      local.set(key, val_inner.as_string);
    };

    output.set(key, local);
  };

  if (send) ennoia::localization += &output;
  
  return output;
}

<**>
fn void load_all(String filepath) {
  BulkTable tbls = get_table(filepath);

  tbls.@each(; String key, TableEntry val) {
    switch (val.type) {
      case KEYBIND: load_keybind(filepath, key, true);
      case OPTION:  load_option(filepath, key, true);
      //case LOCALIZATION:
      case TEXTURE: load_texture(filepath, key, true);
      case FONT:    load_font(filepath, key, true);
      //case SHADER:
      default: io::printfn("[WARNING] - ENNOIA::BULK::LOAD_ALL [Attempted to use load all on a file that contains incompatible file types. %s]", val.type);
    }
  };
}

<* Loads all textures in file
  @param filepath: "File path of file to load"
  @require filepath != ""
 *>
fn void load_all_textures(String filepath, bool send = true) {
  BulkTable tbls = get_table(filepath);

  tbls.@each(; String key, TableEntry val) {
    if (val.type == TEXTURE) load_texture(filepath, key, send);
  };
}
<* Loads all keybinds in file
  @param filepath: "File path of file to load"
  @require filepath != ""
 *>
fn void load_all_keybinds(String filepath, bool send = true) {
  BulkTable tbls = get_table(filepath);

  tbls.@each(; String key, TableEntry val) {
    if (val.type == KEYBIND) load_keybind(filepath, key, send);
  };
}
<* Loads all options in file
  @param filepath: "File path of file to load"
  @require filepath != ""
 *>
fn void load_all_options(String filepath, bool send = true) {
  BulkTable tbls = get_table(filepath);

  tbls.@each(; String key, TableEntry val) {
    if (val.type == OPTION) load_option(filepath, key, send);
  };
}
<* Loads all localizations in file
  @param filepath: "File path of file to load"
  @require filepath != ""
 *>
fn void load_all_localization(String filepath, bool send = true) {
  BulkTable tbls = get_table(filepath);

  tbls.@each(; String key, TableEntry val) {
    
  };
}

<* Gets a list of entries inside bulk
  @param filepath: "Bulk file to get entries from"
  @require filepath != ""
 *>
fn String[] get_entries(String filepath) {
  List{String} list;
  File? file = file::open(filepath, "rb");
  if (catch file) {
    io::printfn("[ERROR] - ENNOIA::BULK::GET_ENTRIES [Failed to open file %s]", filepath);
    return {};
  }

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
<* Gets a list of entries inside bulk
  @param filepath: "Bulk file to get entries from"
  @require filepath != ""
 *>
fn BulkTable get_table(String filepath) {
  BulkTable output;
  File? file = file::open(filepath, "rb");
  if (catch file) {
    io::printfn("[ERROR] - ENNOIA::BULK::GET_ENTRIES [Failed to open file %s]", filepath);
    return {};
  }

  // Ensure correct version
  assert(file.read_byte()!! >= VERSION_MAJOR, "[ERROR] - ENNOIA::BULK::LOAD [Incompatible version]");
  assert(file.read_byte()!! == VERSION_MINOR, "[ERROR] - ENNOIA::BULK::LOAD [Incompatible version]");
  
  // Skip reserved
  file.read_byte()!!;
  file.read_byte()!!;

  // Read number of entries
  short num = file.read_short();

  // Grab all entries
  for (int i; i < num; i++) {
    TableEntry ent;

    ent.name = file.read_string();
    ent.length = file.read_long();
    ent.pointer = file.read_long();
    ent.type = DataType.from_ordinal(file.read_short());
    ent.comp = CompType.from_ordinal(file.read_short());

    output.set(ent.name, ent);
  }

  file.close()!!;

  return output;
}
<* Load file from Bulk raw
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn TableEntry get_table_entry(String filepath, String dataname) {
  HashMap{String, TableEntry} map = get_table(filepath);
  TableEntry output = map[dataname]!!;
  map.free();
  return output;
}
<* Get length of entry data
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn usz get_entry_len(String filepath, String dataname) {
  File? file = file::open(filepath, "rb");
  if (catch file) {
    io::printfn("[ERROR] - ENNOIA::BULK::ENTRY_LEN [Failed to open file %s]", filepath);
    return {};
  }

  // Ensure correct version
  assert(file.read_byte()!! >= VERSION_MAJOR, "[ERROR] - ENNOIA::BULK::LOAD [Incompatible version]");
  assert(file.read_byte()!! == VERSION_MINOR, "[ERROR] - ENNOIA::BULK::LOAD [Incompatible version]");
  
  // Read number of entries
  short num = file.read_short();

  // Find data
  usz length;
  for (int i; i < num; i++) {
    String str = file.read_string();
    if (str == dataname) {
      str.free(allocator::heap());
      return file.read_long();
    }
    str.free(allocator::heap());
  }
  return -1;
}
<* Gets postion of data inside bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn usz get_entry_ptr(String filepath, String dataname) {
  File? file = file::open(filepath, "rb");
  if (catch file) {
    io::printfn("[ERROR] - ENNOIA::BULK::ENTRY_PTR [Failed to open file %s]", filepath);
    return {};
  }

  // Ensure correct version
  assert(file.read_byte()!! >= VERSION_MAJOR, "[ERROR] - ENNOIA::BULK::LOAD [Incompatible version]");
  assert(file.read_byte()!! == VERSION_MINOR, "[ERROR] - ENNOIA::BULK::LOAD [Incompatible version]");
  
  // Read number of entries
  short num = file.read_short();

  // Find data
  usz length;
  for (int i; i < num; i++) {
    String str = file.read_string();
    if (str == dataname) {
      str.free(allocator::heap());
      file.read_long();
      return file.read_long();
    }
    str.free(allocator::heap());
  }
  return -1;
}


// Table Entry
<* == Overload *>
fn bool TableEntry.equals_str(&self, String rhs) @operator(==) {
  return self.name == rhs;
}
<**>
fn usz TableEntry.size(&self) {
  return (self.name.len + 1) + (long.sizeof * 2) + (short.sizeof * 2);
}


// File reading

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
<**>
fn void File.write_string(&self, String val) {
  for (int i; i < val.len; i++) {
    self.write_byte(val[i])!!;
  }
  self.write_byte('\0')!!;
}

