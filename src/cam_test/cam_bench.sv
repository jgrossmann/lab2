`timescale 1ns/1ns

class configuration;
	rand int random_seed;
	rand int reset_density;
	rand int read_density;
	rand int write_density;
	rand int search_density;
	rand bit [4:0] read_index_mask;
	rand bit [4:0] write_index_mask;
	rand bit [31:0] write_data_mask;
	rand bit [31:0] search_data_mask;
	bit auto_config;
	int max_cycles;

	int file;
	real val;
	string t_var;

	constraint densities {
		reset_density <= 100;
		read_density <= 100;
		write_density <= 100;
		search_density <= 100;
	}	

	function new();

		file = $fopen("config.txt" ,"r");
		if(file == 0) begin
			$display("ERROR: can not open file 'config.txt'");
			$finish;
		end

		while(!$feof(file)) begin
			if($fscanf(file,"%s %f\n", t_var, val)) begin
				$display("scan: %s %f", t_var, val);
			end
	
			case(t_var)
				"RANDOM_SEED": random_seed = val;
				"MAX_CYCLES": max_cycles = val;
				"RESET_DENSITY": reset_density = val*100;
				"READ_DENSITY": read_density = val*100;
				"WRITE_DENSITY": write_density = val*100;
				"SEARCH_DENSITY": search_density = val*100;
				"INDEX_MASK_READ": read_index_mask = val;
				"INDEX_MASK_WRITE": write_index_mask = val;
				"DATA_MASK_WRITE": write_data_mask = val;
				"DATA_MASK_SEARCH": search_data_mask = val;
				"AUTO_CONFIGURE": auto_config = val;
			endcase
		end
		$fclose(file);
	endfunction
endclass
	
class transaction;
	rand bit read;
	rand bit write;
	rand bit search;
	rand bit [31:0] data_i;
	rand bit [31:0] search_data_i;
	rand bit [4:0] read_index;
	rand bit [4:0] write_index;
	rand bit rst;
	
	bit [4:0] search_index;		
	bit [31:0] data_o;
	bit read_valid;
	bit search_valid;
	bit [31:0][31:0] data_stored;
	bit [31:0] written;
	bit prev_write; //these are used to delay the written data from being available until the following clock cycle
	bit [4:0] prev_write_index;
	bit [31:0] prev_data_i;

	configuration c;

	constraint trans_const {
		rst dist {0:= 100-c.reset_density, 1:=c.reset_density};
		read dist {0:= 100-c.read_density, 1:=c.read_density};
		write dist {0:=100-c.write_density, 1:=c.write_density};
		search dist {0:=100-c.search_density, 1:=c.search_density};
	}
		
	function new(configuration conf);
		c = conf;
		this.srandom(c.random_seed);		
	endfunction

	function void post_randomize();
		read_index = read_index & c.read_index_mask;
      write_index = write_index & c.write_index_mask;
      search_data_i = search_data_i & c.search_data_mask;
      data_i = data_i & c.write_data_mask;
	endfunction

	function void golden_result;
		
		if(rst) begin
			prev_data_i = 32'd0;
			prev_write_index = 5'd0;
			prev_write = 0;
			for(int i = 0; i < 32; i++) begin
				written[i] = 0;
				data_stored[i] = 32'd0;
			end
			search_valid = 0;
			read_valid = 0;
		end else begin

      if(prev_write) begin //if the previous clock cycle had the write signal assert$
         data_stored[prev_write_index] = prev_data_i; //store the data
         written[prev_write_index] = '1; //mark the cell as being written to
      end

		if(read) begin
			data_o = data_stored[read_index]; //get stored data
			read_valid = (written[read_index] == '1) ? '1 : '0; //check if data was been written there
		end
		else begin
			read_valid = '0;
		end
		if(write) begin
			//if(rst) break;
			prev_data_i = data_i; //store in prev data to be used in next clock cycle
			prev_write_index = write_index;
		end
		prev_write = write;
		if(search) begin
			search_valid = '0;
			for(int i = 0; i < 32; i++) begin
				if((search_data_i == data_stored[i]) && written[i]) begin //if the data is found
					search_index = i;
					search_valid = '1;
					break;
				end
			end
		end else begin
			search_valid = 0;
		end
		end

		
      $display("%t : %s \n", $realtime, "Computing Golden Result");
	endfunction

	function bit read_result (bit [31:0] x, bit y); //check if read valid bit is correct and if it is high, check if output data is correct
			//$display("readcheck %t %t", data_o, read_valid);
			//$display("readcheck %t %t", x, y);
			//$display("readcheck %t %t", x==data_o, y==read_valid);
			if(y || read_valid) begin 
				return ((x == data_o) && (y == read_valid));
			end else begin
				return (y == read_valid);
			end
	endfunction
   
   //We check write functionality sumply by confirming that reads work properly, i.e. that a read which occurs a clock cycle after a write will read the written data
	
	function bit search_result (bit [4:0] x, bit y); //compares search results
		//$display("searchcheck %t %t", search_index, search_valid);
		//$display("searchcheck %t %t", x, y);
		//$display("searchcheck %t %t", x==search_index, y==search_valid);
		if(y || search_valid) begin
			return ((x==search_index) && (y == search_valid));
		end else begin
			return (y==search_valid);
		end
	endfunction
endclass

program tb_cam (ifc_cam.bench ds);
	transaction t;
	configuration c;
	initial begin
		c = new();
		$srandom(c.random_seed);
		if(c.auto_config) begin
			c.randomize();
			c.max_cycles = 10000;
		end
		t= new(c);
		t.randomize();
		t.rst = 1; //First reset everything
		ds.cb.rst <= t.rst;
		@(ds.cb);
		t.prev_write = 1'b0;
		repeat (c.max_cycles) begin
			 t.randomize();
			 $display("%t : %s \n", $realtime, "Driving New Values");
			 //$display("%t\n%t\n%t\n%b\n%b\n%b\n%b\n%b\n", t.read,t.write,t.search,t.data_i,t.search_data_i,t.read_index,t.write_index,t.rst);
			 //drive the inputs to the cam
			 ds.cb.rst <= t.rst;
			 ds.cb.read_index <= t.read_index;
			 ds.cb.write_index <= t.write_index;
			 ds.cb.read_enable <= t.read;
			 ds.cb.write_enable <= t.write;
			 ds.cb.data_i <= t.data_i;
			ds.cb.search_enable <= t.search;
			ds.cb.search_data <= t.search_data_i;
		
			 @(ds.cb);
			 t.golden_result(); //evaluate our expected results
			$display("%t : %s  %s\n", $realtime,"read",t.read_result(ds.cb.data_o, ds.cb.read_valid)?"Pass":"Fail"); //check the read result
			$display("%t : %s  %s\n", $realtime,"search",t.search_result(ds.cb.search_index, ds.cb.search_valid)?"Pass":"Fail"); //check the search result
			
		end
	end

endprogram
