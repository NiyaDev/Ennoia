
module bulk_packer;
import std::io;
import std::collections;
import ennoia;



const String HELP     = "INSERT HELP";
const String NO_FILE  = "  Bulk file doesn't exist. Creating new file.";
const String NEW_FILE = "  Failed to create file.";


struct Entry {
	String filepath;
	usz length;
	usz pointer;
}

fn int main(String[] args) {

	// Check for manifest
	io::print("... Searching for manifest");
	if (!file::exists("resources/manifest.yaml") && (args.len == 1 && file::exists(args[1]))) {
		io::printn("\r[\e[1;31mX\e[0m]"); //Failed
		io::printfn(" - Manifest file doesn't exist and none is specified");
		return 1;
	}
	io::printfn("\r[\e[1;32mX\e[0m]"); //Succeeded

	// Load YAML file
	io::print("... Loading manifest");
	Yaml y;
	if (args.len > 1 && file::exists(args[1])) {
		y = yaml::parse_file(args[1]);
	} else if (file::exists("resources/manifest.yaml")) {
		y = yaml::parse_file("resources/manifest.yaml");
	}
	if (y.len() == 0) {
		io::printn("\r[\e[1;31mX\e[0m]"); //Failed
		io::printfn(" - Failed to load manifest");
	} else {
	  io::printfn("\r[\e[1;32mX\e[0m]"); //Succeeded
	}
	
	io::printn("... Loading entries:");	
	y.@each(; String newFile, TypedValue yObj) {
		List{TableEntry} table;
		usz total = 6;
		usz count = 0;

		// Create list of all entries
		yObj.as_object.@each(; String key, TypedValue val) {
			TableEntry t;
			t.name = key;
			total += t.size();
			
			switch (val.get_array(0).as_string) {
				case "KEYBIND":
					t.length = 6;
					t.type = KEYBIND;
					t.comp = NONE;
				case "OPTION":
					switch (val.get_array(1).as_string) {
						case "BYTE":   t.length = 1 + 1;
						case "SHORT":  t.length = 1 + 2;
						case "INT":    t.length = 1 + 4;
						case "LONG":   t.length = 1 + 8;
						case "FLOAT":  t.length = 1 + 4;
						case "DOUBLE": t.length = 1 + 8;
						case "STRING": t.length = 1 + 1 + val.get_array(2).as_string.len + 1;
					}
					t.type = OPTION;
					t.comp = NONE;
				case "STRING":
					t.length = val.get_array(1).as_string.len;
					t.type = TEXT;
					t.comp = NONE;
				case "FONT":
					t.length = 2 + file::get_size(val.get_array(3).as_string)!!;
					t.type = FONT;
					t.comp = NONE;
				case "RAW":
					t.length = file::get_size(val.get_array(1).as_string)!!;
					t.type = RAW;
					t.comp = NONE;
				case "SHADER":
					usz length = 16;
					if (file::exists(val.get_array(1).as_string)) length += file::get_size(val.get_array(1).as_string)!!;
					if (file::exists(val.get_array(2).as_string)) length += file::get_size(val.get_array(2).as_string)!!;
					t.length = length;
					t.type = SHADER;
					t.comp = NONE;
				case "TEXTURE":
					usz? length = file::get_size(val.get_array(1).as_string);
					if (catch length) io::printfn("[ERROR] - Failed to open texture file [%s]", val.get_array(1).as_string);
					t.length = length!!;
					t.type = TEXTURE;
					t.comp = NONE;
				case "MODEL":
					t.length = file::get_size(val.get_array(1).as_string)!!;
					t.type = MODEL;
					t.comp = NONE;
				case "MATERIAL":
					t.length = file::get_size(val.get_array(1).as_string)!!;
					t.type = MATERIAL;
					t.comp = NONE;
				case "LOCALIZATION":
					t.length = file::get_size(val.get_array(1).as_string)!!;
					t.type = LOCALIZATION;
					t.comp = NONE;
					// TODO Compression on raw files
					//t.comp = val.get_array(2).as_int;
			}
			table.push(t);
			count++;
		};

		// Set position of every pointer
		for (int i; i < table.len(); i++) {
			table[i].pointer = total;
			total += table[i].length;
		}

		// Save data
		String path = string::tformat("resources/%s",newFile);
		File? file = file::open(path, "wb");
		if (catch file) {
			io::printfn("[ERROR] - BULK_PACKER::MAIN [Failed to open file to write bulk]");
			return 1;
		}

		file.write_byte(bulk::VERSION_MAJOR)!!;
		file.write_byte(bulk::VERSION_MINOR)!!;
		file.write_byte(0xFF)!!;
		file.write_byte(0xFF)!!;

		file.write_short((short)table.len());

		for (int i; i < table.len(); i++) {
			file.write_string(table[i].name);
			file.write_long(table[i].length);
			file.write_long(table[i].pointer);
			file.write_short(table[i].type.ordinal);
			file.write_short(table[i].comp.ordinal);

			usz old = file.seek(0,Seek.CURSOR)!!;
			file.seek(table[i].pointer)!!;

			TypedValue val = yObj.get_object(table[i].name);

			switch (table[i].type) {
				case KEYBIND:
					file.write_int(val.get_array(1).as_int);
					file.write_short((short)val.get_array(2).as_int);
				case OPTION:
					switch (val.get_array(1).as_string) {
						case "BYTE":
							file.write_byte(OptionType.CHAR.ordinal)!!;
							file.write_byte(  (char)val.get_array(2).as_int)!!;
						case "SHORT":
							file.write_byte(OptionType.SHORT.ordinal)!!;
							file.write_short((short)val.get_array(2).as_int);
						case "INT":
							file.write_byte(OptionType.INT.ordinal)!!;
							file.write_int(         val.get_array(2).as_int);
						case "LONG":
							file.write_byte(OptionType.LONG.ordinal)!!;
							file.write_long(  (long)val.get_array(2).as_int);
						case "FLOAT":
							file.write_byte(OptionType.FLOAT.ordinal)!!;
							file.write_float((float)val.get_array(2).as_double);
						case "DOUBLE":
							file.write_byte(OptionType.DOUBLE.ordinal)!!;
							file.write_double(      val.get_array(2).as_double);
						case "STRING":
							file.write_byte(OptionType.STRING.ordinal)!!;
							file.write_byte((char)val.get_array(2).as_string.len)!!;
							file.write_string(      val.get_array(2).as_string);
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
			file.seek(old)!!;
		}
		file.close()!!;
	};
	
	return 0;
	//return old_ver(args);
}

fn int old_ver(String[] args) {
	// Ensures a bulk file is listed
	if (args.len == 1) {
		io::printfn(HELP);
		return 0;
	}

	// If Bulk file exists copy data into hashmap
	String filename = args[1];
	HashMap{String, Entry} names;

	if (file::is_file(filename)) {
		String[] allEntries = bulk::get_entries(filename);
		for (int i; i < allEntries.len; i++) {
			names.set(allEntries[i], {filename,bulk::get_entry_len(filename, allEntries[i]),0});
		}
	}

	// Read flags
	usz numEntries = args.len;
	usz head = 2;
	for (int i; head < numEntries; i++) {
		switch (args[head++]) {
			case "-a": // Add
				String name = args[head++];
				String path = args[head++];
				names.set(name, {path,file::get_size(path)!!,0});
			case "-t": // Text
				String name = args[head++];
				String path = args[head++];
				names.set(name, {path,path.len,0});
			case "-r": // Remove
				names.remove(args[head++]);
			default:
		}
	}

	// Calculate sizes of Header and content
	usz headerSize = 5;
	usz dataSize;
	names.@each(; String key, Entry val) {
		headerSize += key.len + 1 + 8 + 8;
		dataSize += val.length;
	};
	head = headerSize;
	names.@each(; String key, Entry val) {
		 Entry* ref = names.get_ref(key)!!;
		 ref.pointer = head;
		 head += ref.length;
	};

	// Write to temp file
	head = 0;
	File data = file::open("temp", "wb")!!;
	data.write_byte(bulk::VERSION_MAJOR)!!;
	data.write_byte(bulk::VERSION_MINOR)!!;
	data.write_short((short)names.len());
	names.@each(; String key, Entry val) {
		data.write((char[])key)!!;
		data.write_byte('\0')!!;
		data.write_long(val.length);
		data.write_long(val.pointer);

		usz old = data.seek(0,Seek.CURSOR)!!;
		data.seek(val.pointer)!!;

		//File dat = file::open(val.filepath,"rb")!!;
		File? dat = file::open(val.filepath,"rb");
		if (catch dat) {
			for (int i; i < val.filepath.len; i++) {
				data.write_byte(val.filepath[i])!!;
			}
		} else {
			if (val.filepath == filename) dat.seek(bulk::get_entry_ptr(filename, key))!!;
		
			for (int i; i < val.length; i++) {
				data.write_byte(dat.read_byte()!!)!!;
			}
			dat.close()!!;
		}

		data.seek(old)!!;
	};
	data.close()!!;

	// Copy temp file to new file
	File file = file::open(filename, "wb")!!;
	File temp = file::open("temp", "rb")!!;
	for (int i; i < headerSize+dataSize; i++) {
		file.write_byte(temp.read_byte()!!)!!;
	}
	file.close()!!;

	// Delete temp
	file::delete("temp")!!;

	return 0;
}

