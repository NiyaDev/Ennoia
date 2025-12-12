

## Ennoia Documentation

### Table of Contents
1. [Debug](#debug)
2. [Bulk](#bulk)
3. [Options](#options)
4. [Keybinds](#keybinds)

### Debug <a name="debug"></a>
#### `void info(String err, args...)`
Prints formatted string to log file and to console.
#### `void warning(String err, args...)`
Prints formatted string to log file, console, and to screen.
#### `void error(String err, args...)`
Prints formatted string to log file, console, and to screen. But with more emphasis.
#### `void fatal(String err, args...)`
Prints formatted string to log file and console, and ends the program.

#### `String recent_error()`
Returns the most recent error text.

### Bulk <a name="bulk"></a>
Handles the saving and loading of custom files.
#### `BulkTable`
Hashmap of `TableEntry`s indexed by their names in file.
#### `TableEntry`
```
String name;
ulong length;
ulong pointer;
DataType type;
CompType comp;
```
###### Overloads: ==
Stores info for bulk file while loading.
#### `DataType`
```
EMPTY,
RAW,
TEXT,
KEYBIND,
OPTION,
LOCALIZATION,

TEXTURE,
FONT,
SHADER,
MODEL,
MATERIAL,
```
The type of data that is stored in bulk entry.

#### `usz TableEntry.size(&self)`
Returns the size of the `TableEntry` counting name string length.
#### `String[] get_entries(String filepath)`
Returns an array of all the named entries in a bulk file.
#### `BulkTable get_table(String filepath)`
Returns a table containing alll entries in a bulk file.
#### `TableEntry get_table_entry(String filepath, String dataname)`
Returns only a single entry from a bulk file.
#### `char[] load(String filepath, String dataname)`
Returns raw data from bulk file.
#### `void load_all(String filepath)`
Loads all data from bulk file into Ennoia.
#### `Texture load_texture(String filepath, String dataname, bool send = true)`
Returns OpenGL Texture loaded from bulk file with the option of sending it directly to Ennoia.
#### `void load_all_textures(String filepath)`
Loads all textures in bulk file into Ennoia.
#### `Font load_font(String filepath, String dataname, bool send = true)`
Returns Font loaded from bulk file with the option of sending it directly to Ennoia.
#### `void load_all_fonts(String filepath)`
Loads all fonts in bulk file into Ennoia.
#### `HashMap{String, Mesh} load_model(String filepath, String dataname, bool getMaterial = true, bool send = true)`
Returns Meshes from a bulk file as well as their associated materials with the option of sending them directly to Ennoia.
#### `void load_all_models(String filepath)`
Loads all meshes and materials from bulk file into Ennoia.
#### `Shader load_shader(String filepath, String dataname, bool send = true)`
Returns Shader loaded from bulk file with the option of sending it directly to Ennoia.
#### `void load_all_shaders(String filepath)`
Loads all shaders from bulk file into Ennoia.
#### `Keybind load_keybind(String filepath, String dataname, bool send = true)`
Returns Keybinding loaded from bulk file with the option of sending it directly to Ennoia.
#### `void load_all_keybinds(String filepath) @export("bulk_allkeybind")`
Loads all keybindings from bulk file into Ennoia.
#### `Option load_option(String filepath, String dataname, bool send = true)`
Returns Option loaded from bulk file with the option of sending it directly to Ennoia.
#### `void load_all_options(String filepath)`
Loads all options from bulk file into Ennoia.
#### `Localization load_localization(String filepath, String dataname, bool send = true)`
Returns Localization loaded from bulk file with the option of sending it directly to Ennoia.
#### `void load_all_localizations(String filepath, bool send = true)`
Loads all localizations from bulk file into Ennoia.

### Options <a name="debug"></a>
#### `Options`
Hashmap containing Options indexed by their name as a string.
#### `Option`
```
OptionType type;
union {
  char as_char;
  short as_short;
  int as_int;
  long as_long;

  float as_float;
  double as_double;

  String as_string;
}
```
Contain what type the option is as well as its data.
#### `OptionType`
```
CHAR,
SHORT,
INT,
LONG,

FLOAT,
DOUBLE,

STRING,
```
#### `void save_options()`
Saves all current ennoia options as a raw file.
#### `char get_char(String optname)`
Gets option as a char.
#### `short get_short(String optname)`
Gets option as a short.
#### `int get_int(String optname)`
Gets option as a int.
#### `long get_long(String optname)`
Gets option as a long.
#### `float get_float(String optname)`
Gets option as a float.
#### `double get_double(String optname)`
Gets option as a double.
#### `void set_char(String optname, char data)`
Sets option as a char.
#### `void set_short(String optname, short data)`
Sets option as a short.
#### `void set_int(String optname, int data)`
Sets option as a int.
#### `void set_long(String optname, long data)`
Sets option as a long.
#### `void set_float(String optname, float data)`
Sets option as a float.
#### `void set_double(String optname, double data)`
Sets option as a double.
#### `bool contains(String optname)`
Returns whether there is currently an option by that name.


### Options <a name="debug"></a>
#### `KeyData`
```
KeyboardKey key;
KeyboardMod mod;
bool down;
bool repeat;
```
#### `Keybind`
```
KeyboardKey key;
KeyboardMod mod;
```

#### `void save_keybinds()`
Saves all keybinds as individual files.
#### `void KeyData.print(&self)`
Prints keybinds info.

#### `void set(String key, bool down = true, bool repeat = false)`
Presses a button through code.
#### `bool pressed(String key)`
Checks whether key has been pressed once.
#### `bool down(String key)`
Checks whether key has been held down.
#### `bool up(String key)`
Checks whether key has been released.
#### `bool mouse_pressed(uint button)`
Checks whether mouse button has been pressed once.
#### `bool mouse_down(uint button)`
Checks whether mouse button has been held down.
#### `bool mouse_up(uint button)`
checks whether mouse button has been released.

#### ``
#### ``




#### ``
#### ``
#### ``
