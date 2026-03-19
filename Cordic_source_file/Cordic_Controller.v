module Cordic_Controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire done_stage_19,
	 output wire  [1:0] state,
    output wire load_en_in,
    output wire enable_output
);
    localparam [1:0]
        IDLE = 2'b00,
        EXECUTE = 2'b01,
        ENABLE_PRINT_OUTPUT = 2'b10;
    reg [1:0] current_state, next_state;
	 reg load_en_reg, enable_output_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) 
            current_state <= IDLE;
        else 
            current_state <= next_state;
    end


    always @(start or current_state or done_stage_19) begin
        case(current_state)
            IDLE:
                if(start) begin
                    next_state = EXECUTE;
                end else begin
                    next_state = IDLE;
                end
            EXECUTE:
                if(done_stage_19)
                    next_state = ENABLE_PRINT_OUTPUT;
                else
                    next_state = EXECUTE;
            ENABLE_PRINT_OUTPUT:
                if(start)
                    next_state = EXECUTE;
                else
                    next_state = ENABLE_PRINT_OUTPUT;
            default:
                next_state = IDLE;
        endcase
    end
    

    always @(current_state) begin
        case(current_state)
            IDLE: begin
                load_en_reg = 1'b0;
                enable_output_reg = 1'b0;
            end
            EXECUTE: begin
                load_en_reg = 1'b1;
                enable_output_reg = 1'b0;
            end
            ENABLE_PRINT_OUTPUT: begin
                load_en_reg = 1'b0;
                enable_output_reg = 1'b1;
            end
            default: begin
                load_en_reg = 1'b0;
                enable_output_reg = 1'b0;
            end
        endcase
    end
	 assign load_en_in = load_en_reg;
	 assign enable_output = enable_output_reg;
	 assign state = current_state;
endmodule

