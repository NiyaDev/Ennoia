
module ennoia::options;
import std::collections;
import std::io;
import ennoia::debug;


<* Saves all options as a file *>
fn void save_options() @export("options_save") {
  // Calculate size of file
  usz length;
  ennoia::options.@each(; String key, Option val) {
    length += key.len + 1;
    switch (val.type) {
      case CHAR:
        length += 1;
      case SHORT:
        length += 2;
      case INT:
        length += 4;
      case LONG:
        length += 8;

      case FLOAT:
        length += 4;
      case DOUBLE:
        length += 8;

      case STRING:
        length += val.data.as_string.len;
    }
  };

  // Create file
  String[] keys = ennoia::options.tkeys();
  for (int i; i < keys.len; i++) {
    Option? val = ennoia::options[keys[i]];
    if (catch excuse = val) {
      debug::warning("Somehow there was a key that both exists and doesn't.");
      continue;
    }

    File? file = file::open(keys[i], "wb");
    if (catch excuse = file) {
      debug::warning("Failed to create file %s.", keys[i]);
      continue;
    }

    if (catch excuse = file.write_byte(val.type.ordinal)) {
      debug::warning("Failed to write option type to file.");
      continue;
    }

    switch (val.type) {
      case CHAR:
        if (catch excuse = file.write_byte(val.data.as_char)) {
          debug::warning("Failed to write char option to file.");
          continue;
        }
      case SHORT:
        file.write_short(val.data.as_short);
      case INT:
        file.write_int(val.data.as_int);
      case LONG:
        file.write_long(val.data.as_long);

      case FLOAT:
        file.write_float(val.data.as_float);
      case DOUBLE:
        file.write_double(val.data.as_double);

      case STRING:
        file.write_string(val.data.as_string);
    }

    if (catch excuse = file.close()) {
      debug::warning("Failed to close file.");
      continue;
    }
  }
}

