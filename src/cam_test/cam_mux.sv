`timescale 1ns/1ns
module cam_mux #(parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 5,
	parameter DEPTH = 32,
	parameter SIZE = (DEPTH * DATA_WIDTH))
	
( 
	input [SIZE - 1 : 0] all_data_i,
	input [ADDR_WIDTH - 1 : 0] index_i,
	input [DATA_WIDTH - 1: 0] read_valid_i,
	output logic read_valid_o,
	output [DATA_WIDTH - 1 : 0] data_o
);

	reg [31:0] mid;
	reg temp_read_valid;

	
	always_comb begin	
	
		case(index_i)
			// Setting slecting the data corresponding to the correct address

			5'd0:  mid = all_data_i[31:0];
			5'd1:  mid = all_data_i[63:32];
			5'd2:  mid = all_data_i[95:64];
			5'd3:  mid = all_data_i[127:96];
			
			5'd4:  mid = all_data_i[159:128];
			5'd5:  mid = all_data_i[191:160];
			5'd6:  mid = all_data_i[223:192];
			5'd7:  mid = all_data_i[255:224];
			
			5'd8:  mid = all_data_i[287:256];
			5'd9:  mid = all_data_i[319:288];
			5'd10: mid = all_data_i[351:320];
			5'd11: mid = all_data_i[383:352];
			
			5'd12: mid = all_data_i[415:384];
			5'd13: mid = all_data_i[447:416];
			5'd14: mid = all_data_i[479:448];
			5'd15: mid = all_data_i[511:480];
			
			5'd16: mid = all_data_i[543:512];
			5'd17: mid = all_data_i[575:544];
			5'd18: mid = all_data_i[607:576];
			5'd19: mid = all_data_i[639:608];
			
			5'd20: mid = all_data_i[671:640];
			5'd21: mid = all_data_i[703:672];
			5'd22: mid = all_data_i[735:704];
			5'd23: mid = all_data_i[767:736];
			
			5'd24: mid = all_data_i[799:768];
			5'd25: mid = all_data_i[831:800];
			5'd26: mid = all_data_i[863:832];
			5'd27: mid = all_data_i[895:864];
			
			5'd28: mid = all_data_i[927:896];
			5'd29: mid = all_data_i[959:928];
			5'd30: mid = all_data_i[991:960];
			5'd31: mid = all_data_i[1023:992];
			

		endcase

		temp_read_valid = 0;
		
		//the decoder took care of indexing the correct read valid.
		//this sets the 1 bit read_valid output by ORing the 32 bit
		//read_valid signal that was given from the decoder and effs.

		for(int iter=0; iter<32; iter++) begin
			temp_read_valid = temp_read_valid | read_valid_i[iter];
		end
		
	end
	
	assign data_o = mid;
	assign read_valid_o = temp_read_valid;

endmodule
		
