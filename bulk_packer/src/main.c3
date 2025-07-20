
module bulk_packer;
import std::io;
import ennoia::bulk;



const String HELP     = "INSERT HELP";
const String NO_FILE  = "  Bulk file doesn't exist. Creating new file.";
const String NEW_FILE = "  Failed to create file.";


fn int main(String[] args) {
	
	// Test for bulk name
	if (args.len == 1) {
		io::printfn(HELP);
		return 0;
	}

	String filename = args[1];
	String[] allEntries = bulk::get_entries(filename);
	io::printfn("%s", allEntries);
	
	
	//file.close()!!;

	return 0;
}
