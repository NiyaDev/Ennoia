
module ennoia::yaml;
import std::io;
import std::collections;


struct TypedValue {
  YAMLType type;
  union {
    void* as_void;
    bool as_bool;
    int as_int;
    double as_double;
    String as_string;
    Object as_object;
    Array as_array;
  }
}

enum YAMLType {
  NONE,
  INT,
  DOUBLE,
  STRING,
  ARRAY,
  BOOL,
  OBJECT,
}

alias Object = HashMap{String, TypedValue};
alias Yaml   = HashMap{String, TypedValue};
alias Array  = List{TypedValue};


<* Get size of Array or Object member
  @require self.type == ARRAY || self.type == OBJECT
 *>
fn usz TypedValue.size(&self) @export("yaml_tvsize") {
  switch (self.type) {
    case ARRAY:  return self.as_array.len();
    case OBJECT: return self.as_object.len();
    default: return 0;
  }
}
<* Indexes TypedValue as array
  @require self.type == ARRAY
 *>
fn TypedValue TypedValue.get_array(&self, usz index) @export("yaml_tvarray") {
  return self.as_array.get(index);
}
<* Indexes TypedValue as HashMap
  @require self.type == OBJECT
 *>
fn TypedValue TypedValue.get_object(&self, String name) @export("yaml_tvobj") {
  return self.as_object.get(name)!!;
}
<* Returns whether TypedValue objects contains a member with name
  @require self.type == OBJECT
 *>
fn bool TypedValue.has_key(&self, String key) @export("yaml_haskey") {
  return self.as_object.has_key(key);
}

<* Removes tabs and spaces at the beginning and end of the string *>
fn String String.truncate_spaces(self) {
  String output = self;
  while (output.starts_with(" "))  output = output.strip(" ");
  while (output.starts_with("\t")) output = output.strip("\t");
  return output.truncate_spaces_after();
}
<* Removes tabs and spaces at the end of the string *>
fn String String.truncate_spaces_after(self) {
  String output = self;
  while (output.ends_with(" "))    output = output.strip_end(" ");
  while (output.ends_with("\t"))   output = output.strip_end("\t");
  return output;
}
<* Removes spaces after a specific character in a string
  @require self != ""
 *>
fn String String.remove_spaces_after(self, char c) {
  List{char} list;
  char last = '\0';

  for (int i; i < self.len; i++) {
    if (self[i] != ' ') last = self[i];
    if (last == c && self[i] == ' ') continue;
    list.push(self[i]);
  }

  String output = (String)list.to_tarray();
  list.free();

  return output;
}
<* Counts the spaces after a specific character in a string
  @require self != ""
 *>
fn int String.count_spaces_after_char(self, char c) {
  int count;
  char last = '\0';
  for (int i; i < self.len; i++) {
    if (self[i] != ' ') last = self[i];
    if (last == c && self[i] == ' ') count++;
  }
  return count;
}
<* Counts the number of spaces set at the beginning of a string *>
fn int String.count_spaces(self, int tabSpaces = 2) {
  int spaces = 0;
  for (int i; i < self.len; i++) {
    if (self[i] == ' ') {
      spaces++;
    } else if (self[i] == '\t') {
      spaces += tabSpaces;
    } else {
      return spaces;
    } 
  }
  return spaces;
}
<* Checks if string is a pair or the start of an array/object
  @require self != ""
 *>
fn bool String.is_value_pair(self) {
  return self.contains(":");
}
<* Splits a string into the name and value based on delimiter ':'
  @require self != ""
 *>
fn String[] String.split_value(self) {
  return self.split(tmem, ":");
}
<* Splits string into an array *>
fn String[] String.split_array(self) {
  String[] output = self.strip("[").strip_end("]").tsplit(",");
  for (int i; i < output.len; i++) {
    if (output[i] != "\n") output[i] = output[i].strip("\n").truncate_spaces();
  }

  return output;
}

<* Returns the type of value that the string contains *>
fn YAMLType String.get_type(self) {
  // None
  if (self.len == 0) return NONE;
  // Boolean
  if (self.is_bool()) return BOOL;
  // Array
  if (self[0] == '[' && self[self.len - 1] == ']') return ARRAY;
  // Int
  int? i = self.to_int();
  if (try i) return INT;
  // Double
  double? d = self.to_double();
  if (try d) return  DOUBLE;
  // String
  return STRING;
}
<* Returns whether the input string is a variation of true or false *>
fn bool String.is_bool(self) {
  return self == "true" || self == "True" || self == "TRUE" || self == "false" || self == "False" || self == "FALSE";
}
<* Returns the value of the string as a bool *>
fn bool String.to_bool(self) {
  return self == "true" || self == "True" || self == "TRUE";
}

<* Converts a value string to an actual value
  @require self != ""
 *>
