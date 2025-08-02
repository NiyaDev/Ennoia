
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
    Object* as_object;
    Array* as_array;
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
fn usz TypedValue.size(&self) {
  switch (self.type) {
    case ARRAY:  return self.as_array.len();
    case OBJECT: return self.as_object.len();
    default: return 0;
  }
}
<* Indexes TypedValue as array
  @require self.type == ARRAY
 *>
fn TypedValue TypedValue.get_array(&self, usz index) {
  return self.as_array.get(index);
}
<* Indexes TypedValue as HashMap
  @require self.type == OBJECT
 *>
fn TypedValue TypedValue.get_object(&self, String name) {
  return self.as_object.get(name)!!;
}


