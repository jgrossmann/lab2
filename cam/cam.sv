module cam #(parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 5,
	parameter DEPTH = 32,
	parameter SIZE = (DEPTH * DATA_WIDTH))
(
	input clk,
	input reset,
	input write,
	input read,
	input search,
	input [ADDR_WIDTH - 1 : 0] read_index,
	input [ADDR_WIDTH - 1 : 0] write_index,
	input [DATA_WIDTH - 1 : 0] write_data,
	input [DATA_WIDTH - 1 : 0] search_data,
	output logic [DATA_WIDTH - 1 : 0] read_value,
	output logic read_valid,
	output logic search_valid,
	output [ADDR_WIDTH - 1 : 0] search_index
);

	wire [DEPTH - 1 : 0] read_enable;
	wire [DEPTH - 1 : 0] write_enable;
	wire [DEPTH - 1 : 0] search_result;
	wire [DEPTH - 1 : 0] read_valid_list;
	wire [SIZE - 1 : 0] all_data;

// MUX
	cam_mux mux (.all_data_i(all_data),
			.index_i(read_index), 
			.read_valid_i(read_valid_list),
			.read_valid_o(read_valid),
			.data_o(read_value)
			);

// Decoder
	cam_decoder decoder (.write_enable_i(write),
				.read_enable_i(read), 
				.write_address_i(write_index),
				.read_address_i(read_index),
				.write_enable_o(write_enable),
				.read_enable_o(read_enable)
				);

// Priority Encoder
	cam_pencoder encoder (.inp_i(search_result),
				.out_o(search_index), 
				.valid_o(search_valid)
				);

// Memory
	generate
		for (genvar iter = 0; iter < DEPTH; iter++) begin
			eff memory_word
		(.clk,
		.reset,
		.read_enable_i(read_enable[iter]),
		.write_enable_i(write_enable[iter]),
		.search_enable_i(search),
		.write_data_i(write_data),
		.search_data_i(search_data),
		.data_o(all_data[DATA_WIDTH*(iter+1)-1 : DATA_WIDTH*(iter+1)-32]),
		.search_o(search_result[iter]),
		.read_valid_o(read_valid_list[iter])
		);
		end
	endgenerate
endmodule
