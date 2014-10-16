`timescale 1ns/1ns
module cam #(parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 5,
	parameter DEPTH = 32,
	parameter SIZE = (DEPTH * DATA_WIDTH))
(ifc_cam.dut d);

	wire [DEPTH - 1 : 0] read_enable;
	wire [DEPTH - 1 : 0] write_enable;
	wire [DEPTH - 1 : 0] search_result;
	wire [DEPTH - 1 : 0] read_valid_list;
	wire [SIZE - 1 : 0] all_data;

// MUX
	cam_mux mux (.all_data_i(all_data),
			.index_i(d.read_index), 
			.read_valid_i(read_valid_list),
			.read_valid_o(d.read_valid),
			.data_o(d.data_o)
			);

// Decoder
	cam_decoder decoder (.write_enable_i(d.write_enable),
				.read_enable_i(d.read_enable), 
				.write_address_i(d.write_index),
				.read_address_i(d.read_index),
				.write_enable_o(write_enable),
				.read_enable_o(read_enable)
				);

// Priority Encoder
	cam_pencoder encoder (.inp_i(search_result), .enable_i(d.search_enable),
				.out_o(d.search_index), 
				.valid_o(d.search_valid)
				);

// Memory
	generate
		for (genvar iter = 0; iter < DEPTH; iter++) begin
			eff memory_word
		(.clk(d.clk),
		.reset(d.rst),
		.read_enable_i(read_enable[iter]),
		.write_enable_i(write_enable[iter]),
		.search_enable_i(d.search_enable),
		.write_data_i(d.data_i),
		.search_data_i(d.search_data),
		.data_o(all_data[DATA_WIDTH*(iter+1)-1 : DATA_WIDTH*(iter+1)-32]),
		.search_o(search_result[iter]),
		.read_valid_o(read_valid_list[iter])
		);
		end
	endgenerate
endmodule
