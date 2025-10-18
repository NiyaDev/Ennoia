
module ennoia::bulk;
import ennoia::debug;
import std::io;
import std::collections;


alias BulkTable = HashMap{String, TableEntry};

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
  LOCALIZATION,
  
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

<* == Overload *>
fn bool TableEntry.equals_str(&self, String rhs) @operator_s(==) @export("tableentry_equals") {
  return self.name == rhs;
}
<* Gets the size of the entry *>
fn usz TableEntry.size(&self) @export("tableentry_size") {
  return (self.name.len + 1) + (ulong.sizeof * 2) + (short.sizeof * 2);
}

<* Gets a list of entries inside bulk
  @param filepath: "Bulk file to get entries from"
  @require filepath != ""
 *>
fn String[] get_entries(String filepath) @export("tableentry_getentries") {
  List{String} list;

  File? file = file::open(filepath, "rb");
  if (catch file) {
    debug::error(false, "Failed to open file. [%s]", filepath);
    return {};
  }

  // Ensure correct version
  debug::error(file.read_byte()!! >= VERSION_MAJOR, "Incompatible Major version. [%s]", filepath);
  debug::error(file.read_byte()!! == VERSION_MINOR, "Incompatible Minor version. [%s]", filepath);
  
  // Skip two bytes
  file.read_short();

  // Get entry count
  short count = file.read_short();

  // Find data
  for (int i; i < count; i++) {
    String name = file.read_string();
    if (name.len == 0) break;

    file.read_long();
    file.read_long();

    list.push(name);
  }

  String[] output = list.to_tarray();
  list.free();

  return output;
}
<* Gets a list of entries inside bulk
  @param filepath: "Bulk file to get entries from"
  @require filepath != ""
 *>
fn BulkTable get_table(String filepath) @export("tableentry_gettable") {
  BulkTable output;

  File? file = file::open(filepath, "rb");
  if (catch file) {
    debug::error(false, "Failed to open file. [%s]", filepath);
    return {};
  }

  // Ensure correct version
  debug::error(file.read_byte()!! >= VERSION_MAJOR, "Incompatible Major version. [%s]", filepath);
  debug::error(file.read_byte()!! == VERSION_MINOR, "Incompatible Minor version. [%s]", filepath);
  
  // Skip two bytes
  file.read_short();

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
<* Load specific entry from bulk
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn TableEntry get_table_entry(String filepath, String dataname) @export("tableentry_gettableentry") {
  BulkTable map = get_table(filepath);
  TableEntry output = map[dataname]!!;
  map.free();
  return output;
}

