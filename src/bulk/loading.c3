
module ennoia::bulk;
import ennoia::texture;
import ennoia::font;
import ennoia::mesh;
import ennoia::shader;
import ennoia::keybinds;
import ennoia::options;
import ennoia::localization;
import ennoia::yaml;
import ennoia::debug;
import std::io;
import std::collections;


const char VERSION_MAJOR @export("bulk_majorversion") = 3;
const char VERSION_MINOR @export("bulk_minorversion") = 0;


<* Load file from Bulk raw
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn char[]? load(String filepath, String dataname) @export("bulk_load") {
  File? file = file::open(filepath, "rb");
  debug::@error(file, "Failed to open file. [bulk::load] %s", filepath)!;
  defer file.close()!!;

  // Check header
  file.check_header()!;

  // Load entry
  TableEntry tableEntry = get_table_entry(filepath, dataname);
  debug::@error(file.seek(tableEntry.pointer), "Failed to seek to position. [bulk::load] %s", filepath)!;
  
  // Read into array
  char[] data = mem::new_array(char, tableEntry.length);
  for (int i; i < tableEntry.length; i++) {
    char? b = file.read_byte();
    debug::@error(b, "Failed to read byte. [bulk::load] %s", filepath)!;
    data[i] = b!;
  }

  // Decompress data

  return data;
}
<* Loads all content from a single file into main storage *>
fn void load_all(String filepath) @export("bulk_loadall") {
  BulkTable tbls = get_table(filepath);

  tbls.@each(; String key, TableEntry val) {
    switch (val.type) {
      case TEXTURE: load_texture(filepath, key, true)!!;
      case FONT:    load_font(filepath, key, true);
      case MODEL:   load_model(filepath, key, true);
      case SHADER:  load_shader(filepath, key, true);
      case KEYBIND: load_keybind(filepath, key, true);
      case OPTION:  load_option(filepath, key, true);
      case LOCALIZATION: load_localization(filepath, key, true);
      default: debug::warning("Attempted to use load all on a file that contains incompatible file types. [%s]", val.type);
    }
  };
}

<* Shorthand for loading a texture from a bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn Texture? load_texture(String filepath, String dataname, bool send = true) @export("bulk_texture") {
  char[] data = load(filepath, dataname)!!;
  defer free(data);

  Texture? tex = texture::load_from_mem(data);
  debug::@error(tex, "Failed to load texture from bulk. %s", filepath)!;

  if (send) ennoia::textures.set(dataname, tex!!);

  return tex;
}
<* Loads all textures in file
  @param filepath: "File path of file to load"
  @require filepath != ""
 *>
fn void load_all_textures(String filepath) @export("bulk_alltexture") {
  BulkTable tbls = get_table(filepath);

  tbls.@each(; String key, TableEntry val) {
    if (val.type == TEXTURE) load_texture(filepath, key, true)!!;
  };
}

<* Shorthand for loading a font from a bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn Font load_font(String filepath, String dataname, bool send = true) @export("bulk_font") {
  char[] data = load(filepath, dataname)!!;
  defer free(data);

  Font font = font::load_from_mem(data[2..], {(float)data[0], (float)data[1]});

  if (send) {
    ennoia::fonts.set(dataname, font);
    ennoia::textures.set(dataname, font.atlas);
  }

  return font;
}
<* Loads all fonts in file
  @param filepath: "File path of file to load"
  @require filepath != ""
 *>
fn void load_all_fonts(String filepath) @export("bulk_allfont") {
  BulkTable tbls = get_table(filepath);

  tbls.@each(; String key, TableEntry val) {
    if (val.type == FONT) load_font(filepath, key, true);
  };
}

