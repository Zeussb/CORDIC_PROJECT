module pre_rodation (
	input wire signed [31:0] data_in_z,
	output wire signed [31:0] x_pre,
	output wire signed [31:0] y_pre,
	output wire signed [31:0] angle_pre
);
	wire signed [31:0] K_gain;
	reg signed [31:0] angle_reg;
	reg signed [31:0] x_reg;
	reg signed [31:0] y_reg;
	
	
	assign K_gain = 32'h26DD3B6A;
	always@ (data_in_z) begin
		if(data_in_z[31] == 1'b0) begin
			case(data_in_z[29:28])
				2'b00: begin
					x_reg = K_gain;
					y_reg = 32'sd0;
					angle_reg = data_in_z;
				end
				2'b01: begin
					x_reg = 32'sd0;
					y_reg = K_gain;
					angle_reg = data_in_z - 32'sh10000000;
				end
				2'b10: begin
					x_reg = -K_gain;
					y_reg = 32'sd0;
					angle_reg = data_in_z - 32'sh20000000;
				end
				2'b11: begin
					x_reg = 32'sd0;
					y_reg = -K_gain;
					angle_reg = data_in_z - 32'sh30000000;					
				end
				default: begin
					x_reg = K_gain;
					y_reg = 32'sd0;
					angle_reg = data_in_z;				
				end
			endcase
		end
		else begin
			case(data_in_z[29:28])
				2'b00: begin
					x_reg = K_gain;
					y_reg = 32'sd0;
					angle_reg = data_in_z - 32'shC0000000;				
				end
				2'b01: begin
					x_reg = 32'sd0;
					y_reg = K_gain;
					angle_reg = data_in_z + 32'sh30000000;				
				end
				2'b10: begin
					x_reg = -K_gain;
					y_reg = 32'sd0;
					angle_reg = data_in_z + 32'sh20000000;				
				end
				2'b11: begin
					x_reg = K_gain;
					y_reg = 32'sd0;
					angle_reg = data_in_z;				
				end
				default: begin
					x_reg = K_gain;
					y_reg = 32'sd0;
					angle_reg = data_in_z;				
				end
			endcase
		end
	end 
	
	assign x_pre = x_reg;
	assign y_pre = y_reg;
	assign angle_pre = angle_reg;
endmodule 
	