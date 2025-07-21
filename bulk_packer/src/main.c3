
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
			names.set(allEntries[i], {filename,file::get_size(filename)!!,0});
		}
	}

	usz numEntries = args.len;
	usz head = 2;
	for (int i; head < numEntries; i++) {
		switch (args[head++]) {
			case "-a": // Add
				String name = args[head++];
				String path = args[head++];
				names.set(name, {path,file::get_size(path)!!,0});
			case "-r": // Remove
				names.remove(args[head++]);
			default:
		}
	}

	// This needs to calculate the file size correctly when dealing with a bulk
	usz headerSize = 4;
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

	head = 0;
	File data = file::open("temp", "wb")!!;
	data.write_byte(bulk::VERSION_MAJOR)!!;
	data.write_byte(bulk::VERSION_MINOR)!!;
	data.write_byte(0xff)!!;
	data.write_byte(0xff)!!;
	names.@each(; String key, Entry val) {
		data.write((char[])key)!!;
		data.write_byte('\0')!!;
		data.write_long(val.length);
		data.write_long(val.pointer);

		usz old = data.seek(0,Seek.CURSOR)!!;
		//data.seek(val.pointer)!!;

	};

	io::printfn("%d-%d",headerSize,dataSize);
	
	// Load new files
	
	
	//file.close()!!;

	return 0;
}



