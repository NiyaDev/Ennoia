
import ennoia;
import std::io;
import std::collections;


fn void getting_entries() @test {
  String[] entries = bulk::get_entries("resources/000");
  assert(entries[0] == "test", "Failed to get entries.");
}

fn void getting_table() @test {
  // Get all entries
  BulkTable table = bulk::get_table("resources/000");
  
  assert(table.len() == 1, "Table size incorrect.");

  TableEntry entry = table["test"]!!;
  assert(entry.name == "test", "Entry name incorrect.");
  assert(entry.length == 5, "Entry length incorrect.");
  assert(entry.pointer == 31, "Entry pointer incorrect.");
  assert(entry.type == TEXT, "Entry type incorrect.");
  assert(entry.comp == NONE, "Entry compression incorrect.");

  // Get single entry
  TableEntry singleEntry = bulk::get_table_entry("resources/000", "test");
  assert(singleEntry.name == "test", "Entry name incorrect.");
  assert(singleEntry.length == 5, "Entry length incorrect.");
  assert(singleEntry.pointer == 31, "Entry pointer incorrect.");
  assert(singleEntry.type == TEXT, "Entry type incorrect.");
  assert(singleEntry.comp == NONE, "Entry compression incorrect.");
}

fn void loading_raw_from_file() @test {
  char[] data = bulk::load("resources/000", "test");
  assert(data == "test4", "Failed to load raw data from file.");

  // Cleanup
  free(data);
}

fn void loading_keybind() @test {
  Keybind kb = bulk::load_keybind("resources/keybinds", "up");
  assert(kb.key == 119 && kb.mod == 0, "Failed to correctly load Keybind.");
}

fn void loading_option() @test {
  Option opt = bulk::load_option("resources/options", "screen_width", false);
  assert(opt.data.as_int == 1280, "Failed to correctly load Option. [%d]",opt.data.as_int);
}


