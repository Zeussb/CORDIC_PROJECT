module pre_vectoring (
	input wire signed [31:0] data_in_x,
	input wire signed [31:0] data_in_y,
	output wire signed [31:0] x_pre,
	output wire signed [31:0] y_pre,
	output wire signed [31:0] angle_pre
);
	wire [1:0] sel;
	reg signed [31:0] angle_reg;
	reg signed [31:0] x_reg;
	reg signed [31:0] y_reg;
	assign sel = {data_in_y[31],data_in_x[31]};
	
	always@(data_in_x or data_in_y) begin
		case(sel)
			2'b00: begin // GOC PHAN TU THU 1
				x_reg = data_in_x;
				y_reg = data_in_y;
				angle_reg = 32'sd0;
			end
			2'b01: begin  //GOC PHAN TU THU 2
				x_reg = data_in_y;
				y_reg = -data_in_x;
				angle_reg = 32'sh10000000;
			end
			2'b10: begin  //GOC PHAN TU THU 4
				x_reg = data_in_x;
				y_reg = data_in_y;
				angle_reg = 32'sh40000000;	
			end
			2'b11: begin
				x_reg = -data_in_x;
				y_reg = -data_in_y;
				angle_reg = 32'sh20000000;				
			end
		endcase
	end
	assign x_pre = x_reg;
	assign y_pre = y_reg;
	assign angle_pre = angle_reg;
endmodule
