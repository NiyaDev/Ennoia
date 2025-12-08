
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
	String manifestFilename;
	// Check arguments
	if (args.len > 1) {
		// TODO: Check if argument is '-v'/'--version'
		// TODO: Check for any options
		manifestFilename = args[1];
	} else {
		manifestFilename = "resources/manifest.yaml";
	}
		io::printfn("- Creating bulk using %s", manifestFilename);

	// Opening manifest
	io::printfn("- Processing Manifest.");
	File? manifest = file::open(manifestFilename, "rb");
	if (catch excuse = manifest) {
		io::printf("- ");
		io::printfn("Failed to open manifest. [%s]".color(color::RED), excuse);
		return 1;
	} else { io::printfn("- Loaded %s.", manifestFilename); }
	defer manifest.close()!!;
	
	// Get file size
	usz? manifestSize = file::get_size(manifestFilename);
	if (catch excuse = manifestSize) {
		io::printf("- ");
		io::printfn("Failed to read manifest size. [%s]".color(color::RED), excuse);
		return 1;
	}

	// Get file data
	char[] rawData = mem::new_array(char, manifestSize);
	usz? manifestRead = manifest.read(rawData);
	if (catch excuse = manifestRead) {
		io::printf("- ");
		io::printfn("Failed to read manifest. [%s]".color(color::RED), excuse);
		return 1;
	}
	defer free(rawData);
	io::printfn("  - Load");

	// Process YAML
	Yaml yaml = yaml::parse((String)rawData);
	defer yaml.clean();
	io::printfn("  - YAML");

	return 0;
}

fn int main_1(String[] args) {


	/*
	io::printn("... Loading entries:");	
	y.@each(; String newFile, TypedValue yObj) {
		List{TableEntry} table;
		usz total = 6;
		usz count = 0;

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
	*/
	
	return 0;
	//return old_ver(args);
}

