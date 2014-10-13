`timescale 1ns/1ns
module eff(ifc.dut d);

   reg data;

   always_ff@(posedge d.clk) begin
		if(d.rst) begin
			data <= '0;
		end

		if(d.write_enable) begin
			data <= d.data_i;
		end
	end

	always_comb begin
		d.data_o = data;
		d.read_valid = d.read_enable ? '1 : '0;
	end

endmodule

