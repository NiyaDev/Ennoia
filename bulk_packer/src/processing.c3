
module bulk_packer;
import std::io;
import std::collections;
import ennoia;


<**>
fn void? process(TypedValue value, String newFile) {
  List{TableEntry} table;
  usz total = 6;
  usz count = 0;

  // Create a list of all entries
  value.as_object.@each(; String key, TypedValue val) {
    table.push(read_entry(key,val,&total));
    count++;
  };

  // Set position of every pointer
  for (int i; i < table.len(); i++) {
    table[i].pointer = total;
    total += table[i].length;
  }

  // Save data
  String path = string::tformat("resources/%s", newFile);
  File? file = file::open(path, "wb");
  @err(file, "Failed to open bulk file to write. %s", newFile)!;
  defer file.close()!!;

  // Version
  @err(file.write_byte(bulk::VERSION_MAJOR), "Failed to write to file. %s", newFile)!;
  @err(file.write_byte(bulk::VERSION_MINOR), "Failed to write to file. %s", newFile)!;

  // Padding
  @err(file.write_short(0), "Failed to write to file. %s", newFile)!;

  // Entry total
  @err(file.write_short((short)table.len()), "Failed to write to file. %s", newFile)!;

  for (int i; i < table.len(); i++) {
    // Name, Length, Pointer, Type, and Compression
    @err(file.write_string(table[i].name), "Failed to write to file. %s", newFile)!;
    @err(file.write_long(table[i].length), "Failed to write to file. %s", newFile)!;
    @err(file.write_long(table[i].pointer), "Failed to write to file. %s", newFile)!;
    @err(file.write_short(table[i].type.ordinal), "Failed to write to file. %s", newFile)!;
    @err(file.write_short(table[i].comp.ordinal), "Failed to write to file. %s", newFile)!;

    // Seek to pointer
    usz? old = file.seek(0, Seek.CURSOR);
    @err(old, "Failed to seek in file. %s", newFile)!;
    @err(file.seek(table[i].pointer), "Failed to seek in file. %s", newFile)!;

    // Write value
    TypedValue val = value.get_object(table[i].name);
    switch (table[i].type) {
      case KEYBIND:
        @err(file.write_int(val.get_array(1).as_int), "Failed to write to file. %s", newFile)!;
        @err(file.write_short((short)val.get_array(2).as_int), "Failed to write to file. %s", newFile)!;
			case OPTION:
				switch (val.get_array(1).as_string) {
					case "BYTE":
            @err(file.write_byte(OptionType.CHAR.ordinal), "Failed to write to file. %s", newFile)!;
            @err(file.write_byte((char)val.get_array(2).as_int), "Failed to write to file. %s", newFile)!;
					case "SHORT":
					  @err(file.write_byte(OptionType.SHORT.ordinal), "Failed to write to file. %s", newFile)!;
					  @err(file.write_short((short)val.get_array(2).as_int), "Failed to write to file. %s", newFile)!;
					case "INT":
					  @err(file.write_byte(OptionType.INT.ordinal), "Failed to write to file. %s", newFile)!;
					  @err(file.write_int(val.get_array(2).as_int), "Failed to write to file. %s", newFile)!;
					case "LONG":
					  @err(file.write_byte(OptionType.LONG.ordinal), "Failed to write to file. %s", newFile)!;
					  @err(file.write_long((long)val.get_array(2).as_int), "Failed to write to file. %s", newFile)!;
					case "FLOAT":
					  @err(file.write_byte(OptionType.FLOAT.ordinal), "Failed to write to file. %s", newFile)!;
					  @err(file.write_float((float)val.get_array(2).as_double), "Failed to write to file. %s", newFile)!;
					case "DOUBLE":
					  @err(file.write_byte(OptionType.DOUBLE.ordinal), "Failed to write to file. %s", newFile)!;
					  @err(file.write_double(val.get_array(2).as_double), "Failed to write to file. %s", newFile)!;
					case "STRING":
					  @err(file.write_byte(OptionType.STRING.ordinal), "Failed to write to file. %s", newFile)!;
					  @err(file.write_byte((char)val.get_array(2).as_string.len), "Failed to write to file. %s", newFile)!;
					  @err(file.write_string(val.get_array(2).as_string), "Failed to write to file. %s", newFile)!;
			  }
			case TEXT:
				file.write_string(val.get_array(1).as_string);
			case RAW:
				File? data = file::open(val.get_array(1).as_string, "rb");
				if (catch data) {
					io::printfn("[ERROR] - BULK_PACKER::MAIN [Attempted to read file that doesn't exist]");
					return 1;
				}
				for (int l; l < table[i].length; l++) {
					file.write_byte(data.read_byte()!!)!!;
				}
				data.close()!!;
			case FONT:
				File? data = file::open(val.get_array(3).as_string, "rb");
				if (catch data) {
					io::printfn("[ERROR] - BULK_PACKER::MAIN [Attempted to read file that doesn't exist]");
					return 1;
				}
				file.write_byte((char)val.get_array(1).as_int)!!;
				file.write_byte((char)val.get_array(2).as_int)!!;
				for (int l; l < table[i].length - 2; l++) {
					file.write_byte(data.read_byte()!!)!!;
				}
				data.close()!!;
			case SHADER:
				// Vertex Shader
				if (val.get_array(1).as_string != "") {
					File? vs = file::open(val.get_array(1).as_string, "rb");
					if (catch vs) {
						io::printfn("[ERROR] - BULK_PACKER::MAIN [Attempted to read file that doesn't exist]");
						return 1;
					}
					usz vsSize = file::get_size(val.get_array(1).as_string)!!;
					file.write_long(vsSize);
					for (int l; l < vsSize; l++) {
						file.write_byte(vs.read_byte()!!)!!;
					}
					vs.close()!!;
				} else {
					file.write_long(0);
				}
				// Fragment Shader
				if (val.get_array(2).as_string != "") {
					File? fs = file::open(val.get_array(2).as_string, "rb");
					if (catch fs) {
						io::printfn("[ERROR] - BULK_PACKER::MAIN [Attempted to read file that doesn't exist]");
						return 1;
					}
					usz fsSize = file::get_size(val.get_array(2).as_string)!!;
					file.write_long(fsSize);
					for (int l; l < fsSize; l++) {
						file.write_byte(fs.read_byte()!!)!!;
					}
					fs.close()!!;
				} else {
					file.write_long(0);
				}
			case TEXTURE:
				File? data = file::open(val.get_array(1).as_string, "rb");
				if (catch data) {
					io::printfn("[ERROR] - BULK_PACKER::MAIN [Attempted to read file that doesn't exist]");
					return 1;
				}
				for (int l; l < table[i].length; l++) file.write_byte(data.read_byte()!!)!!;
				data.close()!!;
			case MODEL:
				File? data = file::open(val.get_array(1).as_string, "rb");
				if (catch data) {
					io::printfn("[ERROR] - BULK_PACKER::MAIN [Attempted to read file that doesn't exist]");
					return 1;
				}
				for (int l; l < table[i].length; l++) {
					file.write_byte(data.read_byte()!!)!!;
				}
				data.close()!!;
			case MATERIAL:
				File? data = file::open(val.get_array(1).as_string, "rb");
				if (catch data) {
					io::printfn("[ERROR] - BULK_PACKER::MAIN [Attempted to read file that doesn't exist]");
					return 1;
				}
				for (int l; l < table[i].length; l++) {
					file.write_byte(data.read_byte()!!)!!;
				}
				data.close()!!;
			case LOCALIZATION:
				File? data = file::open(val.get_array(1).as_string, "rb");
				if (catch data) {
					io::printfn("[ERROR] - BULK_PACKER::MAIN [Attempted to read file that doesn't exist]");
					return 1;
				}
				for (int l; l < table[i].length; l++) {
					file.write_byte(data.read_byte()!!)!!;
				}
				data.close()!!;
			default:
    }
  }
}

