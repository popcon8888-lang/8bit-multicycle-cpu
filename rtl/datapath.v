//datapath.v

module datapath(
	input clk,
	input reset,
	input rf_we,
	input mem_we,
	input pc_we,
	input ir_we,
	input [3:0] alu_sel,
	input [1:0] wb_sel,
	input [1:0] pc_sel,
	
	output [15:0] instruction,
	output jz_zero
);

	localparam OP_JZ= 4'h9;
	
	localparam WB_ALU= 2'd0;
	localparam WB_MEM= 2'd1;
	localparam WB_IMM= 2'd2;
	localparam PC_PLUS1= 2'd0;
	localparam PC_IMM= 2'd1;
	
	reg [7:0]pc;
	reg [7:0]next_pc;
	reg [15:0]ir;
	
	wire [3:0]opcode;
	assign opcode = instruction[15:12];
	
	wire [2:0]rd;
	wire [2:0]rs1;
	wire [2:0]rs2;
	
	assign rd = instruction[11:9];
	assign rs1 = instruction[8:6];
	assign rs2 = instruction[5:3];
	
	wire [8:0] imm_i;
	wire [11:0] imm_j;
	wire [7:0] imm8;
	wire [7:0] pc_imm;
	
	assign imm_i = instruction[8:0];
	assign imm_j = instruction[11:0];
	assign imm8 = imm_i[7:0];
	assign pc_imm = imm_j[7:0];
	
	wire[7:0]pc_plus1;
	assign pc_plus1 = pc+8'd1;
	
	always @(*) begin
		case(pc_sel)
			PC_PLUS1: next_pc = pc_plus1;
			PC_IMM: next_pc = pc_imm;
			default: next_pc = pc_plus1;
		endcase
	end
	
	always @(posedge clk or posedge reset) begin
		if(reset)
			pc <= 8'd0;
		else if(pc_we)
			pc <= next_pc;
		end
		
		wire [15:0]instr_from_mem;
		
		instr_mem u_instr_mem(
			.addr(pc),
			.instruction(instr_from_mem)
		);
		
		always @(posedge clk or posedge reset) begin
			if(reset)
				ir <= 16'd0;
			else if(ir_we)
				ir <= instr_from_mem;
			end
			
			assign instruction = ir;
			
			wire[2:0]raddr1;
			wire[2:0]raddr2;
			
			// R-type: raddr1= rs1
			// I-type ST: raddr1= rd
			// JZ-type: raddr1= rd
			
			localparam OP_ST = 4'h7;
			assign raddr1 = (opcode == OP_ST || opcode == OP_JZ) ? rd: rs1;
			assign raddr2 = rs2;
			
			wire[7:0]rs1_data;
			wire[7:0]rs2_data;
			reg[7:0]wb_data;
			
			register_file2 u_reg_file(
				.clk(clk),
				.reset(reset),
				.we(rf_we),
				.waddr(rd),
				.raddr1(raddr1),
				.raddr2(raddr2),
				.wdata(wb_data),
				.rdata1(rs1_data),
				.rdata2(rs2_data)
			);
			
			assign jz_zero = (rs1_data == 8'd0);
			
			wire [7:0]alu_result;
			
			wire overflow, carry, zero_alu;
			
			alu_para #(.WIDTH(8)) u_alu(
				.a(rs1_data),
				.b(rs2_data),
				.sel(alu_sel),
				.result(alu_result),
				.overflow(overflow),
				.carry(carry),
				.zero(zero_alu)
			);
			
			wire[7:0]mem_rdata;
			
			data_mem u_data_mem(
				.clk(clk),
				.we(mem_we),
				.addr(imm8),
				.wdata(rs1_data),
				.rdata(mem_rdata)
			);
			
			always @(*) begin
				case(wb_sel)
					WB_ALU: wb_data = alu_result;
					WB_MEM: wb_data = mem_rdata;
					WB_IMM: wb_data = imm8;
					default: wb_data = alu_result;
				endcase
			end
endmodule
