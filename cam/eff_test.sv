module eff_test();
	logic clk = 1'b0;
	logic reset;
	logic [31:0] write_enable;
	logic [31:0] read_enable;
	logic search_enable_i;
	logic [31:0] write_data_i;
	logic [31:0] search_data_i;
	logic [31:0] data_o;
	logic search_o;
	logic read_enable_o;
	logic [31:0] search_index;
	assign DATA_WIDTH = 32;
        assign ADDR_WIDTH = 5;
        assign DEPTH = 32;
        assign SIZE = (DEPTH * DATA_WIDTH);
	wire [1023 : 0] all_data;
	logic [31:0] read_valid_out;
	logic [31:0] search_result;

        generate
                for (genvar iter = 0; iter < 32; iter++) begin
                	eff#(.WIDTH(32)) memory_word
			(.clk,
			.reset,
			.read_enable_i(read_enable[iter]),
			.write_enable_i(write_enable[iter]),
			.search_enable_i,
			.write_data_i,
			.search_data_i,
			.data_o(all_data[32*(iter+1)-1 : 32*(iter+1)-32]),
			.search_o(search_result[iter]),
			.read_valid_o(read_valid_out[iter])
			);
                end
        endgenerate

	initial begin
		forever #5 clk = ~clk;
	end

	initial begin
                $vcdpluson;
		reset = 1;
		#20 reset = 0;
		#5 $display("Read valid in beginning: %b", read_valid_out);

                read_enable = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
		#5; $display("Read valid after setting read_enable to all 1s (should still be off): %b", read_valid_out);

		read_enable = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
		search_data_i = 32'b1111_0000_1111_0000_1111_0000_1111_0000;
		search_enable_i = 1;
		#5 $display("After setting search_enable to 1, search valid is (should be 32 0s): %b", search_result);

		search_enable_i = 0;
		write_data_i = 32'b1111_0000_1111_0000_1111_0000_1111_0000;
                write_enable[0] = 1;
                search_enable_i = 0;
		read_enable[0] = 1;
                #20 $display("After writing 1111_0000_1111_0000... to flip flop 0 and enabling a read, the read valid is: %b, the data is: %b",read_valid_out, all_data[31:0] );
 		
		write_enable[0] = 0;
		search_enable_i = 1;
		#5 $display("Search enabled. The search result of the data previously written to flip flop 0 is: %b", search_result);
		
		write_data_i = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
		write_enable[0] = 1;
		#20;
		#5 $display("Overwriting flip flop 0 to all 0s. Data read is: %b, read_valid is (still valid): %b, and  search_result is: %b", all_data[31:0],
														read_valid_out, search_result);
		
		read_enable[0] = 0;
		write_enable[0] = 0;
		write_data_i = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
		write_enable[31] = 1;
		read_enable[31] = 1;
		search_data_i = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
		$display("writing to flip flop 31. With no wait, Data read is: %b, read_valid is: %b, search_result is: %b", all_data[1023:992],
												read_valid_out, search_result);
		#5 $display("flip flop 31 after a few cycles, data is %b, read_valid is: %b, search_result is: %b", all_data[1023:992],
												read_valid_out, search_result);

		write_enable[31] = 0;
		reset = 1;
		#20 reset = 0;
		#5 $display("Reset flip flops. Checking result.");
		$display("data is %b, read_valid is: %b, search_result is: %b", all_data[1023:992],read_valid_out, search_result);
		#60 $finish;
	end	
	
endmodule
