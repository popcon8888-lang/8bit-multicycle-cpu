// control_unit.v

/* ISA
	R-type - ADD, SUB, AND, OR, XOR
	[15:12] opcode
	[11:9] rd
	[8:6] rs1
	[5:3] rs2
	[2:0] unused
	
	I-type - MOV, LD, ST
	[15:12] opcode
	[11:9] rd		// MOV/LD: write reg, ST: read reg
	[8:0] imm
	
	JZ-type - JZ
	[15:12] opcode
	[11:9] rs1		// condition register
	[8:0] imm
	
	J-type - JMP
	[15:12] opcode
	[11:0] imm
*/

module control_unit(
	input clk,
	input reset,
	input [15:0] instruction,
	input jz_zero,
	
	output reg rf_we,
	output reg mem_we,
	output reg pc_we,
	output reg ir_we,
	output reg [3:0] alu_sel,
	output reg [1:0] wb_sel,
	output reg [1:0] pc_sel,
	output reg [2:0] state
);

	//state
	localparam FETCH= 3'd0;
	localparam DECODE= 3'd1;
	localparam EXEC = 3'd2;
	localparam MEM= 3'd3;
	localparam WB= 4'd4;
	
	//opcode
	localparam OP_ADD= 4'h0;
	localparam OP_SUB= 4'h1;
	localparam OP_AND= 4'h2;
	localparam OP_OR= 4'h3;
	localparam OP_XOR= 4'h4;
	localparam OP_MOV= 4'h5;
	localparam OP_LD= 4'h6;
	localparam OP_ST= 4'h7;
	localparam OP_JMP= 4'h8;
	localparam OP_JZ= 4'h9;
	
	//ALU select
	localparam ALU_ADD= 4'h1;
	localparam ALU_SUB= 4'h2;
	localparam ALU_AND= 4'h3;
	localparam ALU_OR= 4'h4;
	localparam ALU_XOR= 4'h5;
	
	//wriet=back select
	localparam WB_ALU= 2'd0;
	localparam WB_MEM= 2'd1;
	localparam WB_IMM= 2'd2;
	
	//PC select
	localparam PC_PLUS1= 2'd0;
	localparam PC_IMM= 2'd1;
	
	wire [3:0] opcode;
	assign opcode = instruction[15:12];
	
	reg[2:0] next_state;
	
	//state register
	always @(posedge clk or posedge reset) begin
		if(reset)
			state <= FETCH;
		else
			state <= next_state;
	end
	
	
	//next state logic
	always @(*) begin
		next_state = FETCH;
		
		case(state)
			FETCH: begin
				next_state = DECODE;
			end
			
			DECODE: begin
				next_state = EXEC;
			end
			
			EXEC: begin
				case(opcode)
					OP_ADD,
					OP_SUB,
					OP_AND,
					OP_OR,
					OP_XOR,
					OP_MOV: begin
						next_state = WB;
					end
					
					OP_LD,
					OP_ST: begin
						next_state = MEM;
					end
					
					OP_JMP,
					OP_JZ: begin
						next_state = FETCH;
					end
					
					default: begin
						next_state = FETCH;
					end
				endcase
			end
			
			MEM: begin
				if(opcode == OP_LD)
					next_state = WB;
				else
					next_state = FETCH;
			end
			
			WB: begin
				next_state = FETCH;
			end
			
			default: begin
				next_state = FETCH;
			end
		endcase
	end
	
	//output control logic
	always @(*) begin
		// default values
		rf_we= 1'b0;
		mem_we= 1'b0;
		pc_we= 1'b0;
		ir_we= 1'b0;
		alu_sel= 4'h0;
		wb_sel= WB_ALU;
		pc_sel= PC_PLUS1;
		
		case(state)
			FETCH: begin
				ir_we= 1'b1;
				pc_we= 1'h1;
				pc_sel= PC_PLUS1;
			end
			
			DECODE: begin
				// register read / instruction decode
			end
			
			EXEC: begin
				case(opcode)
					OP_ADD: alu_sel = ALU_ADD;
					OP_SUB: alu_sel = ALU_SUB;
					OP_AND: alu_sel = ALU_AND;
					OP_OR: alu_sel = ALU_OR;
					OP_XOR:alu_sel = ALU_XOR;
					
					OP_JMP: begin
						pc_we = 1'b1;
						pc_sel = PC_IMM;
					end
					
					OP_JZ: begin
						if(jz_zero) begin
							pc_we = 1'b1;
							pc_sel = PC_IMM;
						end
					end
					OP_MOV: begin
						// NO ALU
					end
					
				endcase
			end
			
			MEM: begin
				case(opcode)
					OP_ST: begin
						mem_we = 1'b1;
					end
				endcase
			end
			
			
			WB: begin
				case(opcode)
					OP_ADD: begin
						alu_sel = ALU_ADD;
						rf_we = 1'b1;
						wb_sel = WB_ALU;
					end
					
					OP_SUB: begin
						alu_sel = ALU_SUB;
						rf_we = 1'b1;
						wb_sel = WB_ALU;
					end
					
					OP_AND: begin
						alu_sel = ALU_AND;
						rf_we = 1'b1;
						wb_sel = WB_ALU;
					end
					
					OP_OR: begin
						alu_sel = ALU_OR;
						rf_we = 1'b1;
						wb_sel = WB_ALU;
					end
					
					OP_XOR: begin
						alu_sel = ALU_XOR;
						rf_we = 1'b1;
						wb_sel = WB_ALU;
					end
					
					OP_MOV: begin
						rf_we = 1'b1;
						wb_sel = WB_IMM;
					end
					
					OP_LD: begin
						rf_we = 1'b1;
						wb_sel = WB_MEM;
					end
				endcase
			end
		endcase
	end
endmodule

					
		
			