<* Shorthand for loading a font from a bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn HashMap{String, Mesh} load_model(String filepath, String dataname, bool getMaterial = true, bool send = true) @export("bulk_model") {
  HashMap{String, Mesh} output;

  char[] data = load(filepath,dataname)!!;
  defer free(data);
  char[] mtl;

  if (getMaterial) {
    // Get material name and load file
    String[] split = ((String)data).tsplit("\n");
    for (int i; i < split.len; i++) {
      String[] splitTwo = split[i].tsplit(" ");
      if (splitTwo[0] == "mtllib") {
        String[] nameSplit = splitTwo[1].tsplit(".");
        mtl = bulk::load(filepath,nameSplit[0])!!;
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
              *temp.texture = bulk::load_texture(filepath, nameSplit[0])!!;
            }
        }
      }
    };
    free(mtl);
  } else {
    output = mesh::load_from_mem((String)data);
  }

  if (send) {
    output.@each(; String key, Mesh val) {
      ennoia::meshes.set(dataname, val);
    };
  }

  return output;

}
<* Loads all models in file
  @param filepath: "File path of file to load"
  @require filepath != ""
 *>
fn void load_all_models(String filepath) @export("bulk_allmodel") {
  BulkTable tbls = get_table(filepath);

  tbls.@each(; String key, TableEntry val) {
    if (val.type == MODEL) load_model(filepath, key, true);
  };
}

<* Shorthand for loading a font from a bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn Shader load_shader(String filepath, String dataname, bool send = true) @export("bulk_shader") {
  char[] data = load(filepath, dataname)!!;
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

  if (send) ennoia::shaders.set(dataname, shader);

  return shader;
}
<* Loads all shaders in file
  @param filepath: "File path of file to load"
  @require filepath != ""
 *>
fn void load_all_shaders(String filepath) @export("bulk_allshader") {
  BulkTable tbls = get_table(filepath);

  tbls.@each(; String key, TableEntry val) {
    if (val.type == SHADER) load_shader(filepath, key, true);
  };
}

<* Shorthand for loading a keybind from a bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
 *>
fn Keybind load_keybind(String filepath, String dataname, bool send = true) @export("bulk_keybind") {
  char[] data = load(filepath, dataname)!!;
  defer free(data);

  Keybind kb = {
    ((uint)(data[0])) + ((uint)(data[1]) << 8) + ((uint)(data[2]) << 16) + ((uint)(data[3]) << 24),
    ((ushort)(data[4])) + ((ushort)(data[5]) << 8),
  };

  if (send) ennoia::keybinds.set(dataname,kb);

  return kb;
}
<* Loads all keybinds in file
  @param filepath: "File path of file to load"
  @require filepath != ""
 *>
fn void load_all_keybinds(String filepath) @export("bulk_allkeybind") {
  BulkTable tbls = get_table(filepath);

  tbls.@each(; String key, TableEntry val) {
    if (val.type == KEYBIND) load_keybind(filepath, key, true);
  };
}


<* Shorthand for loading a set of localization strings from a bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
  @param send: "If true, it adds it to the keybinds global registry"
 *>
fn Localization load_localization(String filepath, String dataname, bool send = true) @export("bulk_local") {
  char[] data = load(filepath,dataname)!!;
  defer free(data);
  Yaml y = yaml::parse((String)data);

  Localization output;

  y.@each(; String key, TypedValue val) {
    Local local;
    if (val.type == OBJECT) debug::error("Attempted to load localization that wasn't in the proper format.");
    
    yaml::Object o = val.as_object;
    o.@each(; String key_inner, TypedValue val_inner) {
      if (val_inner.type == STRING) debug::fatal("Attempted to load localization that wasn't in the proper format.");
      local.set(key_inner, val_inner.as_string);
    };

    output.set(key, local);
  };

  if (send) ennoia::localization += &output;
  
  return output;
}
<* Loads all localizations in file
  @param filepath: "File path of file to load"
  @require filepath != ""
 *>
fn void load_all_localizations(String filepath, bool send = true) @export("bulk_alllocal") {
  BulkTable tbls = get_table(filepath);

  tbls.@each(; String key, TableEntry val) {
    if (val.type == LOCALIZATION) load_localization(filepath, key, send);
  };
}

