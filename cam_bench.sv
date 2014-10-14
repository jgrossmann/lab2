`timescale 1ns/1ns

class transaction;
   rand bit read;
   rand bit write;
	rand bit search;
   rand bit [31:0] data_i;
	rand bit [31:0] search_data_i;
	int [4:0] read_index;
	int [4:0] write_index;
	int [4:0] search_index;
   bit rst;
   bit [31:0] data_o;
   bit read_valid;
	bit search_valid;
   bit [31:0][31:0] data_stored;
	bit [31:0] written;

	function void golden_result;
		if(rst) begin
			for(int i = 0; i < 32; i++) begin
				written[i] = '0;
				data_stored[i] = 32'b00000;
			end
		end
		if(read) begin
			data_o = data_stored[read_index];
			read_valid = (written[read_index] == '1) ? '1 : '0;
		end
		else begin
			read_valid = '0;
		end
		if(write) begin
			if(rst) break;
			data_stored[write_index] = data_i;
			written[write_index] = '1;
		end
		if(search) begin
			search_valid = '0;
			for(int i = 0; i < 32; i++) begin
				if((search_data_i == data_stored[i]) && written[i]) begin
					search_index = i;
					search_valid = '1;
				end
			end
		end

		//TO-DO: INSERT SEARCH CASES/FUNCTIONS
      $display("%t : %s \n", $realtime, "Computing Golden Result");
	endfunction

	function bit read_result (bit x, bit y);
      return (x == data_o && y == read_valid);
	endfunction
   
	function bit write_result (bit x);
		return (x == read_valid);
	endfunction

	function bit search_result (int x, bit y)
		return ((x == search_index) && (y == search_valid));
	endfunction
endclass

program tb (ifc.bench ds);
	transaction t;

	initial begin
		repeat (5) begin
			t= new();
			t.randomize();
			t.rst = '1;
			ds.cb.rst <= t.rst;
			@(ds.cb);
		end

		repeat(5) begin
			t = new();
      	t.rst = '0;
      	ds.cb.rst <= t.rst;
			@(ds.cb);
		end

		repeat (15) begin
			 t = new();
			 t.randomize();
			 // drive inputs for next cycle
			 $display("%t : %s \n", $realtime, "Driving New Values");
			 t.rst = '0;

			//make sure we figure out what to do with the mask of input indexes!

			 t.read_index = 5'b00001;
			 t.write_index = 5'b00001;
			 ds.cb.rst <= t.rst;
			 ds.cb.read_index <= t.read_index;
			 ds.cb.write_index <= t.write_index;
			 ds.cb.read_enable <= t.read;
			 ds.cb.write_enable <= t.write;
			 ds.cb.data_i <= t.data_i;
			 @(ds.cb);
			 t.golden_result();
			 if(t.read) begin
				$display("%t : %s  %s\n", $realtime,"read",t.read_result(ds.cb.data_o, ds.cb.read_valid)?"Pass":"Fail");
			end
			if (t.write) begin
				$display("%t : %s  %s\n", $realtime,"write",t.write_result(ds.cb.read_valid)?"Pass":"Fail");
			end
		end
	end

endprogram
