
module bulk_packer;
import std::io;
import std::collections;
import ennoia::bulk;



const String HELP     = "INSERT HELP";
const String NO_FILE  = "  Bulk file doesn't exist. Creating new file.";
const String NEW_FILE = "  Failed to create file.";


struct Entry {
	String filepath;
	usz length;
	usz pointer;
}

fn int main(String[] args) {
	
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



