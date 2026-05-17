// top_module.v

module top_module1(
	input clk,
	input reset
);
	wire [15:0] instruction;
	wire jz_zero;
	wire rf_we, mem_we, pc_we, ir_we;
	wire [3:0]alu_sel;
	wire [1:0]wb_sel, pc_sel;
	wire [2:0] state;
	
	control_unit u_cu(
		.clk(clk),
		.reset(reset),
		.instruction(instruction),
		.jz_zero(jz_zero),
		.rf_we(rf_we),
		.mem_we(mem_we),
		.pc_we(pc_we),
		.ir_we(ir_we),
		.alu_sel(alu_sel),
		.wb_sel(wb_sel),
		.pc_sel(pc_sel),
		.state(state)
);

	datapath u_dp(
		.clk(clk),
		.reset(reset),
		.rf_we(rf_we),
		.mem_we(mem_we),
		.pc_we(pc_we),
		.ir_we(ir_we),
		.alu_sel(alu_sel),
		.wb_sel(wb_sel),
		.pc_sel(pc_sel),
		.instruction(instruction),
		.jz_zero(jz_zero)
);

endmodule

		