fn Pair{String, TypedValue} String.to_value(self) {
  Pair{String, TypedValue} output;

  String[] nameValue = self.split_value();

  if (nameValue.len > 1) {
    output.second.type = nameValue[1].get_type();
  } else {
    output.second.type = NONE;
  }
  output.first = nameValue[0];

  if (output.second.type == NONE) return output;

  switch (output.second.type) {
    case BOOL:   output.second.as_bool   = nameValue[1].to_bool();
    case INT:    output.second.as_int    = nameValue[1].to_int()!!;
    case DOUBLE: output.second.as_double = nameValue[1].to_double()!!;
    case STRING: output.second.as_string = nameValue[1].copy(mem);
    case ARRAY:
      String[] valuesSplit = nameValue[1].split_array();

      for (int i; i < valuesSplit.len; i++) {
        String namedVal = string::tformat("_:%s", valuesSplit[i]);
        Pair{String, TypedValue} nval = namedVal.to_value();
        output.second.as_array.push(nval.second);
      }
    default:
  }

  return output;
}

<* Loads a file to pass into parse function
  @require filename != ""
 *>
fn Yaml parse_file(String filename) @export("yaml_parsefile") {
  char[] data = io::file::load_temp(filename)!!;

  return parse((String)data);
}
<* Parse string as yaml text *>
fn Yaml parse(String data) @export("yaml_parse") {
  Yaml output;

  // Split up lines
  String[] linesArray = data.tsplit("\n");
  assert(linesArray[0][0..4] == "%YAML", "[ERROR] - ENNOIA::YAML::PARSE [Failed to parse header]");
  assert(linesArray[0][6..8] == "1.2",   "[ERROR] - ENNOIA::YAML::PARSE [Failed to parse header]");

  int fileIndent;
  List{String} lines;
  for (int i = 2; i < linesArray.len; i++) {
    String temp;

    // Remove comments
    if (linesArray[i].contains("#")) {
      temp = linesArray[i][0:linesArray[i].index_of("#")!!];
    } else {
      temp = linesArray[i];
    }

    int spaces = temp.count_spaces();

    // Ignore empty lines
    if (spaces == temp.len) continue;

    // Count indents
    if (spaces > 0 && fileIndent == 0) fileIndent = spaces;

    // Remove spaces
    if (temp.contains(":")) {
      String truncated    = temp.truncate_spaces_after();
      String removedComma = truncated.remove_spaces_after(',');
      String removedColon = removedComma.remove_spaces_after(':');
      lines.push(removedColon);
    } else {
      String trunc = temp.truncate_spaces();
      String afterC = trunc.remove_spaces_after(':');
      String afterM = afterC.remove_spaces_after(',');

      String lineMinusOne = lines[lines.len()-1].tcopy();
      lines[lines.len()-1] = string::tformat("%s %s", lineMinusOne, afterM);
    }
  }

  List{void*} scopeStack;
  scopeStack.push(&output);
  int prevIndent;

  for (int i; i < lines.len(); i++) {
    if (lines[i].truncate_spaces() == "") continue;

    int indent = lines[i].count_spaces();
    if (indent < prevIndent) {
      for (int f; f < (prevIndent - indent) / fileIndent; f++) scopeStack.pop()!!;
    }

    Pair{String, TypedValue} v = lines[i].truncate_spaces().to_value();

    if (v.second.type != NONE) {
      (*((Object*)(scopeStack[scopeStack.len()-1]))).set(v.first, v.second);
    } else {
      (*((Object*)(scopeStack[scopeStack.len()-1]))).set(v.first, {.type = OBJECT, .as_object = {}});
      scopeStack.push(&&(*((Object*)(scopeStack[scopeStack.len()-1]))).get_ref(v.first)!!.as_object);
    }
    prevIndent = indent;
  }

  return output;
}

<* Cleans up Yaml data *>
fn void Yaml.clean(&self) @export("yaml_clean") {
  self.@each(; String key, TypedValue val) {
    val.clean();
  };
}
<* Cleans up TypedValue data *>
fn void TypedValue.clean(&self) {
  switch (self.type) {
    case STRING:
      self.as_string.free(mem);
    case OBJECT:
      self.as_object.@each(; String key2, TypedValue val2) {
        val2.clean();
      };
    case ARRAY:
      for (int i; i < self.size(); i++) self.as_array[i].clean();
    default: // Bool/Int/Double
  }
}

<* Prints all data inside Yaml *>
fn void Yaml.print(&self) @export("yaml_print") {
  io::printn("YAML:");
  self.@each(; String key, TypedValue val) {
    val.print(key, 1);
  };
}
<* Prints all data inside Typedvalue *>
fn void TypedValue.print(&self, String name, int tabs = 0) {
  for (int i; i < tabs; i++) io::print("  ");
  switch (self.type) {
    case BOOL:   io::printfn("%s [%s]: %s", name, self.type, self.as_bool);
    case INT:    io::printfn("%s [%s]: %d", name, self.type, self.as_int);
    case DOUBLE: io::printfn("%s [%s]: %f", name, self.type, self.as_double);
    case STRING: io::printfn("%s [%s]: %s", name, self.type, self.as_string);
    case NONE:   io::printfn("%s [%s]",     name, self.type);
    case OBJECT:
      io::printfn("%s [%s]: %d {", name, self.type, self.size());
      self.as_object.@each(; String key, TypedValue val) {
        val.print(key, tabs+1);
      };
      for (int i; i < tabs; i++) io::print("  ");
      io::printfn("}");
    case ARRAY:
      io::printfn("%s [%s]: %d [", name, self.type, self.size());
      for (int i; i < self.as_array.len(); i++) {
        self.as_array[i].print("", tabs+1);
      };
      for (int i; i < tabs; i++) io::print("  ");
      io::printfn("]");
  }
}


