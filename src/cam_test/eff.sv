`timescale 1ns/1ns
module eff #(parameter WIDTH = 32)
(
	input clk,
	input reset,
	input read_enable_i,
	input write_enable_i,
	input search_enable_i,
	input [WIDTH - 1 : 0] write_data_i,
	input [WIDTH - 1 : 0] search_data_i,
	output reg [WIDTH - 1 : 0] data_o,
	output logic search_o,
	output logic read_valid_o
);

	reg [WIDTH - 1 : 0] data;
	reg written;

	always_ff @(posedge clk) begin

		if(reset) begin
			data <= 32'b00000000000000000000000000000000;
			written <= 0;
		end else begin

		// writes data and sets written bit to memory

			if (write_enable_i) begin
				data <= write_data_i;
				written <= 1;
			end
		end
	end
	
	always_comb begin
		
		if (reset) begin
         read_valid_o = 0;
         search_o = 0;
		end else begin

			read_valid_o = (read_enable_i & written) ? 1'b1 : 1'b0;	
	
			// matching logic of the search interface
			if(search_enable_i) begin
				search_o = (search_data_i == data);
				search_o = search_o & written;
			end
		end
	end
	
	assign data_o = data;

	
endmodule
			
		
		
		
		
		
		
		
		
		
		
		
		
		
		
