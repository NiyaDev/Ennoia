
module ennoia::localization;
import std::collections;
import std::io;


alias Local = HashMap{String, String};
alias Localization = HashMap{String, Local};

enum Language {
  ENGLISH,
}


<* += Overload *>
fn void Localization.add_assign(&self, Localization* rhs) @operator(+=) {
  rhs.@each(; String key, Local val) {
    if (self.has_key(key)) io::printfn("[WARNING] - ENNOIA::LOCALIZATION::ADD_ASSIGN [Localization already contains key (%s). Overwriting.]", key);
    self.set(key, val);
  };
  rhs.free();
}

<**>
fn String get(String key) {
  return ennoia::localization.get(key)!!.get(ennoia::language)!!;
}

