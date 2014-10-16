`timescale 1ns/1ns
module cam_pencoder(
	inp_i,
	enable_i,
	out_o,
	valid_o
);

	input [31:0] inp_i;
	input logic enable_i;
	output logic [4:0] out_o;
	output logic valid_o;

	always_comb begin
		casex (inp_i)

			// Sets the search index output to the encoded index of
			// the flip flop which contained the search string

			32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxx1: out_o=5'd0;
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx1x: out_o=5'd1;// x stands for dont care
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x1xx: out_o=5'd2;// bit positions at "x" will be ignored
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_1xxx: out_o=5'd3;
			
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxx1_xxxx: out_o=5'd4;
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx1x_xxxx: out_o=5'd5;
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x1xx_xxxx: out_o=5'd6;
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_1xxx_xxxx: out_o=5'd7;
			
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxx1_xxxx_xxxx: out_o=5'd8;
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_xx1x_xxxx_xxxx: out_o=5'd9;
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_x1xx_xxxx_xxxx: out_o=5'd10;
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_1xxx_xxxx_xxxx: out_o=5'd11;
			
			32'bxxxx_xxxx_xxxx_xxxx_xxx1_xxxx_xxxx_xxxx: out_o=5'd12;
			32'bxxxx_xxxx_xxxx_xxxx_xx1x_xxxx_xxxx_xxxx: out_o=5'd13;
			32'bxxxx_xxxx_xxxx_xxxx_x1xx_xxxx_xxxx_xxxx: out_o=5'd14;
			32'bxxxx_xxxx_xxxx_xxxx_1xxx_xxxx_xxxx_xxxx: out_o=5'd15;
			
			32'bxxxx_xxxx_xxxx_xxx1_xxxx_xxxx_xxxx_xxxx: out_o=5'd16;
			32'bxxxx_xxxx_xxxx_xx1x_xxxx_xxxx_xxxx_xxxx: out_o=5'd17;
			32'bxxxx_xxxx_xxxx_x1xx_xxxx_xxxx_xxxx_xxxx: out_o=5'd18;
			32'bxxxx_xxxx_xxxx_1xxx_xxxx_xxxx_xxxx_xxxx: out_o=5'd19;
			
			32'bxxxx_xxxx_xxx1_xxxx_xxxx_xxxx_xxxx_xxxx: out_o=5'd20;
			32'bxxxx_xxxx_xx1x_xxxx_xxxx_xxxx_xxxx_xxxx: out_o=5'd21;
			32'bxxxx_xxxx_x1xx_xxxx_xxxx_xxxx_xxxx_xxxx: out_o=5'd22;
			32'bxxxx_xxxx_1xxx_xxxx_xxxx_xxxx_xxxx_xxxx: out_o=5'd23;
			
			32'bxxxx_xxx1_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: out_o=5'd24;
			32'bxxxx_xx1x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: out_o=5'd25;
			32'bxxxx_x1xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: out_o=5'd26;
			32'bxxxx_1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: out_o=5'd27;
			
			32'bxxx1_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: out_o=5'd28;
			32'bxx1x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: out_o=5'd29;
			32'bx1xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: out_o=5'd30;
			32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: out_o=5'd31;
			default: out_o=5'd0;
		endcase

		//Sets valid bit of search based on if the search was successful

		if ((inp_i == 32'd0) || (enable_i == 0)) begin
			valid_o = 1'b0;
		end

		else begin
			valid_o = 1'b1;
		end
	end

endmodule
