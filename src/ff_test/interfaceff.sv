`timescale 1ns/1ns

interface ifc (input bit clk);
   logic data_i;
   logic data_o;
   logic read_enable;
   logic write_enable;
   logic read_valid;
   logic rst;

   // note that the outputs and inputs are reversed from the dut
   clocking cb @(posedge clk);
      output 	data_i, read_enable, write_enable, rst;
      input 	data_o, read_valid;
   endclocking

   modport bench (clocking cb);

   modport dut (
		input  data_i, read_enable, write_enable, rst, clk,
		output data_o, read_valid
		);
endinterface
