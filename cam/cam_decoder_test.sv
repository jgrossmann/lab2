module cam_decoder_test();

	logic write_enable_i;
	logic read_enable_i;
	logic [4 : 0] write_address_i;
	logic [4 : 0] read_address_i;
	logic [31 : 0] read_enable_o;
	logic [31 : 0] write_enable_o;

	cam_decoder decoder
		(.write_enable_i,
		.read_enable_i,
		.read_address_i,
		.write_address_i,
		.write_enable_o,
		.read_enable_o
		);

	 initial begin
                $vcdpluson;
		read_enable_i = 0;
		read_address_i = 5'b00000;
		#5 $display("Read disabled. the enabled read output is %b", read_enable_o);

                write_enable_i = 1;
		write_address_i = 5'b00001;
                #5 $display("Enabling write address 2/32, the enabled write output is %b", write_enable_o);

		write_enable_i = 0;
		#5 $display("disabling write address 2/32, the enabled write output is %b", write_enable_o);

		read_enable_i = 1;
		read_address_i = 5'b00001;
		#5 $display("Enabling address 2/32 to read, the enable read output is %b", read_enable_o);

		read_enable_i = 0;
		#5 $display("Disabling address 2/32 to read, the enable read output is %b", read_enable_o);
        end

endmodule
