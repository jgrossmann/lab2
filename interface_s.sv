`timescale 1ns/1ns

interface ifc (input bit clk);
   logic [31:0] data_i;
	logic [31:0] search_data;
   logic [31:0] data_o;
   logic read_enable;
   logic write_enable;
	logic search_enable;
   logic read_valid;
	logic search_valid;
	logic [4:0] read_index;
	logic [4:0] write_index;
	logic [4:0] search_index;
   logic rst;

   // note that the outputs and inputs are reversed from the dut
   clocking cb @(posedge clk);
      output 	data_i, read_enable, write_enable, read_index, write_index,
					search_data, search_enable, rst;

      input 	data_o, read_valid, search_valid, search_index;
   endclocking

   modport bench (clocking cb);

   modport dut (
		input  data_i, read_enable, write_enable, read_index, write_index,
				 search_data, search_enable, rst, clk,
		output data_o, read_valid, search_valid, search_index
		);
endinterface
