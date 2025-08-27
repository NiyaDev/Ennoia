
module ennoia::options;
import std::collections;
import std::io;
import ennoia;



alias Options = HashMap{String, Option};

struct Option {
  OptionType type;
  OptionData data;
}

union OptionData {
  char as_char;
  short as_short;
  int as_int;
  long as_long;

  float as_float;
  double as_double;

  String as_string;
}

enum OptionType : char {
  CHAR,
  SHORT,
  INT,
  LONG,

  FLOAT,
  DOUBLE,

  STRING,
}


<* Get char from options
  @param optname: "Name of option"
 *>
fn char get_char(String optname) {
  return ennoia::options[optname].data.as_char!!;
}
<* Get short from options
  @param optname: "Name of option"
 *>
fn short get_short(String optname) {
  return ennoia::options[optname].data.as_short!!;
}
<* Get int from options
  @param optname: "Name of option"
 *>
fn int get_int(String optname) {
  return ennoia::options[optname].data.as_int!!;
}
<* Get long from options
  @param optname: "Name of option"
 *>
fn long get_long(String optname) {
  return ennoia::options[optname].data.as_long!!;
}

<* Get float from options
  @param optname: "Name of option"
 *>
fn float get_float(String optname) {
  return ennoia::options[optname].data.as_float!!;
}
<* Get double from options
  @param optname: "Name of option"
 *>
fn double get_double(String optname) {
  return ennoia::options[optname].data.as_double!!;
}

<* Sets option to input char
  @param optname: "Name of option"
  @param data: "The new value of the option"
 *>
fn void set_char(String optname, char data) {
  Option result = {
    OptionType.CHAR,
    {.as_char=data},
  };
  ennoia::options.set(optname, result);
}
<* Sets option to input short
  @param optname: "Name of option"
  @param data: "The new value of the option"
 *>
fn void set_short(String optname, short data) {
  Option result = {
    OptionType.SHORT,
    {.as_short=data},
  };
  ennoia::options.set(optname, result);
}
<* Sets option to input int
  @param optname: "Name of option"
  @param data: "The new value of the option"
 *>
fn void set_int(String optname, int data) {
  Option result = {
    OptionType.INT,
    {.as_int=data},
  };
  ennoia::options.set(optname, result);
}
<* Sets option to input long
  @param optname: "Name of option"
  @param data: "The new value of the option"
 *>
fn void set_long(String optname, long data) {
  Option result = {
    OptionType.LONG,
    {.as_long=data},
  };
  ennoia::options.set(optname, result);
}

<* Sets option to input float
  @param optname: "Name of option"
  @param data: "The new value of the option"
 *>
fn void set_float(String optname, float data) {
  Option result = {
    OptionType.FLOAT,
    {.as_float=data},
  };
  ennoia::options.set(optname, result);
}
<* Sets option to input double
  @param optname: "Name of option"
  @param data: "The new value of the option"
 *>
fn void set_double(String optname, double data) {
  Option result = {
    OptionType.DOUBLE,
    {.as_double=data},
  };
  ennoia::options.set(optname, result);
}

<**>
fn bool contains(String optname) {
  return ennoia::options.has_key(optname);
}

<* Saves all options as a file *>
fn void save_options() {
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
  ennoia::options.@each(; String key, Option val) {
    File file = file::open(key, "wb")!!;
    file.write_byte(val.type.ordinal)!!;
    switch (val.type) {
      case CHAR:
        file.write_byte(val.data.as_char)!!;
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
    file.close()!!;
  };
}

