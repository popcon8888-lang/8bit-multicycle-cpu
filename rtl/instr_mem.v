// instr_mem.v

module instr_mem(
	input [7:0]addr,
	output [15:0]instruction
);

	reg [15:0] mem[0:255];
	
	integer i;
	
	
	initial begin
		for(i=0; i<256; i=i+1) begin
			mem[i] = 16'h0000;
		end
		
		/* test 1 (ST, LD test)
			MOV R1, 5 → R1 = 5
			MOV R2, 7 → R2 = 7
			ADD R3, R1, R2 → R3 = 12
			ST R3, 20 → mem[20] = R3 = 12
			LD R4, 20 → R4 = mem[20] = 12
			JMP 5 → 
		
			mem[0] = {4'h5, 3'd1, 9'd5}; // MOV R1, 5
			mem[1] = {4'h5, 3'd2, 9'd7}; // MOV R2, 7
			mem[2] = {4'h0, 3'd3, 3'd1, 3'd2, 3'b000}; // ADD R3, R1, R2
			mem[3] = {4'h7, 3'd3, 9'd20}; // ST R3, 20
			mem[4] = {4'h6, 3'd4, 9'd20}; // LD R4, 20
			mem[5] = {4'h8, 12'd5}; // JMP 5
	end
		*/
		/*
			test 2 (JZ test)
			MOV R1, 0
			JZ R1, 4
			MOV R2, 99
			JMP 5
			MOV R2, 10
			JMP 5
		
			mem[0] = {4'h5, 3'd1, 9'd0}; // MOV R1, 0
			mem[1] = {4'h9, 3'd1, 9'd4}; // JZ R1, 4
			mem[2] = {4'h5, 3'd2, 9'd99}; // MOV R2, 99 (MUST BE SKIP)
			mem[3] = {4'h8, 12'd5}; // JMP 5
			mem[4] = {4'h5, 3'd2, 9'd10}; // MOV R2, 10
			mem[5] = {4'h8, 12'd5}; // JMP 5
	end
		*/
		/*
		 test 3 
			MOV R1, 12
			MOV R2, 10
			SUB R3, R1, R2 → R3 = 2
			AND R4, R1, R2 → R4 = 8
			OR R5, R1, R2 → R5 = 14
			XOR R6, R1, R2 → R6 = 6
			JMP 6
		*/
		/*
			mem[0] = {4'h5, 3'd1, 9'd12};
			mem[1] = {4'h5, 3'd2, 9'd10};
			mem[2] = {4'h1, 3'd3, 3'd1, 3'd2, 3'b000};
			mem[3] = {4'h2, 3'd4, 3'd1, 3'd2, 3'b000};
			mem[4] = {4'h3, 3'd5, 3'd1, 3'd2, 3'b000};
			mem[5] = {4'h4, 3'd6, 3'd1, 3'd2, 3'b000};
			mem[6] = {4'h8, 12'd6};
	end
	*/
	/*
			test 4 (R0 hardwired 0)
			MOV R0, 99
			MOV R1, 5
			ADD R2, R0, R1 → R2 = 0+5=5
	
			mem[0] = {4'h5, 3'd0, 9'd99}; // MOV R0, 99
			mem[1] = {4'h5, 3'd1, 9'd5}; // MOV R1, 5
			mem[2] = {4'h0, 3'd2, 3'd0, 3'd1, 3'b000}; // ADD R2, R0, R1
			mem[3] = {4'h8, 12'd3}; // JMP 3
	end
	*/
	/*
			test 5 (JZ not-taken)
			R1 = 3
			JZ R1, 4
			MOV R2, 55
			JMP 5
			MOV R2, 99
			
			mem[0] = {4'h5, 3'd1, 9'd3};
			mem[1] = {4'h9, 3'd1, 9'd4};
			mem[2] = {4'h5, 3'd2, 9'd55};
			mem[3] = {4'h8, 12'd5};
			mem[4] = {4'h5, 3'd2, 9'd99};
			mem[5] = {4'h8, 12'd5};
	end
	*/
	/*
			test 6 (LD/ST test2)
			R1 = 21
			R2 = 34
			mem[30] = R1
			mem[40] = R2
			R3 = mem[30]
			R4 = mem[40]
			
			mem[0] = {4'h5, 3'd1, 9'd21};
			mem[1] = {4'h5, 3'd2, 9'd34};
			mem[2] = {4'h7, 3'd1, 9'd30};
			mem[3] = {4'h7, 3'd2, 9'd40};
			mem[4] = {4'h6, 3'd3, 9'd30};
			mem[5] = {4'h6, 3'd4, 9'd40};
			mem[6] = {4'h8, 12'd6};
	end
	*/
	/*
			test 7 (overflow test)
			127 + 1 = -128
			01111111 + 00000001 = 10000000
			signed overflow
	
			mem[0] = {4'h5, 3'd1, 9'd127};
			mem[1] = {4'h5, 3'd2, 9'd1};
			mem[2] = {4'h0, 3'd3, 3'd1, 3'd2, 3'b000};
			mem[3] = {4'h8, 12'd3};
	end
	
	/*
			test 8 (carry test)
			255 + 1 = 0, carry =1
	*/
			mem[0] = {4'h5, 3'd1, 9'd255};
			mem[1] = {4'h5, 3'd2, 9'd1};
			mem[2] = {4'h0, 3'd3, 3'd1, 3'd2, 3'b000};
			mem[3] = {4'h8, 12'd3};
	end
	

	assign instruction = mem[addr];

endmodule