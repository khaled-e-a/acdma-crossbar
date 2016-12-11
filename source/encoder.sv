import AggrCDMAPkg::*;
module encoder 
	#(
	parameter CODE_NUM = 0
	) (
	input clk,    // Clock
	input rst,  // Synchronous reset active high
	input  logic rotate_code,
	input  logic [COUNTER_WIDTH-1:0] counter,
	input  logic [DATA_WIDTH-1:0] data,
	output logic [DATA_WIDTH-1:0] encoded,
	output logic chip 
);

logic [CDMA_CODE_WIDTH-1:0] code_reg;

// Rotate code
always_ff @(posedge clk) begin : proc_code_reg
	if(counter == {COUNTER_WIDTH{1'b1}}) begin
		code_reg <= CDMA_CODES[CODE_NUM];
	end else if(rotate_code) begin		// Rotate code
		code_reg <= {code_reg[0], code_reg[CDMA_CODE_WIDTH-1:1]};	
	end
end


assign encoded = data ^ {(DATA_WIDTH){code_reg[0]}};

assign chip = code_reg[0];

endmodule