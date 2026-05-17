module alu_para#(parameter WIDTH = 8)(
	input [WIDTH-1:0]a,
	input [WIDTH-1:0]b,
	input [3:0]sel,
	output reg [WIDTH-1:0]result,
	output reg carry,
	output reg overflow,
	output wire zero
);
	assign zero = (result == {WIDTH{1'b0}});
	reg [WIDTH:0]temp;
	
	always @* begin
		result = {WIDTH{1'b0}};
		carry = 1'b0;
		overflow = 1'b0;
		temp = {(WIDTH+1){1'b0}};
		
		case(sel)
			4'h1: begin
				temp = {1'b0,a} + {1'b0,b};
				result = temp[WIDTH-1:0];
				carry = temp[WIDTH];
				overflow = (a[WIDTH-1] == b[WIDTH-1]) && (result[WIDTH-1] != a[WIDTH-1]);
			end
			4'h2: begin
				temp = {1'b0,a} - {1'b0,b};
				result = temp[WIDTH-1:0];
				carry = temp[WIDTH];
				overflow = (a[WIDTH-1] != b[WIDTH-1]) && (result[WIDTH-1] != a[WIDTH-1]);
			end
			4'h3: begin
				result = a&b;
			end
			4'h4: begin
				result = a|b;
			end
			4'h5: begin
				result = a^b;
			end
			4'h6: begin
				result = ~a;
			end
			4'h7: begin
				result = a>>1;
				carry = a[0];
			end
			4'h8: begin
				result = a<<1;
				carry = a[WIDTH-1];
			end
			
			default: begin
				result = {WIDTH{1'b0}};
				carry = 1'b0;
				overflow = 1'b0;
			end
		endcase
	end
endmodule
