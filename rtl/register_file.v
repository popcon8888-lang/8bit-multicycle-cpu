//register_file.v

module register_file2# (parameter WIDTH=8,DEPTH=8)(
	input clk,
	input we,
	input reset,
	input [$clog2(DEPTH)-1:0]waddr, //decoder
	input [$clog2(DEPTH)-1:0]raddr1, //mux
	input [$clog2(DEPTH)-1:0]raddr2,
	input [WIDTH-1:0]wdata,
	output [WIDTH-1:0]rdata1,
	output [WIDTH-1:0]rdata2
);
	
	reg [WIDTH-1:0] regs[0:DEPTH-1];
	integer i;

	always@ (posedge clk or posedge reset) begin
		if(reset) begin
			for(i=0; i<DEPTH; i=i+1)begin
				regs[i] <= {WIDTH{1'b0}};
			end
		end
		else if (we && (waddr !=0)) begin
			regs[waddr] <= wdata;
		end
	end
	
	assign rdata1= (raddr1==0) ? {WIDTH{1'b0}} : regs[raddr1];
	assign rdata2= (raddr2==0) ? {WIDTH{1'b0}} : regs[raddr2];
endmodule

		
