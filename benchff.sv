`timescale 1ns/1ns

class transaction;
   rand bit r;
   rand bit w;
   rand bit di;
   bit rst;
   bit do;
   bit rv;
   bit data;   

	function void golden_result;
		if(r) begin
			do = data;
			rv = 1b'1;
		end
		else begin
			rv = 1b'0;
		end
		if(w) begin
			data = di;
		end
      $display("%t : %s \n", $realtime, "Computing Golden Result");
	endfunction

	function bit read_result (bit x, bit y);
      return (x == do && y == rv);
	endfunction
   
	function bit write_result (bit x);
		return (x == rv);
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
			 ds.cb.read_enable <= t.r;
			 ds.cb.write_enable <= t.w;
			 ds.cb.data_i <= t.di;
			 @(ds.cb);
			 t.golden_result();
			 if(t.r) begin
				$display("%t : %s\n", $realtime,t.read_result(ds.cb.data_o, ds.cb.read_valid)?"Pass":"Fail");
			end
			if (t.w) begin
				$display("%t : %s\n", $realtime,t.write_result(ds.cb.read_valid)?"Pass":"Fail");
			end
		end
	end

endprogram
