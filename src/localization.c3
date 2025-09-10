
module ennoia::localization;
import std::collections;
import std::io;


alias Local = HashMap{String, String};
alias Localization = HashMap{String, Local};

enum Language {
  ENGLISH,
}


<* += Overload *>
fn void Localization.add_assign(&self, Localization* rhs) @operator(+=) @export("local_add") {
  rhs.@each(; String key, Local val) {
    if (self.has_key(key)) io::printfn("[WARNING] - ENNOIA::LOCALIZATION::ADD_ASSIGN [Localization already contains key (%s). Overwriting.]", key);
    self.set(key, val);
  };
  rhs.free();
}

<* Gets localization string for value and current set language *>
fn String get(String key) @export("local_get") {
  return ennoia::localization.get(key)!!.get(ennoia::language)!!;
}
<* returns whether localization string exists *>
fn bool contains(String key) @export("local_contains") {
  return ennoia::localization.has_key(key) && ennoia::localization.get(key)!!.has_key(ennoia::language);
}


