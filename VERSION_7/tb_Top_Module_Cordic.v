`timescale 1ns / 1ps

module tb_Top_Module_Cordic;

    // Parameters
    parameter W = 32;
    parameter N = 20;
    parameter CLK_PERIOD = 10; // 10ns = 100MHz

    // Signals
    reg clk;
    reg rst;
	 reg start;
	 reg mode;
    reg signed [W-1:0] data_in_x;
    reg signed [W-1:0] data_in_y;
    reg signed [W-1:0] data_in_z;
    wire signed [W-1:0] data_out_x;
    wire signed [W-1:0] data_out_y;
    wire signed [W-1:0] data_out_z;
	 wire [1:0] state;
	 wire signed [31:0] out_pipe_x0, out_pipe_y0, out_pipe_z0;
	 wire signed [31:0] out_pipe_x1, out_pipe_y1, out_pipe_z1;
	 wire signed [31:0] out_pipe_x2, out_pipe_y2, out_pipe_z2;
    wire signed [31:0] out_pipe_x3, out_pipe_y3, out_pipe_z3;
	 wire signed [31:0] out_pipe_x4, out_pipe_y4, out_pipe_z4;
	 wire signed [31:0] out_pipe_x5, out_pipe_y5, out_pipe_z5;	 
	 wire signed [31:0] out_pipe_x6, out_pipe_y6, out_pipe_z6;
	 wire signed [31:0] out_pipe_x7, out_pipe_y7, out_pipe_z7; 
	 wire signed [31:0] out_pipe_x8, out_pipe_y8, out_pipe_z8;
	 wire signed [31:0] out_pipe_x9, out_pipe_y9, out_pipe_z9;
	 wire signed [31:0] out_pipe_x10, out_pipe_y10, out_pipe_z10;
	 wire signed [31:0] out_pipe_x11, out_pipe_y11, out_pipe_z11;
	 wire signed [31:0] out_pipe_x12, out_pipe_y12, out_pipe_z12;
	 wire signed [31:0] out_pipe_x13, out_pipe_y13, out_pipe_z13;
	 wire signed [31:0] out_pipe_x14, out_pipe_y14, out_pipe_z14;
	 wire signed [31:0] out_pipe_x15, out_pipe_y15, out_pipe_z15;
	 wire signed [31:0] out_pipe_x16, out_pipe_y16, out_pipe_z16;
	 wire signed [31:0] out_pipe_x17, out_pipe_y17, out_pipe_z17;
	 wire signed [31:0] out_pipe_x18, out_pipe_y18, out_pipe_z18;
	 wire signed [31:0] out_pipe_x19, out_pipe_y19, out_pipe_z19;
    // Real number for monitor
    real x_real, y_real, z_real;
    real magnitude, angle_deg;

    // Instantiate DUT
    Top_Module_Cordic DUT (
        .clk(clk),
        .rst(rst),
		  .start(start),
		  .mode(mode),
        .data_in_x(data_in_x),
        .data_in_y(data_in_y),
        .data_in_z(data_in_z),
        .data_out_x(data_out_x),
        .data_out_y(data_out_y),
        .data_out_z(data_out_z),
		  .state(state),
		  .out_pipe_x0(out_pipe_x0), .out_pipe_y0(out_pipe_y0), .out_pipe_z0(out_pipe_z0),
		  .out_pipe_x1(out_pipe_x1), .out_pipe_y1(out_pipe_y1), .out_pipe_z1(out_pipe_z1),
		  .out_pipe_x2(out_pipe_x2), .out_pipe_y2(out_pipe_y2), .out_pipe_z2(out_pipe_z2),
		  .out_pipe_x3(out_pipe_x3), .out_pipe_y3(out_pipe_y3), .out_pipe_z3(out_pipe_z3),
    	  .out_pipe_x4(out_pipe_x4), .out_pipe_y4(out_pipe_y4), .out_pipe_z4(out_pipe_z4),
		  .out_pipe_x5(out_pipe_x5), .out_pipe_y5(out_pipe_y5), .out_pipe_z5(out_pipe_z5),
		  .out_pipe_x6(out_pipe_x6), .out_pipe_y6(out_pipe_y6), .out_pipe_z6(out_pipe_z6),
		  .out_pipe_x7(out_pipe_x7), .out_pipe_y7(out_pipe_y7), .out_pipe_z7(out_pipe_z7),
		  .out_pipe_x8(out_pipe_x8), .out_pipe_y8(out_pipe_y8), .out_pipe_z8(out_pipe_z8),
		  .out_pipe_x9(out_pipe_x9), .out_pipe_y9(out_pipe_y9), .out_pipe_z9(out_pipe_z9),
		  .out_pipe_x10(out_pipe_x10), .out_pipe_y10(out_pipe_y10), .out_pipe_z10(out_pipe_z10),
		  .out_pipe_x11(out_pipe_x11), .out_pipe_y11(out_pipe_y11), .out_pipe_z11(out_pipe_z11),
		  .out_pipe_x12(out_pipe_x12), .out_pipe_y12(out_pipe_y12), .out_pipe_z12(out_pipe_z12),
		  .out_pipe_x13(out_pipe_x13), .out_pipe_y13(out_pipe_y13), .out_pipe_z13(out_pipe_z13),
		  .out_pipe_x14(out_pipe_x14), .out_pipe_y14(out_pipe_y14), .out_pipe_z14(out_pipe_z14),
		  .out_pipe_x15(out_pipe_x15), .out_pipe_y15(out_pipe_y15), .out_pipe_z15(out_pipe_z15),
		  .out_pipe_x16(out_pipe_x16), .out_pipe_y16(out_pipe_y16), .out_pipe_z16(out_pipe_z16),
		  .out_pipe_x17(out_pipe_x17), .out_pipe_y17(out_pipe_y17), .out_pipe_z17(out_pipe_z17),
		  .out_pipe_x18(out_pipe_x18), .out_pipe_y18(out_pipe_y18), .out_pipe_z18(out_pipe_z18),
		  .out_pipe_x19(out_pipe_x19), .out_pipe_y19(out_pipe_y19), .out_pipe_z19(out_pipe_z19)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test procedure
    initial begin
        // Reset
        rst = 1;
        mode = 0; // Rotation mode
        data_in_x = 0;
        data_in_y = 0;
        data_in_z = 0;
        #20
        rst = 0;
		  #10
        // Load initial vector and angle (45°)
        // x_in = 1.0 (Q1.31) = 0x40000000
        // y_in = 0
        // z_in = π/4 = 0x6487ED51
		  data_in_x = 32'sh00000000;
        data_in_y = 32'sh40000000; 		  
		  mode = 1'b1;  // rodation mode test
		  start = 1'b1;
		  #10
        start = 1'b0;
		  data_in_x = 32'shE0000000;
        data_in_y = 32'shC8930A30; //330
		  #10
		  data_in_x = 32'shD2BEC333;
        data_in_y = 32'shD2BEC333; //315
		  #10
		  data_in_x = 32'shC8930A30;
        data_in_y = 32'shE0000000;	//45

	  #(CLK_PERIOD*1000);
        $stop;
    end

    // Dump waveform
    initial begin
        $dumpfile("cordic_tb.vcd");
        $dumpvars(0, tb_Top_Module_Cordic);
    end

endmodule