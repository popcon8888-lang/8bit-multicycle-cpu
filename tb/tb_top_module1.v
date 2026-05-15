// tb_top_module1.v

`timescale 1ns/1ps

module tb_top_module1;

	reg clk;
	reg reset;
	
	top_module1 uut(
		.clk(clk),
		.reset(reset)
	);
	
	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end
	
	initial begin
		reset = 1'b1;
		
		#20;
		reset = 1'b0;
		
		#500;
		
		$stop;
	end
	
endmodule

		