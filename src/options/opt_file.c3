
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
        length += val.as_string.len;
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
        if (catch excuse = file.write_byte(val.as_char)) {
          debug::warning("Failed to write char option to file.");
          continue;
        }
      case SHORT:
        if (catch excuse = file.write_short(val.as_short)) {
          debug::warning("Failed to write short option to file.");
          continue;
        }
      case INT:
        if (catch excuse = file.write_int(val.as_int)) {
          debug::warning("Failed to write int option to file.");
          continue;
        }
      case LONG:
        if (catch excuse = file.write_long(val.as_long)) {
          debug::warning("Failed to write long option to file.");
          continue;
        }

      case FLOAT:
        if (catch excuse = file.write_float(val.as_float)) {
          debug::warning("Failed to write float option to file.");
          continue;
        }
      case DOUBLE:
        if (catch excuse = file.write_double(val.as_double)) {
          debug::warning("Failed to write double option to file.");
          continue;
        }

      case STRING:
        if (catch excuse = file.write_string(val.as_string)) {
          debug::warning("Failed to write string option to file.");
          continue;
        }
    }

    if (catch excuse = file.close()) {
      debug::warning("Failed to close file.");
      continue;
    }
  }
}

