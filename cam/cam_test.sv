module cam_test();

        logic clk = 1'b0;
	logic reset;
        logic write_enable_i;
        logic read_enable_i;
        logic search_enable_i;
        logic [4 : 0] read_index;
        logic [4 : 0] write_index;
        logic [31 : 0] write_data_i;
        logic [31 : 0] search_data_i;
        logic [31 : 0] read_data_o;
        logic read_valid;
        logic search_valid_o;
        logic [4 : 0] search_index_o;

	always begin
		#5 clk = 1;
		#5 clk = 0;
	end

	cam my_cam
		(.clk,
		.reset,
		.write(write_enable_i),
		.read(read_enable_i),
		.search(search_enable_i),
		.read_index,
		.write_index,
		.write_data(write_data_i),
		.search_data(search_data_i),
		.read_value(read_data_o),
		.read_valid,
		.search_valid(search_valid_o),
		.search_index(search_index_o)
		);

	initial begin
		$vcdpluson;
		reset = 1;
		#10 reset = 0;
		read_enable_i = 0;
		read_index = 5'b00111;
		$display("Checking reset, viewing all outputs");
		#5 $display("Read data: %b, read valid: %b, search index: %b, search valid: %b", read_data_o, read_valid, search_index_o, search_valid_o);
		
		write_enable_i = 1;
		write_index = 5'b00111;
		write_data_i = 32'b1111_0000_1111_0000_1111_0000_1111_0000;
		read_enable_i = 1;
		search_enable_i = 1;
		search_data_i = 32'b1111_0000_1111_0000_1111_0000_1111_0000;
		$display("Writing 1111_0000_1111_0000 ... to index 00111.");
		$display("Reading without waiting for the write, r_data: %b, r_valid: %b, s_index: %b, s_valid: %b",
													read_data_o, read_valid, search_index_o,search_valid_o);
		#20;
		write_enable_i = 0;
		$display("After waiting: r_data: %b, r_valid: %b, s_index: %b, s_valid: %b", read_data_o, read_valid, search_index_o, search_valid_o);
		
		write_enable_i = 0;
		read_enable_i = 0;
		$display("Disabling read. Checking read valid.");
		#5 $display("r_data: %b, r_valid: %b, s_index: %b, s_valid: %b", read_data_o, read_valid, search_index_o, search_valid_o);

		read_enable_i = 1;
		read_index = 5'b01111;
		$display("Enabling read but giving an index that has not been written to.");
		#5 $display("r_data: %b, r_valid: %b, s_index: %b, s_valid: %b", read_data_o, read_valid, search_index_o, search_valid_o);

		search_enable_i = 0;
		$display("Disabling search. Checking search valid.");
		#5 $display("r_data: %b, r_valid: %b, s_index: %b, s_valid: %b", read_data_o, read_valid, search_index_o, search_valid_o);

		search_enable_i = 1;
		search_data_i = 32'b11111111111111111111111111111111;
		$display("Enabling search. Setting search data to all 1's so it should fail.");
		#5 $display("r_data: %b, r_valid: %b, s_index: %b, s_valid: %b", read_data_o, read_valid, search_index_o, search_valid_o);

		write_index = 5'b00000;
		write_enable_i = 1;
		#20;
		search_data_i = 32'b1111_0000_1111_0000_1111_0000_1111_0000;
		$display("Writing same data: 1111_0000_1111_0000 ... to eff 0. Doing a search to see index returned.");
		#5 $display("r_data: %b, r_valid: %b, s_index: %b, s_valid: %b", read_data_o, read_valid, search_index_o, search_valid_o);

		write_data_i = 32'b00000000000000000000000000000000;
		#20;
		read_index = 5'b00000;
		write_enable_i = 0;
		$display("Writing all 0s to eff 0. Checking result.");
		#5 $display("r_data: %b, r_valid: %b, s_index: %b, s_valid: %b", read_data_o, read_valid, search_index_o, search_valid_o);
		
		reset = 1;
		#20;
		reset = 0;
		read_index = 5'b00111;
		search_data_i = 32'b1111_0000_1111_0000_1111_0000_1111_0000;
		$display("Resetting flip flops. Checking result.");
		#5 $display("r_data: %b, r_valid: %b, s_index: %b, s_valid: %b", read_data_o, read_valid, search_index_o, search_valid_o);
		#60 $finish;
	end

endmodule
