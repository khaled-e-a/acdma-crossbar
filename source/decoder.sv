import AggrCDMAPkg::*;
module decoder 	#(
	parameter CODE_NUM = 0
	) (
	input clk,    // Clock
	input rst,  // Synchronous reset active high
	input  logic rotate_code,
	input  logic [COUNTER_WIDTH-1:0] counter,
	input  logic [DATA_WIDTH+LOG_CODE_WIDTH-1:0] channel,
	output logic [DATA_WIDTH-1:0] decoded
);

logic [CDMA_CODE_WIDTH-1:0] code_reg;
logic [DATA_WIDTH + 2*LOG_CODE_WIDTH -2:0] acc, acc_input, srcA, srcB;
logic chip, srcC;
// Rotate code
always_ff @(posedge clk) begin : proc_code_reg
	if(counter == {COUNTER_WIDTH{1'b1}}) begin
		code_reg <= CDMA_CODES[CODE_NUM];
	end else if(rotate_code) begin		// Rotate code
		code_reg <= {code_reg[0], code_reg[CDMA_CODE_WIDTH-1:1]};	
	end
end


always@(posedge clk) begin
    acc = acc_input;
end

assign chip = code_reg[0];

always@(*) begin
    if(chip == 0) begin
        //srcB = {channel[DATA_WIDTH+LOG_CODE_WIDTH-1], channel};
        srcB = {1'b0, channel};
        srcC = 0;
    end else begin
        //srcB = ~{channel[DATA_WIDTH+LOG_CODE_WIDTH-1], channel};
        srcB = {1'b0, ~channel};
        srcC = 1;
    end

    if(counter == 0)
    	srcA = 0;
    else
    	srcA = acc;
end
assign acc_input = srcA + srcB + srcC;
assign decoded = acc >> LOG_CODE_WIDTH;

endmodule