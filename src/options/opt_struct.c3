
module ennoia::options;
import std::collections;


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

