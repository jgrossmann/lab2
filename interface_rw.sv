`timescale 1ns/1ns

interface ifc (input bit clk);
   logic [31:0] data_i;
   logic [31:0] data_o;
   logic read_enable;
   logic write_enable;
   logic read_valid;
	logic [4:0] read_index;
	logic [4:0] write_index;
   logic rst;

   // note that the outputs and inputs are reversed from the dut
   clocking cb @(posedge clk);
      output 	data_i, read_enable, write_enable, read_index, write_index, rst;
      input 	data_o, read_valid;
   endclocking

   modport bench (clocking cb);

   modport dut (
		input  data_i, read_enable, write_enable, read_index, write_index, rst, clk,
		output data_o, read_valid
		);
endinterface
