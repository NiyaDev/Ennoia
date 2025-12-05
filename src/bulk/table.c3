
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
  defer list.free();

  File? file = file::open(filepath, "rb");
  if (catch excuse = file) {
    debug::error("Failed to open file. %s", filepath);
    return {};
  }
  defer file.close()!!;

  // Check header
  if (catch excuse = file.check_header()) return {};

  // Get entry count
  short? count = file.read_short();
  if (catch excuse = count) {
    debug::warning("Failed to get bulk entry count.");
    return {};
  }

  // Find data
  for (int i; i < count; i++) {
    String? name = file.read_string();
    if (catch excuse = name) {
      debug::warning("Failed to read bulk entry name.");
      continue;
    }
    if (name.len == 0) break;

    long? length = file.read_long();
    if (catch excuse = length) {
      debug::warning("Failed to read bulk entry length.");
      continue;
    }
    long? pointer = file.read_long();
    if (catch excuse = pointer) {
      debug::warning("Failed to read bulk entry pointer.");
      continue;
    }
    short? type = file.read_short();
    if (catch excuse = type) {
      debug::warning("Failed to read bulk entry type.");
      continue;
    }
    short? compression = file.read_short();
    if (catch excuse = compression) {
      debug::warning("Failed to read bulk entry compression type.");
      continue;
    }

    list.push(name);
  }

  // Create output
  String[] output = list.to_tarray();

  return output;
}
<* Gets a list of entries inside bulk
  @param filepath: "Bulk file to get entries from"
  @require filepath != ""
 *>
fn BulkTable get_table(String filepath) @export("tableentry_gettable") {
  BulkTable output;

  File? file = file::open(filepath, "rb");
  if (catch excuse = file) {
    debug::error("Failed to open file. %s", filepath);
    return {};
  }
  defer file.close()!!;

  // Check header
  if (catch excuse = file.check_header()) return {};

  // Get entry count
  short? count = file.read_short();
  if (catch excuse = count) {
    debug::warning("Failed to get bulk entry count.");
    return {};
  }

  // Grab all entries
  for (int i; i < count; i++) {
    String? name = file.read_string();
    if (catch excuse = name) {
      debug::warning("Failed to read bulk entry name.");
      continue;
    }
    long? length = file.read_long();
    if (catch excuse = length) {
      debug::warning("Failed to read bulk entry length.");
      continue;
    }
    long? pointer = file.read_long();
    if (catch excuse = pointer) {
      debug::warning("Failed to read bulk entry pointer.");
      continue;
    }
    short? type = file.read_short();
    if (catch excuse = type) {
      debug::warning("Failed to read bulk entry type.");
      continue;
    }
    short? compression = file.read_short();
    if (catch excuse = compression) {
      debug::warning("Failed to read bulk entry compression type.");
      continue;
    }

    TableEntry entry = {
      name,
      length,
      pointer,
      DataType.from_ordinal(type),
      CompType.from_ordinal(compression),
    };

    output.set(name, entry);
  }

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

faultdef INCORRECT_VERSION;
<* Checks whether the header of the bulk file is correct *>
fn void? File.check_header(&self) {
  char? major = self.read_byte();
  if (catch excuse = major) {
    debug::warning("Failed to read Major Version.");
    return excuse?;
  }
  char? minor = self.read_byte();
  if (catch excuse = minor) {
    debug::warning("Failed to read Minor Version.");
    return excuse?;
  }

  if (major != VERSION_MAJOR || minor != VERSION_MINOR) {
    debug::warning("Version incorrect.");
    return INCORRECT_VERSION?;
  }

  self.read_short()!;

  return;
} 
