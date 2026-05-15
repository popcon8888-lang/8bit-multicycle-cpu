//register_file.v

module register_file #(parameter WIDTH = 8, DEPTH = 8)(
	input clk,
	input we,
	
	input [$clog2(DEPTH)-1:0] waddr, // Write address // Decoder
	input [$clog2(DEPTH)-1:0] raddr1, // Read address //MUX
	input [$clog2(DEPTH)-1:0] raddr2, // clog2 - ex) log2(8)= 3 → input[2:0]
	input [WIDTH-1:0] wdata,
	output [WIDTH-1:0] rdata1,
	output [WIDTH-1:0] rdata2
);

	reg [WIDTH-1:0] regs [0:DEPTH-1]; // ex) reg[7:0] regs[0:7] → exist 7bit 7 register
	
	// Synchronous Write
	always @(posedge clk) begin
		if (we)
			regs[waddr] <= wdata; 
		end
		
		// !!! assign - Continuous Assignment !!!
		// Asynchronous / Combinational Read
		assign rdata1 = regs[raddr1]; 
		assign rdata2 = regs[raddr2];
endmodule



module register# (parameter WIDTH =4, DEPTH=4)(
	input clk,
	input we,
	input [$clog2(DEPTH)-1:0]waddr,
	input [$clog2(DEPTH)-1:0]raddr1,
	input [$clog2(DEPTH)-1:0]raddr2,
	output [WIDTH-1:0]wdata,
	output [WIDTH-1:0]rdata1,
	output [WIDTH-1:0]rdata2
);
	reg [WIDTH-1:0] regs[0:DEPTH-1];
	
	always @ (posedge clk) begin
		if(we)
			regs[waddr] <= wdata;
		end
		
		assign rdata1 = regs[raddr1];
		assign rdata2 = regs[raddr2];
endmodule


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

		
