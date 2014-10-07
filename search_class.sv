class Search_Transaction;
	//Do we need to implement the write interface as well?
	//How will search work without something written first.

	//search inputs
	rand bit search_enable;
	rand bit [4 : 0] search_index;

	//outputs
	bit [31 : 0] search_data;
	bit search_valid;
	
	function golden_result;
		
	endfunction

endclass
