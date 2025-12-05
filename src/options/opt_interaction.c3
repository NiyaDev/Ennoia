
module ennoia::options;
import std::collections;
import ennoia::debug;


<* Get char from options
  @param optname: "Name of option"
 *>
fn char get_char(String optname) @export("options_char") {
  char? output = ennoia::options[optname].as_char;
  if (catch excuse = output) {
    debug::warning("Option %s isn't a char.", optname);
    return 0;
  } else {
    return output;
  }
}
<* Get short from options
  @param optname: "Name of option"
 *>
fn short get_short(String optname) @export("options_short") {
  short? output = ennoia::options[optname].as_short;
  if (catch excuse = output) {
    debug::warning("Option %s isn't a short.", optname);
    return 0;
  } else {
    return output;
  }
}
<* Get int from options
  @param optname: "Name of option"
 *>
fn int get_int(String optname) @export("options_int") {
  int? output = ennoia::options[optname].as_int;
  if (catch excuse = output) {
    debug::warning("Option %s isn't a int.", optname);
    return 0;
  } else {
    return output;
  }
}
<* Get long from options
  @param optname: "Name of option"
 *>
fn long get_long(String optname) @export("options_long") {
  long? output = ennoia::options[optname].as_long;
  if (catch excuse = output) {
    debug::warning("Option %s isn't a long.", optname);
    return 0;
  } else {
    return output;
  }
}

<* Get float from options
  @param optname: "Name of option"
 *>
fn float get_float(String optname) @export("options_float") {
  float? output = ennoia::options[optname].as_float;
  if (catch excuse = output) {
    debug::warning("Option %s isn't a float.", optname);
    return 0;
  } else {
    return output;
  }
}
<* Get double from options
  @param optname: "Name of option"
 *>
fn double get_double(String optname) @export("options_double") {
  double? output = ennoia::options[optname].as_double;
  if (catch excuse = output) {
    debug::warning("Option %s isn't a double.", optname);
    return 0;
  } else {
    return output;
  }
}

<* Sets option to input char
  @param optname: "Name of option"
  @param data: "The new value of the option"
 *>
fn void set_char(String optname, char data) @export("options_setchar") {
  Option result = {
    .type    = OptionType.CHAR,
    .as_char = data,
  };
  ennoia::options.set(optname, result);
}
<* Sets option to input short
  @param optname: "Name of option"
  @param data: "The new value of the option"
 *>
fn void set_short(String optname, short data) @export("options_setshort") {
  Option result = {
    .type     = OptionType.SHORT,
    .as_short = data,
  };
  ennoia::options.set(optname, result);
}
<* Sets option to input int
  @param optname: "Name of option"
  @param data: "The new value of the option"
 *>
fn void set_int(String optname, int data) @export("options_setint") {
  Option result = {
    .type   = OptionType.INT,
    .as_int = data,
  };
  ennoia::options.set(optname, result);
}
<* Sets option to input long
  @param optname: "Name of option"
  @param data: "The new value of the option"
 *>
fn void set_long(String optname, long data) @export("options_setlong") {
  Option result = {
    .type    = OptionType.LONG,
    .as_long = data,
  };
  ennoia::options.set(optname, result);
}

<* Sets option to input float
  @param optname: "Name of option"
  @param data: "The new value of the option"
 *>
fn void set_float(String optname, float data) @export("options_setfloat") {
  Option result = {
    .type     = OptionType.FLOAT,
    .as_float = data,
  };
  ennoia::options.set(optname, result);
}
<* Sets option to input double
  @param optname: "Name of option"
  @param data: "The new value of the option"
 *>
fn void set_double(String optname, double data) @export("options_setdouble") {
  Option result = {
    .type      = OptionType.DOUBLE,
    .as_double = data,
  };
  ennoia::options.set(optname, result);
}

<* Returns whether the input option exists *>
fn bool contains(String optname) @export("options_contains") {
  return ennoia::options.has_key(optname);
}