<**>
// TODO: Compression
fn TableEntry read_entry(String name, TypedValue arr, usz* total) {
  TableEntry output;
  output.name = name;
  total += output.size();

  switch (arr.get_array(0).as_string) {
    case "KEYBIND":
      output.length = 6;
      output.type = KEYBIND;
      output.comp = NONE;
    case "OPTION":
      switch (arr.get_array(1).as_string) {
        case "BYTE":   output.length = 1 + 1;
				case "SHORT":  output.length = 1 + 2;
				case "INT":    output.length = 1 + 4;
				case "LONG":   output.length = 1 + 8;
				case "FLOAT":  output.length = 1 + 4;
				case "DOUBLE": output.length = 1 + 8;
				case "STRING": output.length = 1 + 1 + arr.get_array(2).as_string.len + 1;
      }
      output.type = OPTION;
      output.comp = NONE;
    case "STRING":
			output.length = arr.get_array(1).as_string.len;
			output.type = TEXT;
			output.comp = NONE;
		case "FONT":
			output.length = 2 + file::get_size(arr.get_array(3).as_string)!!;
			output.type = FONT;
			output.comp = NONE;
		case "RAW":
			output.length = file::get_size(arr.get_array(1).as_string)!!;
			output.type = RAW;
			output.comp = NONE;
		case "SHADER":
			usz length = 16;
			if (file::exists(arr.get_array(1).as_string)) length += file::get_size(arr.get_array(1).as_string)!!;
			if (file::exists(arr.get_array(2).as_string)) length += file::get_size(arr.get_array(2).as_string)!!;
			output.length = length;
			output.type = SHADER;
			output.comp = NONE;
		case "TEXTURE":
			usz? length = file::get_size(arr.get_array(1).as_string);
			if (catch length) io::printfn("[ERROR] - Failed to open texture file [%s]", arr.get_array(1).as_string);
			output.length = length!!;
			output.type = TEXTURE;
			output.comp = NONE;
		case "MODEL":
			output.length = file::get_size(arr.get_array(1).as_string)!!;
		  output.type = MODEL;
			output.comp = NONE;
		case "MATERIAL":
			output.length = file::get_size(arr.get_array(1).as_string)!!;
			output.type = MATERIAL;
			output.comp = NONE;
		case "LOCALIZATION":
			output.length = file::get_size(arr.get_array(1).as_string)!!;
		  output.type = LOCALIZATION;
			output.comp = NONE;
  }
  return output;
}

