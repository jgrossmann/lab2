module cam_decoder #(parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 5,
	parameter DEPTH = 32,
	parameter SIZE = (DEPTH * DATA_WIDTH))
(
	input write_enable_i,
	input read_enable_i,
	input [ADDR_WIDTH - 1 : 0] write_address_i,
	input [ADDR_WIDTH - 1 : 0] read_address_i,
	output logic [DEPTH - 1 : 0] read_enable_o,
	output logic [DEPTH - 1 : 0] write_enable_o
);
	logic [DEPTH - 1 : 0] write_enable;
	logic [DEPTH - 1 : 0] read_enable;
	always_comb begin
		for (int iter = 0; iter < DEPTH; iter++) begin

			//Setting the indexes of the flip flop rows which are read
			//or write enabled.

			write_enable[iter] = (iter == write_address_i);
			read_enable[iter] = (iter == read_address_i);
			read_enable_o[iter] = read_enable[iter] & read_enable_i;
			write_enable_o[iter] = write_enable[iter] & write_enable_i;
		end
	end
endmodule
