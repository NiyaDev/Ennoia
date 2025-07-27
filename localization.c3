
module ennoia::localization;
import std::collections;


alias Local = String[];
alias Localization = HashMap{String, Local};

Localization localization @builtin;

enum Language {
  ENGLISH,
}



