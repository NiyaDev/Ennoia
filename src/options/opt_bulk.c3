
module ennoia::bulk;
import ennoia::options;


<* Shorthand for loading an option from a bulk file
  @param filepath: "Path to bulk file"
  @require filepath != ""
  @param dataname: "Name of data inside bulk file"
  @require dataname != ""
  @param send: "If true, it adds it to the keybinds global registry"
 *>
fn Option load_option(String filepath, String dataname, bool send = true) @export("bulk_option") {
  char[] data = load(filepath, dataname)!!;
  defer free(data);

  Option opt;
  opt.type = OptionType.from_ordinal(data[0]); 

  switch (opt.type) {
    case CHAR:
      opt.as_char   = data[1];
    case SHORT:
      short sh;
      mem::copy(&sh, &data[1], 2);
      opt.as_short  = sh;
    case INT:
      int sh;
      mem::copy(&sh, &data[1], 4);
      opt.as_int    = sh;
    case LONG:
      long sh;
      mem::copy(&sh, &data[1], 8);
      opt.as_long   = sh;

    case FLOAT:
      float sh;
      mem::copy(&sh, &data[1], 4);
      opt.as_float  = sh;
    case DOUBLE:
      double sh;
      mem::copy(&sh, &data[1], 8);
      opt.as_double = sh;

    case STRING:
      String str = (String)mem::new_array(char,(usz)data[1]);
      mem::copy(&str, &data[2], data[1]);
      opt.as_string = str;
  }

  if (send) ennoia::options.set(dataname, opt);

  return opt;
}
<* Loads all options in file
  @param filepath: "File path of file to load"
  @require filepath != ""
 *>
fn void load_all_options(String filepath) @export("bulk_alloption") {
  BulkTable tbls = get_table(filepath);

  tbls.@each(; String key, TableEntry val) {
    if (val.type == OPTION) load_option(filepath, key, true);
  };
}


