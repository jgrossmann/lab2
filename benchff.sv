`timescale 1ns/1ns

class transaction;
   rand bit read;
   rand bit write;
   rand bit data_i;
   bit rst;
   bit data_o;
   bit read_valid;
   bit data_stored;

	function void golden_result;
		if(read) begin
			data_o = data_stored;
			read_valid = 1b'1;
		end
		else begin
			read_valid = 1b'0;
		end
		if(write) begin
			data = data_i;
		end
      $display("%t : %s \n", $realtime, "Computing Golden Result");
	endfunction

	function bit read_result (bit x, bit y);
      return (x == data_o && y == read_valid);
	endfunction
   
	function bit write_result (bit x);
		return (x == read_valid);
	endfunction
endclass

program tb (ifc.bench ds);
	transaction t;

	initial begin
		repeat (10) begin
			t= new();
			t.randomize();
			t.rst <= 1'b1;
			ds.cb.reset <= t.rst;
		end
		repeat (10000) begin
			 t = new();
			 t.randomize();

			 // drive inputs for next cycle
			 $display("%t : %s \n", $realtime, "Driving New Values");
			 t.rst <= 1'b0;
			 ds.cb.reset <= t.rst;
			 ds.cb.read_enable <= t.read;
			 ds.cb.write_enable <= t.write;
			 ds.cb.data_i <= t.data_i;
			 @(ds.cb);
			 t.golden_result();
			 if(t.read) begin
				$display("%t : %s\n", $realtime,t.read_result(ds.cb.data_o, ds.cb.read_valid)?"Pass":"Fail");
			end
			if (t.w) begin
				$display("%t : %s\n", $realtime,t.write_result(ds.cb.read_valid)?"Pass":"Fail");
			end
		end
	end

endprogram
