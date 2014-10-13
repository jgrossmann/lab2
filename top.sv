`timescale 1ns/1ns

module top;
   bit clk = 1;
   always #5 clk = ~clk;

	initial $vcdpluson;

   ifc IFC(clk);
   eff dut(IFC.dut);
   tb bench(IFC.bench);
endmodule
