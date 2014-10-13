`timescale 1ns/1ns

module top;
   bit clk = 1;
   always #5 clk = ~clk;



   ifc IFC(clk);
   ff dut(IFC.dut);
   tb bench(IFC.bench);
endmodule
