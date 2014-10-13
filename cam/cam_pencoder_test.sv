module cam_pencoder_test();
	
	logic [31:0] inp_i;
	logic [4:0] out_o;
	logic valid_o;

	cam_pencoder pencoder
		(.inp_i,
		.out_o,
		.valid_o
		);

	initial begin
		$vcdpluson;
		inp_i = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
		#5 $display("Setting input addres to 1. Encoded address is: %b. Valid bit is: %b",out_o, valid_o );

		inp_i = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
		#5 $display("Setting input addres to 32. Encoded address is: %b. Valid bit is: %b",out_o, valid_o );

		inp_i = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
		#5 $display("Setting input addres to 0. Encoded address is: %b. Valid bit is: %b",out_o, valid_o );

	end
endmodule
